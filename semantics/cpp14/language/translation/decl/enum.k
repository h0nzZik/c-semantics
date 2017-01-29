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
     imports INT

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
     rule <k> EnumDef(X::CId, NoNNS(), Scoped::Bool, Fixed::Bool, UT::CPPIntegerType, Enumerators::List)
          => enumContext(X, declareEnumName(N, X, UT, Scoped), Enumerators, Fixed, UT) ...</k>
          <curr-scope> namespaceScope(N::Namespace) </curr-scope>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>

     rule enumContext(X::CId, E::CPPEnumType, Enumerators:List, Fixed::Bool, UT::CPPIntegerType)
          => newEnum(E)
          ~> addToCurrentNamespace(X, E)
          ~> makeCompleteIfFixed(getEnumId(E), Fixed)
          ~> scope(enumScope(getEnumId(E)), declareEnumerators(getEnumId(E), 0, Enumerators, Fixed, UT))
          ~> makeCompleteIfNotFixed(getEnumId(E), Fixed)

     syntax KItem ::= makeCompleteIfFixed(id : EnumId, fixed: Bool)
     syntax KItem ::= makeCompleteIfNotFixed(id : EnumId, fixed: Bool)

     rule makeCompleteIfFixed(_, false) => .
     rule makeCompleteIfNotFixed(_, true) => .
     rule makeCompleteIfFixed(E::EnumId, true) => makeComplete(E)
     rule makeCompleteIfNotFixed(E::EnumId, false) => makeComplete(E)

     syntax KItem ::= makeComplete(EnumId)

     rule <k> makeComplete(E::EnumId) => . ... </k>
          <enum-id> E </enum-id>
          <enum-complete> _ => true </enum-complete>


     syntax KItem ::= declareEnumerators(EnumId, Int, List, Bool, CPPIntegerType)

     // TODO do not use type(int) because it may not be large enough
     rule declareEnumerators(_, Next::Int, ListItem(Enumerator(_, NoExpression() => prv(Next, noTrace, type(int)))) _::List, _, _)
     context declareEnumerators(_, _, ListItem(Enumerator(_, HOLE:Expr)) _::List, _, _)


     // Type of an enumerator inside the declaration is enum's underlying type
     // if it is fixed, and type of initializing expression otherwise,
     // Hence we need to store the type of underlying expression...
     rule declareEnumerators(_, _, .List, _, _) => .
     rule declareEnumerators(E::EnumId, Next::Int, ListItem(Enumerator(X::CId, prv(V::Int, _, _) #as Pr::PRVal)) L::List, Fixed::Bool, UT::CPPIntegerType)
          => declareEnumerator(E, X, Pr, Fixed, UT)
          ~> declareEnumerators(E, V +Int 1, L, Fixed, UT)


     // TODO can we rely on ODR, or should we explicitly check the right translation unit?
     syntax KItem ::= declareEnumerator(EnumId, CId, PRVal, fixed: Bool, ut: CPPIntegerType)

     // Not fixed
     rule declareEnumerator(E::EnumId, X::CId, prv(_,_,_) #as Pr::PRVal, false, _) => addEnumerator(E, X, Pr)

     // Fixed enumerator. TODO check that the value fits into the UT
     rule declareEnumerator(E::EnumId, X::CId, prv(V::CPPValue, Tr::Trace, _), true, UT::CPPIntegerType) => addEnumerator(E, X, prv(V, Tr, UT))

     syntax KItem ::= addEnumerator(enum: EnumId, id: CId, v: PRVal)
     rule <k> addEnumerator(E::EnumId, X::CId, V::PRVal) => . ... </k>
         <enum-id> E </enum-id>
         <enumerators> ES::Map => ES[X <- V] </enumerators>

     // 7.2/3: ... An opaque-enum-declaration is either a redeclaration of an enumeration in the current scope...
     rule <k> OpaqueEnumDeclaration(X::CId, Scoped::Bool, UT::CPPIntegerType) => . ...</k>
          <curr-scope> namespaceScope(N::Namespace) </curr-scope>
          <enum-id> enumId(N::Namespace :: X) </enum-id>
          <enum-ut> UT </enum-ut>
          
     // 7.2/3 ... (TODO)

endmodule

