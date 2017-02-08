//extern "C" void abort();

/*

enum class E2 { U = -1 - 1, V = 1 + 1 };
enum class E3 {U = 1, V = E3::U, X, Y = E3::V + 1};
*/
enum E4 {U=0, V=15};
//class C{};
int main()
{
	/*
	E2 e2 = E2::V;
	E3 e3 = E3::U;
	{E3 e3 = E3::Y;}

	E2 e4 = (E2)5;
	int e5 = (int)(E4)8;
	*/ // Z nejakeho duvodu tohle neni problem. Potreba nastudovat ve standardu
//	int a = 10;
	//E4 e4 = (E4)10;
	E4 e4 = 10;
	//if ((int)e4 != 10)
	//	abort();
	//int x = (int)e4;
	//C c;
}

// for {-1, 0, +1}
// for two's complement:
// b_max = max(abs(-1)-1, abs(1)) = max(0, 1) = 1, bound to power of two is 1
// b_min = {-1 is not nonnegative => } -(+1 + 1) = -2,
//
// for {-1, 0, +1, +2}
// b_max = max(abs(-1)-1, abs(2)} = max(0, 2) = 2, bound to power of two is 2
// b_min = 

