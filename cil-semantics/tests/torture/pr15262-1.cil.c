/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

typedef unsigned long size_t;
struct A {
   int t ;
   int i ;
};
extern  __attribute__((__nothrow__)) void *malloc(size_t __size )  __attribute__((__malloc__,
__leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
int foo(void) 
{ 

  {
  return (3);
}
}
int main(void) 
{ struct A *locp ;
  float f ;
  float g ;
  float *p ;
  int T355 ;
  int *T356 ;
  int tmp___0 ;
  void *tmp___1 ;

  {
  f = (float )3;
  g = (float )2;
  tmp___0 = foo();
  if (tmp___0) {
    p = & g;
  } else {
    p = & f;
  }
  if ((double )*p > 0.0) {
    g = (float )1;
  }
  tmp___1 = malloc(sizeof(*locp));
  locp = (struct A *)tmp___1;
  locp->i = 10;
  T355 = locp->i;
  T356 = & locp->i;
  *T356 = 1;
  T355 = locp->i;
  if (T355 != 1) {
    abort();
  }
  return (0);
}
}