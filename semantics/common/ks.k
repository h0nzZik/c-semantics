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

     syntax Int ::= "Ks.termArity" KsTerm [function]
     rule Ks.termArity B:KsBasicValue => 0
     rule Ks.termArity F:KsFunction => Ks.arity F
     rule Ks.termArity ($ F XS) => (Ks.termArity F) -Int Ks.TermList.length(XS)
     rule Ks.termArity (T |> F) => Ks.termArity ($ F T)

     syntax Bool ::= "Ks.isValue" "(" KsTerm  ")" [function, klabel(Ks.isValue)]
     rule Ks.isValue(($ Ts)) => ((Ks.termArity ($ Ts)) >=Int 1)
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
          requires (Ks.termArity ($ F Xs)) >=Int 1

     rule ($ F::KsTerm Args::KsTermList) => Ks._apply.eval(F Args)
          requires ((notBool isKsFunction(F)) andBool ((Ks.termArity F) ==Int 0))
                    orBool (isKsFunction(F) andBool ((Ks.termArity ($ F Args)) ==Int 0))

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

     syntax KsList
     syntax KsBasicValue ::= Int | Bool | KsList

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

     syntax KsBasicValue ::= "Ks.unit"

     // A -> A
     syntax KsUnaryFunction ::= "Ks.id"
     // A -> List A -> List A
     syntax KsBinaryFunction ::= "List.cons"
     // Bool -> A -> List A -> List A
     syntax KsTernaryFunction ::= "List.cons?"
     // (A -> B) -> List A -> List B
     syntax KsBinaryFunction ::= "List.map"
     // (A -> Bool) -> List A -> List A
     syntax KsBinaryFunction ::= "List.filter"

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

endmodule

module KS-PRELUDE-ID
     imports KS-PRELUDE-BASE

     rule Ks.apply Ks.id T::KsTerm => T
endmodule

module KS-PRELUDE-CONS
     imports KS-PRELUDE-BASE

     rule Ks.apply List.cons V Vs::KsList => (V : Vs)

     rule Ks.apply List.cons? true::Bool V::KsTerm Vs::KsList => (V : Vs)
     rule Ks.apply List.cons? false::Bool V::KsTerm Vs::KsList => Vs

endmodule

module KS-PRELUDE-MAP
     imports KS-PRELUDE-BASE

     rule Ks.apply List.map F {}
          => {}

     rule Ks.apply List.map F (X : Xs::KsList)
          => ($ List.cons ($ F X) ($ List.map F Xs))
endmodule

module KS-PRELUDE-FILTER
     imports KS-PRELUDE-BASE

     rule Ks.apply List.filter F {}
          => {}

     rule Ks.apply List.filter P (X : Xs::KsList)
          => ($ List.cons? ($ P X) X ($ List.filter P Xs))
endmodule

module KS-PRELUDE
     imports KS-PRELUDE-BASIC
     imports KS-PRELUDE-ID
     imports KS-PRELUDE-CONS
     imports KS-PRELUDE-MAP
     imports KS-PRELUDE-FILTER
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
