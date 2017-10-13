module C-CONFIGURATION
     imports MAP
     imports SET
     imports C-LINKING-INIT-SYNTAX
     imports CPP-DYNAMIC-SYNTAX
     imports COMMON-CONFIGURATION
     imports SYMLOC-SYNTAX
     imports COMMON-THREAD-LOCAL // kdyz tohle smazu, dostanu dost divnou chybu
    
     configuration
<global />
<result-value color="red" exit=""> 1 </result-value>
<T multiplicity="?">
<exec>

     <goto-map-calc color="cyan">
          <goto-calc multiplicity="*" color="cyan" type="Set">
               <computation color="cyan"> .K </computation>
               <computation-tail color="cyan"> .K </computation-tail>
               <decl-stack color="cyan"> .List </decl-stack>
               <goto-nesting-depth color="cyan"> 0 </goto-nesting-depth>
               <goto-block-history color="cyan"> .List </goto-block-history>
               <goto-loop-stack color="cyan"> .List </goto-loop-stack>
          </goto-calc>
     </goto-map-calc>

     <k color="green">
          $PGM:K
          ~> builtinTu
          ~> load($OBJS:K)
          ~> link
          ~> cleanup
     </k>

     <elab> .K </elab>
     <elab-stack> .List </elab-stack>

     <deferred-class-actions> .K </deferred-class-actions>

     // Toggle to allow writes and other special treatment
     // for initializers.
     <initializing> false </initializing>
     // compile-time evaluation
     <evaluating> false </evaluating>

     <duration color="black"> auto(0) </duration>
     <thread-local/>

     <curr-state>
         //<curr-tu color="lightgray"> "" </curr-tu>  // collides with thread-local

         <curr-lang-linkage> CPPLinkage </curr-lang-linkage>
         <curr-extern> false </curr-extern>
         <curr-tr-scope> namespaceScope(GlobalNamespace()):Scope </curr-tr-scope> 
         <curr-eval-context color="lightgray"> eval </curr-eval-context>
         <curr-template-context> noTemplate </curr-template-context>
         <curr-tr-program-loc color="black">
               UnknownCabsLoc
         </curr-tr-program-loc>
         <curr-function> .K </curr-function>
     </curr-state>

     <tr-block-stack color="violet"> .List </tr-block-stack>
     <tr-block-control>
          <tr-env color="red"> .Map </tr-env>
          <tr-types color="lightgray"> .Map </tr-types>
          // CId |-> Enum
          <enums> .Map </enums>
          <using-namespaces> .Set </using-namespaces>
          <tr-block-history> .List </tr-block-history>
          <tr-this> .K </tr-this>
     </tr-block-control>

     <template-deduction> .Map </template-deduction>
     <template-arguments> .Map </template-arguments>
</exec>

<generated-annotations> .List </generated-annotations>

<options> $OPTIONS:Set </options>
</T>

<json> $JSON:String </json>

endmodule
