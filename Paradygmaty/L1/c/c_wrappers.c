#include "../include/jp_ffi.h"

uint64_t jp_c_wrap_ada_gcd(uint64_t a, uint64_t b) {
    return jp_ada_gcd(a, b);
}

uint64_t jp_c_wrap_ada_smallest_prime_divisor(uint64_t n) {
    return jp_ada_smallest_prime_divisor(n);
}

uint64_t jp_c_wrap_ada_euler_totient(uint64_t n) {
    return jp_ada_euler_totient(n);
}

diof_wyn jp_c_wrap_ada_solve_diophantine(uint64_t a, uint64_t b, uint64_t c) {
    return jp_ada_solve_diophantine(a, b, c);
}

uint64_t jp_c_wrap_rust_gcd(uint64_t a, uint64_t b) {
    return jp_rust_gcd(a, b);
}

uint64_t jp_c_wrap_rust_smallest_prime_divisor(uint64_t n) {
    return jp_rust_smallest_prime_divisor(n);
}

uint64_t jp_c_wrap_rust_euler_totient(uint64_t n) {
    return jp_rust_euler_totient(n);
}

diof_wyn jp_c_wrap_rust_solve_diophantine(uint64_t a, uint64_t b, uint64_t c) {
    return jp_rust_solve_diophantine(a, b, c);
}