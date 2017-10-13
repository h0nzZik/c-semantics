module CPP-STMT-RETURN
     imports RETURN-SYNTAX
     imports CPP-STMT-RETURN-SYNTAX
     imports C-CONFIGURATION
     imports BOOL
     imports C-CHECK-LOC-SYNTAX
     imports C-IO-BUFFERED-SYNTAX
     imports C-SEQUENCE-POINT-SYNTAX
     imports CPP-BITSIZE-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-EXEC-ENV-SYNTAX
     imports CPP-MEMORY-ALLOC-SYNTAX
     imports CPP-SYNTAX
     imports CPP-TYPING-SYNTAX

     rule runtimeReturn => exitRestrictBlock(.Set) ~> sequencePoint
endmodule

module C-CPP-STMT-RETURN
     imports CPP-STMT-RETURN
     imports C-DYNAMIC-SYNTAX
     imports C-TYPING-SYNTAX

     rule <k> return(V:RValue => convertValToCPP(V)) ...</k>
          <call-stack>
               ListItem(
                    <call-stack-frame>...
                         <stack-lang-linkage> CPPLinkage </stack-lang-linkage>
                    ...</call-stack-frame>
               )
          ...</call-stack>

     syntax PRVal ::= convertValToCPP(RValue) [function]
     rule convertValToCPP(tv(V::CValue, T::UType)) => prv({V}:>CPPValue, noTrace, convertTypeToCPP(type(T)))
          requires isCPPValue(V)
     rule convertValToCPP(voidVal) => prv(voidVal, noTrace, type(void))

endmodule
