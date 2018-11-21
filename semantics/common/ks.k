module KS-CORE-SORTS
     // Only KS-CORE-SYNTAX can define symbols of sort KsTerm
     syntax KsTerm
     // Extension point. Feel free to define symbol of this sort.
     syntax KsFunction
     // Extension point. Feel free to subsort or define symbol.
     syntax KsBasicValue

     syntax KsValue ::= KsBasicValue | KsFunction

endmodule

module KS-CORE-SYNTAX
     imports KS-CORE-SORTS
     imports BOOL
     imports INT
     imports LIST

     syntax Int ::= "Ks.arity" KsFunction [function, klabel(Ks.functionArity)]

     syntax KsTermList ::= List{KsTerm, " "}

     // Nothing else is KsTerm!
     syntax KsTerm ::= KsValue
                      | "($" KsTermList ")"
                      | KsTerm "|>" KsTerm [left]

     syntax KItem ::= "Ks.apply" KsTermList

endmodule

module KS-CORE
     imports KS-CORE-SYNTAX



     syntax Int ::= "Ks.TermList.length" "(" KsTermList ")" [function]
     rule Ks.TermList.length(.KsTermList) => 0
     rule Ks.TermList.length(_ XS) => 1 +Int Ks.TermList.length(XS)

     syntax Int ::= "Ks.termArity" "(" KsTerm ")" [function]
     rule Ks.termArity(B:KsBasicValue) => 0
     rule Ks.termArity(F:KsFunction) => Ks.arity F
     rule Ks.termArity(($ F XS)) => Ks.termArity(F) -Int Ks.TermList.length(XS)
     rule Ks.termArity((T |> F)) => Ks.termArity(($ F T))

     syntax KsFunction ::= "Ks.compose" "(" KsTerm "," KsTerm ")"
     rule Ks.apply Ks.compose(F, G) Args::KsTermList
          => ($ G ($ F Args))
          requires Ks.termArity(($ F Args)) ==Int 0

     rule Ks.arity Ks.compose(F, G) => Ks.termArity(F) +Int Ks.termArity(G) -Int 1

     syntax Bool ::= "Ks.isValue" "(" KsTerm  ")" [function, klabel(Ks.isValue)]
     rule Ks.isValue(($ Ts)) => Ks.termArity(($ Ts)) >=Int 1
     rule Ks.isValue(V:KsValue) => true
     rule Ks.isValue(_) => false [owise]

     syntax List ::= "List.fromKsTermList" "(" KsTermList ")" [function]
     rule List.fromKsTermList(.KsTermList) => .List
     rule List.fromKsTermList(T Ts) => ListItem(T) List.fromKsTermList(Ts)

     syntax KsTermList ::= "Ks.TermList.from" "(" List ")" [function]
     rule Ks.TermList.from(.List) => .KsTermList
     rule Ks.TermList.from(ListItem(T::KsTerm) L::List) => T Ks.TermList.from(L)

     rule (T |> F) => ($ F T)
     rule ($ ((T |> F) => ($ F T)) _)

     rule Ks.apply V:KsBasicValue => V

     rule ($ ($ F Xs ) Y Ys) => ($ ($ F Ks.TermList.from(List.fromKsTermList(Xs) ListItem(Y))) Ys)
          requires Ks.termArity(($ F Xs)) >=Int 1

     rule ($ F::KsTerm Args::KsTermList) => Ks._apply.eval(F Args)
          requires ((notBool isKsFunction(F)) andBool (Ks.termArity(F) ==Int 0))
                    orBool (isKsFunction(F) andBool (Ks.termArity(($ F Args)) ==Int 0))

     syntax KItem ::= "Ks._apply.eval" "(" KsTermList ")"
     rule Ks._apply.eval(Xs) => Ks._apply._eval(List.fromKsTermList(Xs), .List)

     syntax KItem ::= "Ks._apply._eval" "(" List "," List ")"
     rule Ks._apply._eval(.List, Xs) => Ks._apply.evalDone(Ks.TermList.from(Xs))
     rule Ks._apply._eval(ListItem(X::KsTerm) Xs, Ys) => X ~> Ks._apply._evalFreeze(Xs, Ys)

     syntax KItem ::= "Ks._apply._evalFreeze" "(" List "," List ")"
     rule Y::KsTerm ~> Ks._apply._evalFreeze(Xs, Ys) => Ks._apply._eval(Xs, Ys ListItem(Y))
          requires Ks.isValue(Y)


     syntax KItem ::= "Ks._apply.evalDone" "(" KsTermList ")"
     rule Ks._apply.evalDone(Ys) => Ks.apply Ys

endmodule

module KS-PRELUDE-SORTS
     imports INT
     imports BOOL
     imports KAST

     syntax KsList
     syntax KsUnit
     syntax KsBasicValue ::= Int | Bool | KsList | KsUnit

     syntax KsNullaryFunction
     syntax KsUnaryFunction
     syntax KsBinaryFunction
     syntax KsTernaryFunction
     syntax KsFunction ::= KsNullaryFunction
                         | KsUnaryFunction
                         | KsBinaryFunction
                         | KsTernaryFunction
endmodule

module KS-PRELUDE-SYNTAX
     imports KS-PRELUDE-SORTS
     imports KS-CORE-SORTS
     imports LIST
     imports INT
     imports BOOL

     syntax KsUnit ::= "Ks.unit"

     // a -> a
     syntax KsUnaryFunction ::= "Ks.id"
     // a -> KsList a -> KsList a
     syntax KsBinaryFunction ::= "Ks.List.cons"
     // Bool -> a -> KsList a -> KsList a
     syntax KsTernaryFunction ::= "Ks.List.cons?"
     // (a -> b) -> KsList a -> KsList b
     syntax KsBinaryFunction ::= "Ks.List.map"
     // (a -> Bool) -> KsList a -> KsList a
     syntax KsBinaryFunction ::= "Ks.List.filter"
     // (a -> KsUnit) -> KsList a -> KsUnit
     syntax KsBinaryFunction ::= "Ks.each"

     syntax KsUnaryFunction ::= "Ks.fromKLabel" "(" KItem ")"

     syntax KsList ::= "{}" [klabel(Ks.List.nil)]
                     | "(" KsTerm ":" KsList ")"
                     | "[[" KsCommaList "]]" [function]
                     | "Ks.List.from" "(" List ")" [function]

     syntax List ::= "List.from" "(" KsList ")" [function]

     syntax KsCommaList ::= List{KsTerm, ","}

endmodule

module KS-PRELUDE-BASE
     imports KS-CORE-SYNTAX
     imports KS-PRELUDE-SYNTAX
endmodule

module KS-PRELUDE-BASIC
     imports KS-PRELUDE-BASE

     rule Ks.arity _:KsNullaryFunction => 0
     rule Ks.arity _:KsUnaryFunction => 1
     rule Ks.arity _:KsBinaryFunction => 2
     rule Ks.arity _:KsTernaryFunction => 3

     rule [[ .KsCommaList ]] => {}
     rule [[ X, Xs ]] => ( X : [[Xs]])

     rule Ks.List.from(.List) => {}::KsList
     rule Ks.List.from(ListItem(X::KsTerm) L::List) => (X : Ks.List.from(L))

     rule List.from({}::KsList) => .List
     rule List.from((X : Xs)) => ListItem(X) List.from(Xs)

     rule Ks.apply Ks.fromKLabel(#klabel(Lbl:KLabel)) X:KsTerm .KsTermList => Lbl(X, .KList)

endmodule

module KS-PRELUDE-ID
     imports KS-PRELUDE-BASE

     rule Ks.apply Ks.id T::KsTerm => T
endmodule

module KS-PRELUDE-CONS
     imports KS-PRELUDE-BASE

     rule Ks.apply Ks.List.cons V Vs::KsList => (V : Vs)

     rule Ks.apply Ks.List.cons? true::Bool V::KsTerm Vs::KsList => (V : Vs)
     rule Ks.apply Ks.List.cons? false::Bool V::KsTerm Vs::KsList => Vs

endmodule

module KS-PRELUDE-MAP
     imports KS-PRELUDE-BASE

     rule Ks.apply Ks.List.map F {}
          => {}

     rule Ks.apply Ks.List.map F (X : Xs::KsList)
          => ($ Ks.List.cons ($ F X) ($ Ks.List.map F Xs))
endmodule

module KS-PRELUDE-FILTER
     imports KS-PRELUDE-BASE

     rule Ks.apply Ks.List.filter F {}
          => {}

     rule Ks.apply Ks.List.filter P (X : Xs::KsList)
          => ($ Ks.List.cons? ($ P X) X ($ Ks.List.filter P Xs))
endmodule

module KS-PRELUDE-EACH
     imports KS-PRELUDE-BASE

     rule Ks.apply Ks.each F {} => Ks.unit
     rule Ks.apply Ks.each F (X : Xs::KsList)
          => ($ F X)
          ~> Ks.discard
          ~> ($ Ks.each F Xs)

     syntax KItem ::= "Ks.discard"
     rule _ ~> Ks.discard => .K

endmodule

module KS-PRELUDE
     imports KS-PRELUDE-BASIC
     imports KS-PRELUDE-ID
     imports KS-PRELUDE-CONS
     imports KS-PRELUDE-MAP
     imports KS-PRELUDE-FILTER
     imports KS-PRELUDE-EACH
endmodule

module KS-SORTS
     imports KS-CORE-SORTS
     imports KS-PRELUDE-SORTS
endmodule

module KS-SYNTAX
     imports KS-CORE-SYNTAX
     imports KS-PRELUDE-SYNTAX
endmodule

module KS
     imports KS-CORE
     imports KS-PRELUDE
endmodule
