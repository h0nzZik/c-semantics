#include <stdarg.h>

va_list ap;

int f(int x, int y, ...) {
      va_list ap2;
      va_start(ap, y);
      va_copy(ap2, ap);
      int z = va_arg(ap, int);
      va_end(ap);
      va_end(ap2);
      return z;
}
int main(void) {
      return f(5, 6, 0);
}
