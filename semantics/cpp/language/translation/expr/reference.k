module CPP-TRANSLATION-EXPR-REFERENCE
     imports C-CONFIGURATION
     imports BOOL
     imports SYMLOC-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-REFERENCE-SYNTAX
     imports CPP-TYPING-SYNTAX

     /*
     rule bindReference(L:LVal, R:Val) => le(bindReference(L, R), trace(L), type(L))
          requires Translation()
          andBool (notBool isEvalVal(L) orBool notBool isEvalVal(R))
     */

     // we need this result tag because lvalues of reference type aren't KResults
     context bindReference(HOLE:Expr, _) [result(LVal)]

     /*
     rule <k> bindReference(lv(Loc1::SymLoc, Tr::Trace, T1::CPPType), lv(Loc2::SymLoc, _, T2::CPPType))
              => lv(Loc1, Tr, T1) ...</k>
          <references>... .Map => stripProv(Loc1) |-> Loc2 ...</references>
          requires Translation() andBool isCPPLVRefType(T1) andBool notBool isCPPBitfieldType(T2) andBool isReferenceCompatible(innerType(T1), T2)

     */

     syntax KItem ::= execBindReference(Val, Val)

     rule bindReference(L:Val, R:Val)
          => bindReferenceCtx(L, type(L), refKind(type(L)), R, type(R), cat(R))

     syntax KItem ::= bindReferenceCtx(
                         ref:      Val,
                         refType:  CPPType,
                         refKind:  ReferenceKind,
                         init:     Val,
                         initType: CPPType,
                         initCat:  ValueCategory)

     /*
         @ref n4800 9.3.3:5.1.2
        (the initializer expression) has a class type (i.e., T2 is a class type), where T1 is not reference-related to T2, and can be converted to an lvalue of type “cv3 T3”, where “cv1 T1” is reference-compatible with “cv3 T3”97 (this conversion is selected by enumerating the applicable conversion functions ([over.match.ref]) and choosing the best one through overload resolution),
      */
     syntax KItem ::= canBeConvertedToCompatibleLValue(classType: CPPType, CPPType)

endmodule
