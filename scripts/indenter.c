#include <stdio.h>
#include <stdbool.h>

int main() {
	setvbuf(stdout, NULL, _IONBF, 0);
	bool indent = true;
	while(true) {
		int const c = getchar();
		if (c == EOF)
			return 0;
		if (indent) {
			putchar(' ');
			putchar(' ');
		}
		indent = c == '\n';
		putchar(c);
	}
	return 0;
}
