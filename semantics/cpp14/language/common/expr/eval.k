module CPP-EXPR-EVAL
     imports BOOL
     imports C-CONFIGURATION
     imports CPP-CONVERSION-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports CPP-TYPING-SYNTAX
     imports CPP-SYNTAX // ExecName

     rule reval(L:GLVal => convertReval(L))
     /*
          requires notBool isLExpr(L)
     rule reval(le(...v: V::Val) #as E::LVal => convertReval(E))
          requires (notBool isExecName(V)) andBool (notBool isExprLoc(V))

     syntax KItem ::= revalExprLoc(CabsLoc, Trace, CPPType)
     rule reval(le(ExprLoc(L::CabsLoc, E::Expr), Tr::Trace, T::CPPType)) => reval(le(E, Tr, T)) ~> revalExprLoc(L, Tr, T)
     requires notBool isPRVal(E)
     // FIXME: This probably introduces a redundant pre() subterm.
     rule reval(V:PRVal) ~> revalExprLoc(L::CabsLoc, Tr::Trace, T::CPPType) => reval(le(ExprLoc(L, V), Tr, T))

     rule reval(le(...v: ExprLoc(_, V:PRVal)) #as L::LVal => convertReval(L))
          requires notBool isEvalVal(V)
     rule reval(le(...v: ExprLoc(_, V:PRVal))=>V)
          requires isEvalVal(V)

     rule <k> reval(le(...v: ExecName(_, X::CId) #as V:ExecName) => V) ...</k>
          <env> Env::Map </env>
          requires X in_keys(Env)
     rule <k> reval(le(...v: ExecName(_, X::CId)) #as E::Val => convertReval(E)) ...</k>
          <env> Env::Map </env>
          requires notBool X in_keys(Env)
*/

     rule convertReval(lv(Loc::SymLoc, Tr::Trace, T:CPPArrayType))
          => convertArray(lv(Loc, Tr, T))
     rule convertReval(xv(Loc::SymLoc, Tr::Trace, T:CPPArrayType))
          => convertArray(xv(Loc, Tr, T))
     rule convertReval(prv(Loc::SymLoc, Tr::Trace, T:CPPArrayType)) // how can this be?
          => convertArray(prv(Loc, Tr, T))

     rule convertReval(lv(Loc::SymLoc, Tr::Trace, T:CPPFunctionType))
          => convertFunction(lv(Loc, Tr, T))

     rule convertReval(L:GLVal)
          => convertLVal(L)
          requires notBool isCPPFunctionType(type(L))
               andBool notBool isCPPArrayType(type(L))

endmodule
