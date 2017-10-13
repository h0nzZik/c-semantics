module CPP-STMT-BLOCK
     imports C-CONFIGURATION
     imports COMPAT-SYNTAX
     imports CPP-ENV-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-SYNTAX
     imports CPP-STMT-BLOCK-SYNTAX

     rule <k> pushBlock(Tag::Int) => pushLocals ...</k>
          <curr-tr-scope> blockScope(_, _, (_ => Tag)) </curr-tr-scope>
          <tr-block-history> .List => ListItem(Tag) ...</tr-block-history>
          <elab>... .K => pushBlock(Tag) </elab>
          requires Translation()
     rule <k> popBlock => popLocals ~> setScope(blockScope(F, Base, Tag)) ...</k>
          <curr-tr-scope> blockScope(F::QualId, Base::SymBase, _) </curr-tr-scope>
          <tr-block-history> (ListItem(_) => .List) ListItem(Tag::Int) ...</tr-block-history>
          <elab>... .K => popBlock </elab>
          requires Translation()
     rule <k> popBlock => popLocals ~> setScope(blockScope(F, Base, 0)) ...</k>
          <curr-tr-scope> blockScope(F::QualId, Base::SymBase, _) </curr-tr-scope>
          <tr-block-history> (ListItem(_) => .List) </tr-block-history>
          <elab>... .K => popBlock </elab>
          requires Translation()

     rule BlockStmt(Tag::Int, L::List) => pushBlock(Tag) ~> listToK(L) ~> popBlock

     rule runtimePopBlock(_) => .K

endmodule
