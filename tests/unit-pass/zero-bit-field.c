#include<stdlib.h>
struct foo {
  int x : 5;
  int : 1;
  int : 0;
  int z : 2;
};

int main() {
  if(sizeof(struct foo) != 2)
    abort();
  return 0;
}
