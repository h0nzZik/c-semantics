struct A{};
A foo(){return A();}

int main() {
  A const &a = foo();
}
