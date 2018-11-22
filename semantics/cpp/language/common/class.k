// --------------------------------
//      CPP-CLASS-INFO
// --------------------------------

module CPP-CLASS-INFO-SORTS
     syntax ClassInfo

endmodule // CPP-CLASS-INFO-SORTS

module CPP-CLASS-INFO-SYNTAX
     imports CPP-CLASS-INFO-SORTS
     imports CPP-TYPING-SORTS

     syntax ClassInfo ::= getClassInfo(CPPClassType) [function]
                        | getClassInfo(Class) [function, klabel(getClassInfoOfClass)]

     syntax ClassInfo ::= ClassCell | IncompleteInfo

endmodule // CPP-CLASS-INFO-SYNTAX

module CPP-CLASS-INFO
     imports CPP-CLASS-INFO-SYNTAX
     imports K-REFLECTION
     imports C-CONFIGURATION
     imports CPP-TYPING-SYNTAX
     imports COMMON-TRANSLATION-UNIT-SYNTAX

     syntax ClassInfo ::= #getClassInfo(Class, K) [function]

     rule getClassInfo(t(... st: classType(C::Class))) => getClassInfo(C)
     rule getClassInfo(C::Class) => #getClassInfo(C, getCurrentTranslationUnit())
     rule #getClassInfo(C::Class, <tu>... <class> <class-id> C </class-id> B::Bag </class> ...</tu>) => <class> <class-id> C </class-id> B </class>
     rule #getClassInfo(_, _) => #incomplete [owise]

endmodule // CPP-CLASS-INFO

// --------------------------------
//      CPP-CLASS-MEMBER
// --------------------------------

module CPP-CLASS-MEMBER-SORTS
     syntax ClassDataMember
     syntax ClassFunctionMember

     syntax KsBasicValue ::= ClassDataMember | ClassFunctionMember

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

// --------------------------------
//      CPP-CLASS-MEMBERS
// --------------------------------

module CPP-CLASS-MEMBERS-SORTS

     // empty

endmodule // CPP-CLASS-MEMBERS-SORTS

module CPP-CLASS-MEMBERS-SYNTAX
     imports CPP-CLASS-MEMBERS-SORTS // self

     syntax KsBasicValue ::= Class

     // Class -> KsList{ClassDataMember}
     syntax KsUnaryFunction ::= "Class.getNonStaticDataMembers"

endmodule // CPP-CLASS-MEMBERS-SYNTAX

module CPP-CLASS-MEMBERS
     imports CPP-CLASS-MEMBERS // self
     imports KS-SYNTAX

     rule <k> Ks.apply Class.getNonStaticDataMembers C::Class => Ks.List.from(NSDM) ...</k>
          <curr-tr-tu> Tu::String </curr-tr-tu>
          <tu-id> Tu </tu-id>
          <class-id> C </class-id>
          <non-static-data-members> NSDM::List </non-static-data-members>

endmodule // CPP-CLASS-MEMBERS

// --------------------------------
//      CPP-CLASS-TYPE
// --------------------------------

module CPP-CLASS-TYPE-SORTS

     // empty

endmodule // CPP-CLASS-TYPE-SORTS

module CPP-CLASS-TYPE-SYNTAX
     imports CPP-CLASS-TYPE-SORTS // self

     // CPPType -> Bool
     syntax KsUnaryFunction ::= "Type.isClassType"
     // CPPClassType -> Class
     syntax KsUnaryFunction ::= "ClassType.getClass"

endmodule // CPP-CLASS-TYPE-SYNTAX

module CPP-CLASS-TYPE
     imports CPP-CLASS-TYPE-SYNTAX // self
     imports KS-SYNTAX
     imports CPP-TYPING-SYNTAX

     rule Ks.apply Type.isClassType T::CPPType => isCPPClassType(T)
     rule Ks.apply ClassType.getClass t(... st: classType(C::Class)) => C

endmodule // CPP-CLASS-TYPE

// --------------------------------
//      CPP-CLASS-OTHER
// --------------------------------

module CPP-CLASS-OTHER-SORTS

     // empty

endmodule // CPP-CLASS-OTHER-SORTS

module CPP-CLASS-OTHER-SYNTAX
     imports CPP-CLASS-OTHER-SORTS // self
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

endmodule // CPP-CLASS-INFO-SYNTAX

module CPP-CLASS-OTHER
     imports CPP-CLASS-OTHER-SYNTAX // self

endmodule // CPP-CLASS-OTHER

// --------------------------------
//      CPP-CLASS
// --------------------------------

module CPP-CLASS-SORTS
     imports CPP-CLASS-INFO-SORTS
     imports CPP-CLASS-MEMBER-SORTS
     imports CPP-CLASS-MEMBERS-SORTS
     imports CPP-CLASS-OTHER-SORTS
     imports CPP-CLASS-TYPE-SORTS
endmodule // CPP-CLASS-SORTS

module CPP-CLASS-SYNTAX
     imports CPP-CLASS-INFO-SYNTAX
     imports CPP-CLASS-MEMBER-SYNTAX
     imports CPP-CLASS-MEMBERS-SYNTAX
     imports CPP-CLASS-OTHER-SYNTAX
     imports CPP-CLASS-TYPE-SYNTAX
endmodule // CPP-CLASS-SYNTAX

module CPP-CLASS
     imports CPP-CLASS-INFO
     imports CPP-CLASS-MEMBER
     imports CPP-CLASS-MEMBERS
     imports CPP-CLASS-OTHER
     imports CPP-CLASS-TYPE
endmodule // CPP-CLASS
