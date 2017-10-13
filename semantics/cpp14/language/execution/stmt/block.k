module CPP-STMT-BLOCK
     imports C-CONFIGURATION
     imports INT
     imports CPP-BUILTIN-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-EXEC-ENV-SYNTAX
     imports CPP-SYMLOC-SYNTAX
     imports CPP-SYNTAX
     imports CPP-TYPE-MAP-SYNTAX
     imports CPP-STMT-BLOCK-SYNTAX
     imports C-IO-BUFFERED-SYNTAX
     imports C-CHECK-LOC-SYNTAX

     rule runtimePopBlock(S::Set) => deleteObjects(S) ~> exitRestrictBlock(S)

     rule <k> addToConstructed(L:LVal, T:CPPClassType) => .K ...</k>
          <locally-constructed> .List => ListItem(ktriple(L, false, false)) ...</locally-constructed>
     rule (.K => addToConstructed(L [ prv(N -Int 1, noTrace, type(size_t)) ], T))
          ~> addToConstructed(L:LVal, t(... st: arrayType(T::CPPType, N::Int => N -Int 1)))
          requires N >Int 0
     rule addToConstructed(_, t(... st: arrayType(_, 0))) => .K

endmodule
