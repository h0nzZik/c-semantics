/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

typedef __builtin_va_list __gnuc_va_list;
typedef __gnuc_va_list va_list;
struct s {
   int x ;
   int y ;
};
/* compiler builtin: 
   void __builtin_va_end(__builtin_va_list  ) ;  */
/* compiler builtin: 
   void __builtin_va_arg(__builtin_va_list  , unsigned long  , void * ) ;  */
/* compiler builtin: 
   void __builtin_va_start(__builtin_va_list  ) ;  */
extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void exit(int __status )  __attribute__((__leaf__)) ;
void f(int attr  , ...) 
{ struct s va_values ;
  va_list va ;

  {
  __builtin_va_start(va, attr);
  if (attr != 2) {
    abort();
  }
  va_values = __builtin_va_arg(va, struct s );
  if (va_values.x != 43690) {
    abort();
  } else {
    if (va_values.y != 21845) {
      abort();
    }
  }
  attr = __builtin_va_arg(va, int );
  if (attr != 3) {
    abort();
  }
  va_values = __builtin_va_arg(va, struct s );
  if (va_values.x != 65535) {
    abort();
  } else {
    if (va_values.y != 4369) {
      abort();
    }
  }
  __builtin_va_end(va);
  return;
}
}
int main(void) 
{ struct s a ;
  struct s b ;

  {
  a.x = 43690;
  a.y = 21845;
  b.x = 65535;
  b.y = 4369;
  f(2, a, 3, b);
  exit(0);
}
}