/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern void abort(void) ;
extern void exit(int  ) ;
unsigned long foo(unsigned long n ) 
{ 

  {
  return ((~ n >> 3) & 1UL);
}
}
int main(void) 
{ unsigned long tmp ;
  unsigned long tmp___0 ;

  {
  tmp = foo((unsigned long )(1 << 3));
  if (tmp != 0UL) {
    abort();
  }
  tmp___0 = foo(0UL);
  if (tmp___0 != 1UL) {
    abort();
  }
  exit(0);
}
}