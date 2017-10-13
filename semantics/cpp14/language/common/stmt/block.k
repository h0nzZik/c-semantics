module CPP-STMT-BLOCK-SYNTAX
     imports CPP-SYNTAX
     imports SET
     syntax KItem ::= runtimePopBlock(Set)
endmodule

module CPP-COMMON-STMT-BLOCK
     imports C-CONFIGURATION
     imports INT
     imports CPP-BUILTIN-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-EXEC-ENV-SYNTAX
     imports CPP-SYMLOC-SYNTAX
     imports CPP-SYNTAX
     imports CPP-TYPE-MAP-SYNTAX
     imports CPP-STMT-BLOCK-SYNTAX

     rule <k> pushBlock(Tag:Int)
               => addToHistory(Tag) ~> cppEnterRestrictBlock(blockScope(F, Base, Tag))
          ...</k>
          <curr-scope> blockScope(F::QualId, Base::SymBase, (_ => Tag)) </curr-scope>
          <block-control>
               C::Bag
               <catch-handlers> Catch::List => .List </catch-handlers>
               <local-vars> Vars::Set => .Set </local-vars>
               <local-addresses> Addresses::Set => .Set </local-addresses>
               <locally-constructed> Constructed::List => .List </locally-constructed>
          </block-control>
          <block-stack> .List
               => ListItem(<block-control>
                    C
                    <catch-handlers> Catch </catch-handlers>
                    <local-vars> Vars </local-vars>
                    <local-addresses> Addresses </local-addresses>
                    <locally-constructed> Constructed </locally-constructed>
               </block-control>)
          ...</block-stack>
          requires Execution()

     syntax KItem ::= "updateScope"

     rule <k> updateScope => .K ...</k>
          <curr-scope> blockScope(_, _, (_ => Tag)) </curr-scope>
          <block-history> ListItem(Tag::Int) ...</block-history>
     rule <k> updateScope => .K ...</k>
          <curr-scope> blockScope(_, _, (_ => 0)) </curr-scope>
          <block-history> .List </block-history>

    
     // isException is true only for the top-level block of a constructor, which is destructed
     // in execution/stmt/try.k instead of here.
     rule <k> popBlock => destructLocals(false) ~> unfoldBlockStack ~> runtimePopBlock(Locals) ~> updateScope ...</k>
          <local-addresses> Locals::Set </local-addresses>
          requires Execution()
          [structural]

     // we have to atomically remove the item from locally-constructed and call the destructor as a single operation
     // because the destructor could throw an exception that unwinds back through this block, in which case the 
     // destructor should not be called again. See http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#2176
     rule <k> (.K => #if IsConstructor andBool notBool IsException #then .K #else destruct(V, CanBeVirtual) ~> cppFullExpression #fi) 
              ~> destructLocals(IsException:Bool)
          ...</k>
          <locally-constructed> ListItem(ktriple(lv(Loc::SymLoc, _, _) #as V::LVal, CanBeVirtual::Bool, IsConstructor:Bool)) => .List ...</locally-constructed>
     rule <k> destructLocals(...) => .K ...</k>
          <locally-constructed> .List </locally-constructed>
     syntax KItem ::= "unfoldBlockStack"
     rule <k> unfoldBlockStack => .K ...</k>
          (<block-control>... .Bag ...</block-control> => C)
          <block-stack> ListItem(C:BlockControlCell) => .List ...</block-stack>

     syntax KItem ::= destruct(LVal, canBeVirtual: Bool)

     // we don't need an explicit type conversion here because the type of the implicit parameter is already the same
     // as the type of the address taken unless the function is virtual, which is handled elsewhere.
     rule <k> destruct(lv(_, _, t(... st: classType(_ :: Class(_, X::CId, _) #as C::Class)) #as T::CPPClassType) #as V::LVal, CanBeVirtual:Bool)
              => ExpressionStmt(BuiltinCallOp(lv(lnew(Base), noTrace, FuncT),
                   CanBeVirtual andBool isMethodVirtual(FuncT),
                   ListItem(getAddress(V))))
          ...</k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          <class-id> C </class-id>
          <cenv>... DestructorId(X) |-> (FuncT::CPPFunctionType |-> envEntry(... base: Base::SymBase)) ...</cenv>


endmodule
