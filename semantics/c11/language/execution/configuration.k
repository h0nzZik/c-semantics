module C-CONFIGURATION
     imports BOOL-SYNTAX
     imports C-CONFIGURATION-EXTENSIONS
     imports C-EXECUTION-INIT-SYNTAX
     imports COMMON-CONFIGURATION
     imports COMMON-INIT-SYNTAX
     imports COMMON-SYNTAX
     imports INT-SYNTAX
     imports LIBC-IO-SYNTAX
     imports LIST
     imports MAP
     imports SET
     imports SYMLOC-SYNTAX
     imports COMMON-THREAD-LOCAL


     configuration
<global/>
<result-value color="red" exit=""> 139:EffectiveValue </result-value>
<T>
<exec multiplicity="?">
     <extensions-global/>

     <next-thread-id color="black"> 1 </next-thread-id>

     <thread-info color="yellow">
          <thread-status color="yellow"> .Map </thread-status>
          <mutexes color="yellow"> .Map </mutexes>
          <glocks color="yellow"> .Map </glocks>
     </thread-info>
     <threads color="yellow" thread="">
          <thread multiplicity="*" color="yellow" type="Map">
               <thread-id color="yellow"> 0 </thread-id>
               <buffer color="lightgray"> .List </buffer>

               // Used for verifying the aliasing restrictions on
               // restrict-qualified pointers.
               <restrict> .List </restrict>

               <k color="green" multiplicity="?">
                    loadObj(unwrapObj($PGM:K))
                    ~> initMainThread
                    ~> pgmArgs($ARGV:List)
                    ~> callMain(size($ARGV:List), incomingArguments($ARGV:List))
               </k>
               <initializing> false </initializing>

               <duration color="black"> auto(0) </duration>
               <final-computation multiplicity="?" color="lightgray">
                    .K
               </final-computation>
               <thread-local/>
          </thread>
     </threads>


</exec>

<error-cell multiplicity="?" color="black"> .K </error-cell>

<status> initializingTu </status>

<options> $OPTIONS:Set </options>

<library>
     // stdlib.h support
     <malloced color="lightgray"> .Map </malloced>
     // Stderr is unbuffered by default, but it can be changed.
     <atexit> flush(#stdout) ~> flush(#stderr) </atexit>
     <at-quick-exit> .K </at-quick-exit>

     // stdarg.h support.
     <va-lists> .Map </va-lists>
     // setjmp.h support.
     <jmp-bufs> .Map </jmp-bufs>

     <open-files> .Set </open-files>

     <files color="lightgray">
          <file multiplicity="*" type="Set">
               <fid> .K </fid>
               <uri> .K </uri>
               <pos> 0 </pos>
               <mode> "r" </mode>
               <next-byte> .K </next-byte>
               <read-buffer> "" </read-buffer>
               <write-buffer> "" </write-buffer>
               <buffer-mode> fullBuf </buffer-mode>
               <buffer-size> bufSiz </buffer-size>
               <sending> .List </sending>
               <done> "" </done>
               <feof> false </feof>
               <ferror> 0 </ferror>
               <last-op> noLastOp </last-op>
          </file>
     </files>
     <input color="lightgray"> .List </input>
     <output color="lightgray"> .List </output>
     // env key string |-> value ptr
     <strerror-cache> .Map </strerror-cache>
     <sig-handling-state> .K </sig-handling-state>
     // Cells to store pointers returned by these functions that are
     // invalidated by subsequent calls.
     <setlocale> .K </setlocale>
     <localeconv> .K </localeconv>
     <getenv> .K </getenv>
</library>


</T>

<json> $JSON:String </json>

endmodule
