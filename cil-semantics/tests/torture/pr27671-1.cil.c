/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__noreturn__)) void abort(void) ;
extern  __attribute__((__noreturn__)) void exit(int  ) ;
static int ( __attribute__((__noinline__)) foo)(int a , int b ) 
{ int c ;

  {
  c = a ^ b;
  if (c == a) {
    abort();
  }
  return (0);
}
}
int main(void) 
{ 

  {
  foo(0, 1);
  exit(0);
}
}