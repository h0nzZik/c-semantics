module CPP-COMMON-EXPR-FUNCTION-CALL-SYNTAX
     imports COMMON-SYNTAX
     imports SYMLOC-SYNTAX
     imports CPP-TYPING-SORTS
     imports CPP-DYNAMIC-SYNTAX // BlockScope
     syntax Expr ::= evalArgs(CabsLoc, SymBase, fun: K, CPPType, Bool, args: StrictList)
     syntax KItem ::= runtimeFunctionApplication(BlockScope)
endmodule

module CPP-COMMON-EXPR-FUNCTION-CALL
     imports BASIC-K
     imports INT
     imports BITS-SYNTAX

     imports C-TYPING-COMMON-SYNTAX
     imports COMMON-FUNCTION-CALL-SYNTAX

     imports C-CONFIGURATION
     imports C-TYPING-SYNTAX

     imports CPP-SYNTAX
     imports CPP-COMMON-EXPR-FUNCTION-CALL-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-TYPING-SYNTAX
     imports CPP-BINDING-SYNTAX // bind, setThis


     rule BuiltinCallOp(lv(_, _, T:CPPPointerType) #as L::LVal => * L, false, _)
          requires isCPPFunctionType(innerType(T))
     context BuiltinCallOp((* _) #as HOLE:Expr, false, _)

     // Function call (from C++ function)
     rule BuiltinCallOp(lv((loc(Base::SymBase, Offset::Int, _) => loc(Base, Offset)), _, _:CPPFunctionType), _, _)
     rule <k> BuiltinCallOp(lv(loc((Base::SymBase => Base'), _), _, _:CPPFunctionType), _, _) ...</k>
          <linkings>... Base |-> Base'::SymBase ...</linkings>

     rule <k> BuiltinCallOp(lv(loc(Base::SymBase, 0), _, T:CPPFunctionType), IsVirtual:Bool, Args::List)
              => prepareArguments(CurrLoc, Base, Fun, T, IsVirtual, Args)
          ...</k>
          <functions>... Base |-> Fun:K ...</functions>
          <curr-program-loc> CurrLoc::CabsLoc </curr-program-loc>
          requires isDirectBase(Base) orBool (isMethodPure(T) andBool IsVirtual)

     syntax Expr ::= prepareArguments(CabsLoc, SymBase, K, CPPType, Bool, List)

     rule prepareArguments(CurrLoc::CabsLoc, Base::SymBase, Fun:K, CallT::CPPType, IsVirtual::Bool, Args::List)
          => evalArgs(CurrLoc, Base, Fun, CallT, IsVirtual, list(mapList(Args, #klabel(`allowInit`))))

     // evaluating arguments for call to C function
     context evalArgs(... fun: functionObject(_::CId, _, _), args: HOLE:StrictList => prval(HOLE))
     // evaluating arguments for call to C++ function
     context evalArgs(... fun: functionObject(_::QualId, _, _, _), args: HOLE:StrictList)


     rule evalArgs(CurrLoc::CabsLoc, Base::SymBase, Fun:K, CallT::CPPType, false, krlist(Args::List))
          => application(CurrLoc, Base, Fun, CallT, CPPLinkage, krlist(Args))
     // Function call (into C++ function)
     rule <k> application(CurrLoc::CabsLoc, Base::SymBase,
                    functionObject(X::QualId, DefT::CPPFunctionType, Params::List, Blk:K),
                    _, CallingLang::LanguageLinkage, krlist(L::List))
              ~> K:K
              => runtimeFunctionApplication(blockScope(X, Base, 0))
              ~> #if Obj ==K .K #then .K #else setThis(& Obj) #fi
              ~> bind(Params, getParams(DefT), L)
              ~> Blk
          </k>
          <call-stack> .List => ListItem(
               <call-stack-frame>
                    <continuation> K:K </continuation>
                    <stack-function-control>
                         <function-control> C 
                              <constructing> Obj </constructing> 
                              <curr-program-loc> CurrLoc </curr-program-loc>
                              <most-derived-class> MDC </most-derived-class>
                         </function-control>
                    </stack-function-control>
                    <stack-lang-linkage> CallingLang </stack-lang-linkage>
               </call-stack-frame>
          ) ...</call-stack>
          (<function-control> C::Bag 
               <constructing> Obj:K </constructing>
               <curr-program-loc> _ </curr-program-loc>
               <most-derived-class> MDC:K </most-derived-class>
          </function-control>
          => <function-control>...
               <curr-tu> getTU(Base) </curr-tu>
               <curr-scope> blockScope(X, Base, 0) </curr-scope>
               <curr-program-loc> CurrLoc </curr-program-loc>
               <most-derived-class> MDC </most-derived-class>
          ...</function-control>)

     rule <k> bindParam(X::CId, T::CPPType, V:Val) => declareNonStaticObjectExec(X, T, 
               ExecName(NoNNS(), X) := V,
               Var(CopyInit()), AutoStorage, .Set) ...</k>
          <curr-function-params>... .List => ListItem(X) </curr-function-params>       
          requires notBool isCPPRefType(T)
               andBool X =/=K #NoName
     rule <k> bindParam(X::CId, T::CPPType, V:Val) => declareNonStaticObjectExec(X, T,
               bindReference(ExecName(NoNNS(), X), V),
               Var(CopyInit()), AutoStorage, .Set) ...</k>
          <curr-function-params>... .List => ListItem(X) </curr-function-params>       
          requires isCPPRefType(T)
               andBool X =/=K #NoName

     rule bindParam(#NoName, T::CPPType, V:Val) => declareNonStaticObjectExec(#NoName, T, V,
               Var(CopyInit()), AutoStorage, .Set)

endmodule

