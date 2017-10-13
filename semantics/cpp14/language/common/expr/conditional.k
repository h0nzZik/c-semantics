module CPP-COMMON-EXPR-CONDITIONAL
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-TYPING-SYNTAX
     imports CPP-SYNTAX
     imports C-CONFIGURATION

     context ConditionalOp(... cond: (HOLE:Expr => reval(HOLE))) [result(PRV)]

     rule ConditionalOp(prv(0, _, _), _, E::Expr, prvalue, T::CPPType)
          => ConvertType(T, makePRVal(E))
     rule ConditionalOp(prv(1, _, _), E::Expr, _, prvalue, T::CPPType)
          => ConvertType(T, makePRVal(E))
     rule ConditionalOp(prv(0, _, _), _, E::Expr, lvalue, T::CPPType)
          => setType(T, E)
     rule ConditionalOp(prv(1, _, _), E::Expr, _, lvalue, T::CPPType)
          => setType(T, E)

endmodule
