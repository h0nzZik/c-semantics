enum class E2 { U = -1 - 1, V = 1 + 1 };
enum class E3 {U = 1, V = E3::U, X, Y = E3::V + 1};

int main()
{
	E2 e2 = E2::V;
	E3 e3 = E3::U;
	{E3 e3 = E3::Y;}
}

