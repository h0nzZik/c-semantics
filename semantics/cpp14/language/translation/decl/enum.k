module CPP-DECL-ENUM-SYNTAX
     imports BOOL-SYNTAX
     imports LIST
     imports COMMON-SORTS
     imports CPP-SORTS
     imports CPP-TYPING-SYNTAX
endmodule

module CPP-DECL-ENUM
     imports CPP-DECL-ENUM-SYNTAX
     imports C-CONFIGURATION
     imports COMMON-SYNTAX
     imports COMPAT-SYNTAX
     imports CPP-ABSTRACT-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-ENV-SYNTAX
     imports CPP-SYNTAX
     imports CPP-BITSIZE-SYNTAX

     syntax CPPEnumType ::= declareEnumName(ns: Namespace, id: CId, ut: CPPIntegerType, scoped: Bool) [function]
     rule declareEnumName(N::Namespace, X::CId, UT::CPPIntegerType, false) => t(noQuals, .Set, unscopedEnum(enumId(N::Namespace :: X), UT))
     rule declareEnumName(N::Namespace, X::CId, UT::CPPIntegerType, true)  => t(noQuals, .Set,   scopedEnum(enumId(N::Namespace :: X), UT))

     syntax KItem ::= addToCurrentNamespace(CId, CPPEnumType)
     rule <k> addToCurrentNamespace(X::CId, E::CPPEnumType) => . ... </k>
          <curr-scope> namespaceScope(N::Namespace) </curr-scope>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          <ns-id> N </ns-id>
          <ntypes> NT::Map => NT[X, Enum() <- E] </ntypes>

     // second param -underlying type
     syntax KItem ::= newEnum(CPPEnumType)

     rule <k> newEnum(E:CPPEnumType) => . ... </k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          (.Bag => <cppenum>...
               <enum-id> getEnumId(E) </enum-id>
               <enum-ut> underlyingType(E) </enum-ut>
               <scoped> getScoped(E) </scoped>
               <enum-complete> false </enum-complete>
           ...</cppenum>)

     syntax KItem ::= enumContext(CId, CPPEnumType, List, fixed: Bool, ut: CPPIntegerType) [strict(2)]

     // We do not support enumerators yet
     // We do not support not-fixed enums.
     rule <k> EnumDef(X::CId, NoNNS(), Scoped::Bool, Fixed::Bool, UT::CPPIntegerType, Enumerators:List)
          => enumContext(X, declareEnumName(N, X, UT, Scoped), Enumerators, Fixed, UT) ...</k>
          <curr-scope> namespaceScope(N::Namespace) </curr-scope>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>

     rule enumContext(X::CId, E::CPPEnumType, Enumerators:List, Fixed::Bool, UT::CPPIntegerType)
          => newEnum(E)
          ~> addToCurrentNamespace(X, E)
          ~> scope(enumScope(getEnumId(E)), declareEnumerators(getEnumId(E), Enumerators, Fixed, UT))

     syntax KItem ::= makeCompleteFixed(id : EnumId, fixed: Bool)
     syntax KItem ::= makeCompleteNotFixed(id : EnumId, fixed: Bool)

     rule makeCompleteFixed(_, false) => .
     rule makeCompleteNotFixed(_, true) => .
     rule <k> makeCompleteFixed(E::EnumId, true) => . ... </k>
     rule <k> makeCompleteNotFixed(E::EnumId, false) => . ... </k>


     syntax KItem ::= declareEnumerators(EnumId, List, fixed: Bool, ut: CPPIntegerType)

     // Type of an enumerator inside the declaration is enum's underlying type
     // if it is fixed, and type of initializing expression otherwise,
     // Hence we need to store the type of underlying expression...
     // In the case of fixed UT we put there the UT.
     rule declareEnumerators(_, .List, _, _) => .
     rule declareEnumerators(E::EnumId, ListItem(Enumerator(X::CId, AE::AExpr)) L::List, Fixed::Bool, UT::CPPIntegerType)
          => declareEnumerator(E, X, AE, Fixed, UT)
          ~> declareEnumerators(E, L, Fixed, UT)


     // TODO can we rely on ODR, or should we explicitly check the right translation unit?
     syntax KItem ::= declareEnumerator(EnumId, CId, AExpr, fixed: Bool, ut: CPPIntegerType) [strict(3)]

     // Not fixed
     rule <k> declareEnumerator(E::EnumId, X::CId, prv(V::CPPValue, Tr::Trace, T::CPPType), false, _) => . ...</k>
          <enum-id> E </enum-id>
          <enumerators> ES::Map => ES[X <- prv(V, Tr, T)] </enumerators>

     // Fixed enumerator. TODO check that the value fits into the UT
     rule <k> declareEnumerator(E::EnumId, X::CId, prv(V::CPPValue, Tr::Trace, _), true, UT::CPPIntegerType) => . ...</k>
          <enum-id> E </enum-id>
          <enumerators> ES::Map => ES[X <- prv(V, Tr, UT)] </enumerators>


endmodule

