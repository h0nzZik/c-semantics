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

     // We do not support enumerators yet
     // We do not support not-fixed enums.
     rule <k> EnumDef(X::CId, NoNNS(), Scoped::Bool, Fixed::Bool, UT::CPPIntegerType, Enumerators::List)
          => enumContext(X, declareEnumName(N, X, UT, Scoped, Fixed), Enumerators, Fixed, UT) ...</k>
          <curr-scope> namespaceScope(N::Namespace) </curr-scope>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>


     /* How to declaring enum with fixed underlying type:
        (1) Evaluate underlying type.
        (2) Add enum to environment. It is complete since then.
        (3) Evaluate enumerators and add them to <cppenum>.
          Their type is UT during evaluation of other enumerators,
          and the enum type otherwise. Thus the type must be present  in configuration.

          Declaring enum without fixed underlying type:
        (1) Add enum to environment. It is incomplete.
        (2) Evaluate enumerators and add them to <cppenum>.
          During evaluation of other enumerators, their type is the type of their expressions,
          and the enum type otherwise.
        (3) Calculate value range, and the underlying type. Put them into configuration.
        (4) Optional: update info in environment, because the enum might have changed.
      */



     syntax CPPEnumType ::= declareEnumName(ns: Namespace, id: CId, ut: CPPIntegerType, scoped: Bool, fixed: Bool) [function]
     rule declareEnumName(N::Namespace, X::CId, UT::CPPIntegerType, false, Fixed:Bool) => t(noQuals, .Set, unscopedEnum(enumId(N::Namespace :: Enum(X)), UT, false))
     rule declareEnumName(N::Namespace, X::CId, UT::CPPIntegerType, true, true)  => t(noQuals, .Set,   scopedEnum(enumId(N::Namespace :: Enum(X)), UT))

     syntax KItem ::= addToCurrentNamespace(CId, CPPEnumType)
     rule <k> addToCurrentNamespace(X::CId, E::CPPEnumType) => . ... </k>
          <curr-scope> namespaceScope(N::Namespace) </curr-scope>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          <ns-id> N </ns-id>
          <ntypes> NT::Map => NT[X, Enum() <- E] </ntypes>

     syntax KItem ::= enumContext(CId, CPPEnumType, List, fixed: Bool, ut: CPPIntegerType) [strict(2)]

     rule enumContext(X::CId, E::CPPEnumType, Enumerators:List, Fixed::Bool, UT::CPPIntegerType)
          => newEnum(E, Fixed)
          ~> addToCurrentNamespace(X, E)
          ~> scope(enumScope(getEnumId(E)), declareEnumerators(E, 0, 0, 0, Enumerators, Fixed))

     // second param -underlying type
     syntax KItem ::= newEnum(CPPEnumType, fixed: Bool)

     rule <k> newEnum(E:CPPEnumType, true) => . ... </k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          (.Bag => <cppenum>...
               <enum-id> getEnumId(E) </enum-id>
               <enum-type> E </enum-type>
               <enum-ut> underlyingType(E) </enum-ut>
               <scoped> getScoped(E) </scoped>
               <enum-complete> true </enum-complete>
               <enum-min> min(underlyingType(E)) </enum-min>
               <enum-max> max(underlyingType(E)) </enum-max>
           ...</cppenum>)

     rule <k> newEnum(E:CPPUnscopedEnumType, false) => . ... </k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          (.Bag => <cppenum>...
               <enum-id> getEnumId(E) </enum-id>
               <enum-type> E </enum-type>
               <scoped> false </scoped>
               <enum-complete> false </enum-complete>
           ...</cppenum>)



     syntax KItem ::= declareEnumerators(CPPEnumType, min: Int, max: Int, next: Int, List, fixed: Bool)

     // TODO do not use type(int) because it may not be large enough
     rule declareEnumerators(_, _, _, Next::Int, ListItem(Enumerator(_, NoExpression() => prv(Next, noTrace, type(int)))) _::List, _)
     context declareEnumerators(_, _, _, _, ListItem(Enumerator(_, HOLE:Expr)) _::List, _)

     // Taky tady na konci, kdyz uz konecne zname rozsah enumu, muzeme spocitat jeho underlying type,
     // Tim padem musime prepsat v prostredi mapovani na typ, protoze ten obsahuje UT...
     // No a co kdyz ho nekdo pouziva? :-/
     // Dalsi moznost je nepridavat typ enumu do prostredi hned, protoze ten typ je incomplete...
     // ale i tak jim muzeme parametrizovat treba sablony, takze musi byt dostupny. Jen je.. incomplete.
     // Pokud tedy nema fixed UT, nemuzeme ho z toho ziskat... a on to asi nikdo ziskat nechce ani nemuze.
     // Jak ale funguje std::underlying_type? Pouziva to nejake intrinsic funkce, protoze beznymi jazykovymi schopnostmi
     // ten UT nedokazeme zjistit. Coz je dobre. Tedy staci, abych si ja dal pozor, ze se nebudu
     // odkazovat na UT driv, nez bude doopravdy znamy... a potom ho muzu prepsat i v tom prostredi.

     // Type of an enumerator inside the declaration is enum's underlying type
     // if it is fixed, and type of initializing expression otherwise,
     // Hence we need to store the type of underlying expression...
     rule declareEnumerators(T::CPPEnumType, Min::Int, Max::Int, Next::Int, ListItem(Enumerator(X::CId, prv(V::Int, _, _) #as Pr::PRVal)) L::List, Fixed::Bool)
          => declareEnumerator(getEnumId(T), X, Pr, Fixed, underlyingType(T))
          ~> declareEnumerators(T, minInt(Min, V), maxInt(Min, V), V +Int 1, L, Fixed)

     // Enums with fixed UT are finished by now.
     rule declareEnumerators(T::CPPEnumType, _, _, _, .List, true) => .

     rule declareEnumerators(T::CPPUnscopedEnumType, Min::Int, Max::Int, _, .List, false) => calculateEnumValues(T, Min, Max)
    

     syntax KItem ::= calculateEnumValues(CPPEnumType, min: Int, max: Int)

  
     syntax Int ::= calculateMaxEnumValue(emin: Int, emax: Int) [function]
     syntax Int ::= calculateMinEnumValue(emin: Int, emax: Int) [function]

     rule calculateMinEnumValue(EMin::Int, _) => 0
     requires EMin >=Int 0

     rule calculateMinEnumValue(EMin::Int, EMax::Int) => 0 -Int (calculateMaxEnumValue(EMin, EMax) +Int 1) [owise]

     rule calculateMaxEnumValue(EMin::Int, EMax::Int) => firstGreaterThanOrEqualTo(0, maxInt(absInt(EMin) -Int 1, absInt(EMax)))


     syntax Int ::= firstGreaterThanOrEqualTo(exp: Int, tresh: Int) [function]
     
     rule firstGreaterThanOrEqualTo(Exp::Int, Tresh::Int) => (1 <<Int Exp) -Int 1
     requires ((1 <<Int Exp) -Int 1) >=Int Tresh

     rule firstGreaterThanOrEqualTo(Exp::Int, Tresh::Int) => firstGreaterThanOrEqualTo(Exp +Int 1, Tresh) [owise]

     rule calculateEnumValues(T::CPPEnumType, Min::Int, Max::Int) => setEnumMinMax(T, calculateMinEnumValue(Min, Max), calculateMaxEnumValue(Min, Max))

     syntax KItem ::= setEnumMinMax(CPPEnumType, min: Int, max: Int)

     // TODO there is some real algorithm described in 7.2/8
     rule <k> setEnumMinMax(t(_, _, unscopedEnum(E::EnumId, UT::CPPIntegerType, _)), Min::Int, Max::Int) => . ... </k>
          <enum-id> E </enum-id>
          // Musime tam dat skutecny, spocitany underlying type
          <enum-type> _ => t(noQuals, .Set, unscopedEnum(E, UT , false)) </enum-type>
          <enum-min> _ => Min </enum-min>
          <enum-max> _ => Max </enum-max>
          <enum-complete> _ => true </enum-complete>
    // TODO can we rely on ODR, or should we explicitly check the right translation unit?
     syntax KItem ::= declareEnumerator(EnumId, CId, PRVal, fixed: Bool, ut: CPPType)

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
          <enum-id> enumId(N::Namespace :: Enum(X)) </enum-id>
          <enum-ut> UT </enum-ut>
          
     // 7.2/3 ... (TODO)

endmodule

