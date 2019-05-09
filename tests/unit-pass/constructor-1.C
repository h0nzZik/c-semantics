#include<assert.h>
// see after 976 steps without explicit
// after 980 steps with explicit.
// after 979 with explicit we have two functions (with copy constructor)
// but one (the constructor) gets discarded probably.

// TODO(now) Check what happens on master branch
// when we have some user-defined copy-constructor
struct A {
  int x;
  /*explicit*/ A(int x) { this->x = x; }
  A(A const & o) : x(o.x) {}
};

int main() {
  A x(0);
  A y(5);
  assert(x.x == 0);
  assert(y.x == 5);
}
