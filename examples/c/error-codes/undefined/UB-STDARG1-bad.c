#include <stdarg.h>

va_list ap;

int f(int x, int y) {
      va_start(ap, y);
      va_end(ap);
      return 0;
}
int main(void) {
      return f(5, 6);
}
