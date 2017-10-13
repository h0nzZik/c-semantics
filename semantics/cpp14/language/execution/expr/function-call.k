module CPP-EXPR-FUNCTION-CALL
     imports COMMON-FUNCTION-CALL-SYNTAX
     imports C-CONFIGURATION
     imports INT
     imports BITS-SYNTAX
     imports C-CHECK-LOC-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-SEQUENCE-POINT-SYNTAX
     imports C-TYPING-COMMON-SYNTAX
     imports C-TYPING-SYNTAX
     imports CPP-BINDING-SYNTAX
     imports CPP-BITSIZE-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-EXEC-ENV-SYNTAX
     imports CPP-MEMORY-ALLOC-SYNTAX
     imports CPP-MEMORY-READING-SYNTAX
     imports CPP-SYNTAX
     imports CPP-TYPE-MAP-SYNTAX
     imports CPP-TYPING-SYNTAX
     imports CPP-EXPR-MEMBERS-SYNTAX
     imports CPP-COMMON-EXPR-FUNCTION-CALL-SYNTAX

     rule runtimeFunctionApplication(B::BlockScope)
          => sequencePoint
          ~> enterRestrictBlock(B)

     // TODO check how much of this code we can move to 'common'

     rule evalArgs(_, _, functionObject(Q::QualId, _, _, _), CallT::CPPType, true, krlist(ListItem(prv(Obj::SymLoc, _, _) #as Arg1::PRVal) Args::List))
          => virtualCall(CallT, computeFinalOverrider(Q, CallT, readBytes(stripProv(Obj), byteSizeofType(type(pointerType(type(void)))), type(pointerType(type(void))))), 
               krlist(ListItem(Arg1) Args))

     syntax Expr ::= virtualCall(CPPType, Expr, StrictList) [strict(2)]
                   | computeFinalOverrider(QualId, CPPType, K) [strict(3)]
                   | #computeFinalOverrider(QualId, CPPType, CPPValue)
                   | getOverrides(Class, CId, CPPType, candidates: List)
     rule <k> computeFinalOverrider(Q::QualId, T::CPPType, dataList(L::List))
              => #computeFinalOverrider(Q, T, joinBytes(L)) ...</k>
          <curr-scope> S::Scope </curr-scope>
          requires notBool isUnderConstructionOrDestruction(S)

     syntax Bool ::= isUnderConstructionOrDestruction(Scope) [function]
     rule isUnderConstructionOrDestruction(blockScope(_ :: ConstructorId(_), _, _)) => true
     rule isUnderConstructionOrDestruction(blockScope(_ :: DestructorId(_), _, _)) => true
     rule isUnderConstructionOrDestruction(_) => false [owise]

     rule #computeFinalOverrider(C::Class :: VF::CId, T::CPPType, encodedValue(vtable(MostDerived::Class), 0, To::Int))
          => getOverrides(C, VF, T, ListItem(MostDerived))

     rule getOverrides(C::Class, _, _, (ListItem(Candidate::Class) => .List) _)
          requires notBool isBaseClassOf(C, Candidate)

     rule <k> getOverrides(C::Class, VF::CId, T::CPPType, (ListItem(Candidate::Class) => Bases) _) ...</k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          <class-id> Candidate </class-id>
          <base-classes> Bases::List </base-classes>
          <cenv>... VF |-> M::TypeMap ...</cenv>
          requires isBaseClassOf(C, Candidate) andBool getOverride(T, M) ==K type(no-type)::CPPType
     rule <k> getOverrides((C::Class => Candidate), VF::CId, (T::CPPType => getOverride(T, M)), (ListItem(Candidate::Class) => .List) _) ...</k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          <class-id> Candidate </class-id>
          <base-classes> Bases::List </base-classes>
          <cenv>... VF |-> M::TypeMap ...</cenv>
          requires isBaseClassOf(C, Candidate) andBool getOverride(T, M) =/=K type(no-type)::CPPType
     rule <k> getOverrides(C::Class, VF::CId, T::CPPType, .List) => lv(lnew(Base), noTrace, T) ...</k>
          <curr-tu> Tu::String </curr-tu>
          <tu-id> Tu </tu-id>
          <class-id> C </class-id>
          <cenv>... VF |-> (_::TypeMap T::CPPType |-> envEntry(... base: Base::SymBase)) ...</cenv>

     syntax CPPType ::= getOverride(CPPType, TypeMap) [function]
     rule getOverride(BaseClassFunc::CPPType, DerivedClassFunc::CPPType |-> envEntry(Base::SymBase, false, _) _)
          => DerivedClassFunc
          requires overrides(DerivedClassFunc, BaseClassFunc)
     rule getOverride(_, (_ |-> _ => .Map) _) [owise]
     rule getOverride(_, .Map) => type(no-type)::CPPType

     rule virtualCall(StaticT::CPPFunctionType, L:LVal, krlist(Args::List))
          => setType(#fun(Ret::CPPType => #if isCPPRefType(Ret) #then innerType(Ret) #else Ret #fi)(getReturnType(StaticT)), BuiltinCallOp(L, false, Args))

     // TODO zatim se asi budeme muset obejit bez tohohle v common
     // Function call conversion (C linkage)
     rule application(_, _, functionObject(X::CId, _, _),
               (T:CPPFunctionType => convertTypeToC(T)), _, krlist(L::List => mapList(L, #klabel(`convertValToC`))))

     syntax RValue ::= convertValToC(PRVal) [function]
     rule convertValToC(prv(V::CPPValue, _, T::CPPType)) => tv({V}:>CValue, utype(convertTypeToC(T)))
          requires isCValue(V)

endmodule
