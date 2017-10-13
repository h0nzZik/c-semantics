module CPP-STMT-GOTO
     imports CPP-SYNTAX
     imports C-CONFIGURATION
     imports CPP-DYNAMIC-SYNTAX

     rule <k> GotoStmt(Lbl::CId) => .K ...</k>
          <elab>... .K => GotoStmt(Lbl) </elab>
          requires Translation()
endmodule
