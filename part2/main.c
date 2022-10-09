#include <stdio.h>

int ARRAY[1048576];

extern void fill_array(int n);
extern int get_result(int n);

int main(int argc, char** argv) {
    int n, result;
    FILE *input, *output;

    input = fopen("input.txt", "r");
    fscanf(input, "%d", &n);

    fill_array(n);

    output = fopen("output.txt", "w");
    result = get_result(n);
    fprintf(output, "%d", result);

    return 0;
}
