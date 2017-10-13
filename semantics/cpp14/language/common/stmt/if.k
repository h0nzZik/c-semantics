module CPP-COMMON-STMT-IF
     imports INT
     imports K-EQUAL
     imports BITS-SYNTAX
     //imports C-SEQUENCE-POINT-SYNTAX
     imports CPP-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-TYPING-SYNTAX

     context IfStmt(HOLE:Expr, _, _) [result(PRV)]

     // TODO prinest ty sequence pointy i do compile time, abychom dokazali poznat nedefinovane chovani
     rule IfStmt(prv((unknown(I::Int) => #if I ==Int 0 #then 0 #else 1 #fi), _, T:CPPBoolType), _, _)

     rule IfStmt(prv(1, _, T:CPPBoolType), S::Stmt, _) => cppFullExpression ~> S
     rule IfStmt(prv(0, _, T:CPPBoolType), _, S::Stmt) => cppFullExpression ~> S

endmodule
