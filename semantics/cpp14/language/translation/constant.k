module CPP-TRANSLATION-CONSTANT-SYNTAX
     imports BASIC-K
     imports CPP-SORTS

     syntax Expr ::= compileTimeEval(K)
     syntax Expr ::= evalCoreConstantExpression(Expr)
     syntax Expr ::= evalConstantExpression(Expr)

endmodule

module CPP-TRANSLATION-CONSTANT
     imports CPP-TRANSLATION-CONSTANT-SYNTAX
     imports CPP-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports C-CONFIGURATION

     rule <k> compileTimeEval(K::K) => K ~> compileTimeEvalDone(B) ...</k>
          <evaluating> B::Bool => true </evaluating>

     syntax KItem ::= compileTimeEvalDone(Bool)
     rule <k> compileTimeEvalDone(B::Bool) => .K ...</k>
     <evaluating> _ => B </evaluating>

     rule <k> V:Val ~> compileTimeEvalDone(B::Bool) => V ...</k>
     <evaluating> _ => B </evaluating>
     requires isEvalVal(V)

     syntax KItem ::= evalCoreConstantExpressionHole(Bool)
     rule <k> evalCoreConstantExpression(E::Expr) => E ~> evalCoreConstantExpressionHole(B) ...</k>
          <evaluating> B::Bool => true </evaluating>
          requires notBool isEvalVal(E)

     // TODO some ill-formed result?
     rule <k> V:Val ~> evalCoreConstantExpressionHole(B::Bool) => evalCoreConstantExpression(V) ...</k>
          <evaluating> _ => B </evaluating>
          requires isEvalVal(V)

     syntax KItem ::= "evalConstantExpressionHole"
     rule evalConstantExpression(E::Expr) => evalCoreConstantExpression(E) ~> evalConstantExpressionHole
          requires notBool isEvalVal(E)

     rule evalCoreConstantExpression(V:Val) ~> evalConstantExpressionHole => checkEvaluatedConstantExpression(V)
          requires isEvalVal(V)

     syntax KItem ::= checkEvaluatedConstantExpression(Val)
     // TODO implement this
     rule checkEvaluatedConstantExpression(V::Val) => evalConstantExpression(V)


endmodule

