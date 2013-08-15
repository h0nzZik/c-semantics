/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
int main(void) 
{ int i ;
  double oldrho ;
  double beta ;
  double work ;
  double rho ;

  {
  beta = 0.0;
  work = 1.0;
  i = 1;
  while (i <= 2) {
    rho = work * work;
    if (i != 1) {
      beta = rho / oldrho;
    }
    if (beta == 1.0) {
      abort();
    }
    work /= 2.0;
    oldrho = rho;
    i ++;
  }
  return (0);
}
}