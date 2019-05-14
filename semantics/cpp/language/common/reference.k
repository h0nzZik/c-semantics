module CPP-REFERENCE-SYNTAX
     imports CPP-TYPING-SORTS

     syntax Bool ::= isReferenceCompatible(CPPType, CPPType) [function]
                   | isReferenceRelated(CPPType, CPPType) [function]
                   | isValidReferenceType(CPPType) [function]

endmodule

module CPP-REFERENCE
     imports CPP-REFERENCE-SYNTAX
     imports BOOL
     imports COMMON-SYNTAX
     imports CPP-TYPING-SYNTAX

     // @ref n4296 8.5.3:4
     rule isReferenceRelated(T1::CPPType, T2::CPPType) => true
          requires utype(T1) ==Type utype(T2)

     rule isReferenceRelated(t(... st: classType(...)) #as T1::CPPType, t(... st: classType(...)) #as T2::CPPType) => isBaseClassOf(T1, T2)

     rule isReferenceRelated(T1::CPPType, T2::CPPType) => false
          [owise]

     // @ref n4296 8.5.3:4
     rule isReferenceCompatible(T1::CPPType, T2::CPPType) => isReferenceRelated(T1, T2) andBool getQuals(T2) <=Quals getQuals(T1)

     rule isValidReferenceType(t(... st: rvRefType(_))) => true

     rule isValidReferenceType(t(... st: lvRefType(t(... q: Q::Quals)))) => Const() inQuals Q andBool notBool Volatile() inQuals Q

endmodule
