enum class E {A, B=E::A, C};


int main()
{
	E::A;
	return 0;
}

// for {-1, 0, +1}
// for two's complement:
// b_max = max(abs(-1)-1, abs(1)) = max(0, 1) = 1, bound to power of two is 1
// b_min = {-1 is not nonnegative => } -(+1 + 1) = -2,
//
// for {-1, 0, +1, +2}
// b_max = max(abs(-1)-1, abs(2)} = max(0, 2) = 2, bound to power of two is 2
// b_min = 

