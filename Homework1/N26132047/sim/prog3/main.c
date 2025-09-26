int GCD(int data_1, int data_2)
{
	data_1 = data_1 % data_2;
	if (data_1 == 0)
		return data_2;
	else
		return GCD(data_2, data_1);
}

int main()
{
	extern int _test_start;
	extern int div1;
	extern int div2;

	// swap (div1 need > div2)
	if (div1 < div2)
	{
		int temp = div1;
		div1 = div2;
		div2 = temp;
	}

	// call GCD function
	*(&_test_start) = GCD(div1, div2);

	return 0;
}
