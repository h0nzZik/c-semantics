module CPP-DECL-DECLARATOR
     imports CPP-COMMON-DECL-DECLARATOR-SYNTAX
     imports C-CONFIGURATION
     imports K-EQUAL
     imports C-SEQUENCE-POINT-SYNTAX
     imports CPP-BITSIZE-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-EXEC-ENV-SYNTAX
     imports CPP-MEMORY-ALLOC-SYNTAX
     imports CPP-SYMLOC-SYNTAX
     imports CPP-SYNTAX
     imports CPP-TYPING-SYNTAX

     rule declareLocalStaticObject(X::CId, Base::SymBase, T::CPPType)
          => addToExecEnv(X, T, Base, false)

     rule <k> possiblyInitializeObject(Init::Expr) 
              => allowInit(ExpressionStmt(Init))
              ~> sequencePoint
          ...</k>
          <should-init> true </should-init>


     rule possiblyMarkAsConstexpr(B::SymBase, S::Set) => .K

endmodule

