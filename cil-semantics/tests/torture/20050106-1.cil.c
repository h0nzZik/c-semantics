/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern void abort(void) ;
__inline static unsigned short foo(unsigned int *p ) 
{ 

  {
  return ((unsigned short )*p);
}
}
unsigned int u  ;
int main(void) 
{ unsigned short tmp ;

  {
  tmp = foo(& u);
  if (((int )tmp & 32768) != 0) {
    abort();
  }
  return (0);
}
}