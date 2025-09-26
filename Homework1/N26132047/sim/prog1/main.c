// Program 1 main.c: Sort
int main(void)
{
	extern int array_size;
	extern int array_addr;

	extern int _test_start;

	int temp, pointer;
	// initial, put first one numn into test_start
	*(&_test_start) = *(&array_addr);

	// start insertion sort
	for (int i = 1; i < array_size; i++)
	{
		*(&_test_start + i) = *(&array_addr + i);
		temp = *(&_test_start + i);
		pointer = i;
		while ((pointer > 0) && (*((&_test_start + pointer) - 1) > temp))
		{
			// swap adjacent
			*(&_test_start + pointer) = *(&_test_start + pointer - 1);
			*(&_test_start + pointer - 1) = temp;
			--pointer; // search for front
		}
	}
	return 0;
}
