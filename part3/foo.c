#include <stdio.h>
#include <stdlib.h>
#include <time.h>

const int THRESHOLD = RAND_MAX - 10;

int64_t timespecDiff(
    struct timespec timeA,  // { tv_sec, tv_nsec }
    struct timespec timeB   // { tv_sec, tv_nsec }
)
{
    int64_t nsecA, nsecB;

    nsecA = timeA.tv_sec;
    nsecA *= 1000000000;
    nsecA += timeA.tv_nsec;


    nsecB = timeB.tv_sec;
    nsecB *= 1000000000;
    nsecB += timeB.tv_nsec;

    return nsecA - nsecB;
}


int main(int argc, char** argv) {
    char* arg;
    int seed;
    int n;
    struct timespec start;
    struct timespec end;
    int64_t elapsed_ns;

    if (argc == 2) {         // [foo.exe, seed]
        arg = argv[1];
        seed = atoi(arg);
        srand(seed);
    } else {                 // exit with error
        return 1;
    }

    clock_gettime(CLOCK_MONOTONIC, &start);
    n = 0;
    while (n < THRESHOLD) {
        n = rand();
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    elapsed_ns = timespecDiff(end, start);
    printf("Elapsed: %ld ns", elapsed_ns);

    return 0;
}
