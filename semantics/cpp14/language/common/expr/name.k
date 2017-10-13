module CPP-COMMON-EXPR-NAME
     imports C-CONFIGURATION
     imports K-EQUAL
     imports CPP-SYNTAX
     imports CPP-TYPE-MAP-SYNTAX
     imports CPP-TYPING-SYNTAX
     imports CPP-SYMLOC-SYNTAX  // lnew
     imports CPP-DYNAMIC-SYNTAX // NoNNS
     imports CPP-BITSIZE-SYNTAX // byteSizeofType
     imports CPP-MEMORY-ALLOC-SYNTAX // allocObject
     imports CPP-EXEC-ENV-SYNTAX // addToExecEnv
     imports CPP-CONVERSION-SYNTAX // instantiate
     imports CPP-MEMORY-READING-SYNTAX // read


     rule <k> ExecName(NoNNS(), X:CId) => lv(lnew(getBase(Entry)), noTrace, T) ...</k>
          <env>... X |-> (T::CPPType |-> Entry::EnvEntry) ...</env>

     rule <k> ExecName(NoNNS(), X:CId) => T ...</k>
          <types>... X |-> T::CPPType ...</types>

     rule <k> temp(I::Int, T::CPPType) => ExecName(NoNNS(), #NoName(I)) ...</k>
          <env> Env::Map </env>
          requires #NoName(I) in_keys(Env) andBool Execution()

     // TODO(dwightguth): temporaries need to be deleted at the end of the full expression, except
     // for the exception object (see translation/stmt/try.k), which is deleted at the end of the
     // catch statement.
     rule <k> temp(I::Int, T::CPPType) 
              => #if isCPPRefType(T) #then .K #else allocObject(bnew(!I:Int, T, .Set, D), T, byteSizeofType(T)) #fi
              ~> addToExecEnv(#NoName(I), T, bnew(!I:Int, T, .Set, D), false)
              ~> lv(lnew(bnew(!I:Int, T, .Set, D)), noTrace, T) ...</k>
          <env> Env::Map </env>
          <duration> D::Duration </duration>
          requires notBool (#NoName(I) in_keys(Env)) andBool Execution()

     // instantiate lives here for similarity to C semantics. Maybe we should move both?
     rule instantiate(Loc::SymLoc, Tr::Trace, T::CPPType) => read(Loc, Tr, T)
          requires Execution()

endmodule
