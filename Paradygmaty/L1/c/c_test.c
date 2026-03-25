#include <stdio.h>
#include "../include/c_lib.h"
#include "../include/jp_ffi.h"

static void print_dio(const char *name, diof_wyn r) {
    if (!r.bool_wyn) {
        printf("%s: brak rozwiazania\n", name);
        return;
    }
        printf("%s: x=%lld y=%lld\n", name, (long long)r.x, (long long)r.y);
}

int main(void) {
    printf("Test C w C\n");

    uint64_t a = 84;
    uint64_t b = 30;
    uint64_t n = 91;
    uint64_t e = 36;

    printf("NWD(%llu,%llu)=%llu\n", (unsigned long long)a, (unsigned long long)b,
           (unsigned long long)NWD(a, b));
    printf("NWD_prime(%llu)=%llu\n", (unsigned long long)n,
           (unsigned long long)NWD_prime(n));
    printf("euler(%llu)=%llu\n", (unsigned long long)e,
           (unsigned long long)euler_totient(e));
    print_dio("diof", diophantine(7, 5, 9));

    printf("[Ada wrapper] gcd=%llu\n", (unsigned long long)jp_c_wrap_ada_gcd(a, b));
    printf("[Ada wrapper] spd=%llu\n", (unsigned long long)jp_c_wrap_ada_smallest_prime_divisor(n));
    printf("[Ada wrapper] phi=%llu\n", (unsigned long long)jp_c_wrap_ada_euler_totient(e));
    print_dio("[Ada wrapper] dio", jp_c_wrap_ada_solve_diophantine(7, 5, 9));

    printf("[Rust wrapper] gcd=%llu\n", (unsigned long long)jp_c_wrap_rust_gcd(a, b));
    printf("[Rust wrapper] spd=%llu\n", (unsigned long long)jp_c_wrap_rust_smallest_prime_divisor(n));
    printf("[Rust wrapper] phi=%llu\n", (unsigned long long)jp_c_wrap_rust_euler_totient(e));
    print_dio("[Rust wrapper] dio", jp_c_wrap_rust_solve_diophantine(7, 5, 9));

    return 0;
}