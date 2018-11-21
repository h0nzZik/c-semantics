module CPP-CLASS-BASIC-SORTS
     syntax ClassInfo
endmodule // CPP-CLASS-BASIC-SORTS

module CPP-CLASS-BASIC-SYNTAX
     imports CPP-CLASS-BASIC-SORTS
     imports CPP-SORTS
     imports CPP-DYNAMIC-SORTS
     imports CPP-TYPING-SORTS
     imports INT
     syntax ClassOffset ::= classOffset(naoffset:Int, offset: Int)
     syntax Expr ::= evalBraceOrEqualInitializer(class: Class, object: Expr, initializer: Expr) [strict(2)]
     syntax KItem ::= returnFromBraceOrEqualInitializer(LVal, Scope)
     syntax This ::= This()
     syntax Expr ::= This
     syntax Expr ::= contrivedObject(CPPType)
     syntax ValResult ::= noObject()
     syntax NoArg ::= NoArg()
     syntax ValResult ::= NoArg
     syntax CId ::= unnamedObject(Class)
     syntax Expr ::= beginConstruction(Expr, isBaseClassSubobject: Bool) [strict]
     syntax Expr ::= endConstruction(Expr, isConstructor: Bool) [strict]
     syntax BaseClass ::= baseClass(Class)
     syntax CId ::= BaseClass
     syntax Stmt ::= "writeVTables"
     syntax ClassInfo ::= getClassInfo(CPPClassType) [function]
                        | getClassInfo(Class) [function, klabel(getClassInfoOfClass)]
     syntax ClassInfo ::= ClassCell | IncompleteInfo

endmodule // CPP-CLASS-BASIC-SYNTAX

module CPP-CLASS-BASIC
     imports CPP-CLASS-SYNTAX
     imports K-REFLECTION
     imports C-CONFIGURATION
     imports CPP-TYPING-SYNTAX
     imports COMMON-TRANSLATION-UNIT-SYNTAX

     syntax ClassInfo ::= #getClassInfo(Class, K) [function]

     rule getClassInfo(t(... st: classType(C::Class))) => getClassInfo(C)
     rule getClassInfo(C::Class) => #getClassInfo(C, getCurrentTranslationUnit())
     rule #getClassInfo(C::Class, <tu>... <class> <class-id> C </class-id> B::Bag </class> ...</tu>) => <class> <class-id> C </class-id> B </class>
     rule #getClassInfo(_, _) => #incomplete [owise]

endmodule // CPP-CLASS-BASIC

module CPP-CLASS-MEMBER-SORTS
     syntax ClassDataMember
     syntax ClassFunctionMember

     syntax KsBasicValue ::= ClassDataMember | ClassFunctionMember | CPPType

endmodule // CPP-CLASS-MEMBER-SORTS

module CPP-CLASS-MEMBER-SYNTAX
     imports CPP-TYPING-SORTS // CPPType
     imports CPP-SORTS // CId

     syntax ClassDataMember ::= "Class.DataMember" "(" CId "," CPPType ")"
     syntax ClassFunctionMember ::= "Class.FunctionMember" "(" CId "," CPPType ")"


     // ClassDataMember -> CPPType
     syntax KsUnaryFunction ::= "Class.DataMember.getType"

endmodule // CPP-CLASS-MEMBER-SYNTAX

module CPP-CLASS-MEMBER
     imports CPP-CLASS-MEMBER-SYNTAX
     imports KS-SYNTAX

     rule Ks.apply Class.DataMember.getType Class.DataMember(_, T::CPPType) => T

endmodule // CPP-CLASS-MEMBER

module CPP-CLASS-SORTS
     imports CPP-CLASS-BASIC
     imports CPP-CLASS-MEMBER-SORTS
endmodule // CPP-CLASS-SORTS

module CPP-CLASS-SYNTAX
     imports CPP-CLASS-BASIC-SYNTAX
     imports CPP-CLASS-MEMBER-SYNTAX
endmodule // CPP-CLASS-SYNTAX

module CPP-CLASS
     imports CPP-CLASS-BASIC
     imports CPP-CLASS-MEMBER
endmodule // CPP-CLASS
