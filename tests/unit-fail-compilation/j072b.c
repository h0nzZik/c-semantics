_Alignas(8) int x = 42;

int main(void) {
      extern _Alignas(4) int x;
      return 0;
}
