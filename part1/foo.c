#include <stdio.h>

static int ARRAY[1048576];

int main(int argc, char** argv) {
    int n, i, result;

    scanf("%d", &n);
    for (i = 0; i < n; ++i) {
        ARRAY[i] = i;
    }

    i = n / 2;
    result = ARRAY[i];
    printf("%d", result);

    return 0;
}
