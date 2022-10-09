extern int ARRAY[];

void fill_array(int n) {
    int i;

    for (i = 0; i < n; ++i) {
        ARRAY[i] = i;
    }
}
