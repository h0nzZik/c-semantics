module CPP-COMMON-DECL-DECLARATOR-SYNTAX
     // TODO clean this
     imports SET
     imports COMMON-SYNTAX
     imports SYMLOC-SYNTAX
     imports CPP-TYPING-SORTS
     imports SYMLOC-SORTS

     syntax KItem ::= possiblyInitializeObject(K)    
     syntax KItem ::= possiblyMarkAsConstexpr(SymBase, Set)
endmodule

module CPP-COMMON-DECL-DECLARATOR
     imports CPP-COMMON-DECL-DECLARATOR-SYNTAX
     imports C-CONFIGURATION
     imports K-EQUAL
     imports CPP-BITSIZE-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-EXEC-ENV-SYNTAX
     imports CPP-MEMORY-ALLOC-SYNTAX
     imports CPP-SYMLOC-SYNTAX
     imports CPP-SYNTAX
     imports CPP-TYPING-SYNTAX

     rule <k> declareNonStaticObjectExec(X::CId, T::CPPType, Init::Expr, Var(_), AutoStorage, Mods::Set)
              => #if notBool isCPPRefType(T) #then allocObject(bnew(!I:Int, T, Mods, D), T, byteSizeofType(T)) #else .K #fi
              ~> addToExecEnv(X, T, bnew(!I:Int, T, Mods, D), false)
              ~> possiblyMarkAsConstexpr(bnew(!I:Int, T, Mods, D), Mods)
              ~> possiblyInitializeObject(Init)
          ...</k>
          <duration> D::Duration </duration>
          <local-vars> Vars:Set (.Set => SetItem(X)) </local-vars>
          <local-addresses>... .Set => SetItem(bnew(!I:Int, T, Mods, D)) ...</local-addresses>
          requires notBool X in Vars andBool X =/=K #NoName

     rule declareNonStaticObjectExec(#NoName, _, Init::Expr, _, _, _) => ExpressionStmt(Init)
 endmodule
