/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__nothrow__)) int strcmp(char const   *__s1 , char const   *__s2 )  __attribute__((__pure__,
__nonnull__(1,2), __leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void exit(int __status )  __attribute__((__leaf__)) ;
int v  ;
char *g(void) 
{ 

  {
  return ((char *)"");
}
}
char *f(void) 
{ char *tmp ;
  char const   *tmp___0 ;

  {
  if (v == 0) {
    tmp = g();
    tmp___0 = (char const   *)tmp;
  } else {
    tmp___0 = "abc";
  }
  return ((char *)tmp___0);
}
}
int main(void) 
{ char *tmp ;
  int tmp___0 ;

  {
  v = 1;
  tmp = f();
  tmp___0 = strcmp((char const   *)tmp, "abc");
  if (! tmp___0) {
    exit(0);
  }
  abort();
}
}