extern int ARRAY[];

int get_result(int n) {
    int i, result;

    i = n / 2;
    result = ARRAY[i];

    return result;
}
