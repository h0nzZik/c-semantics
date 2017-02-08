extern "C" void abort();

enum E {};

E e;

int main() {
	E f = e;
	E * g = nullptr;

	if (sizeof(e) != sizeof(int))
		abort();

	E h = (E)2;
}
