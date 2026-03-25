#pragma once

#include <stdint.h>
#include "c_lib.h"

uint64_t jp_ada_gcd(uint64_t a, uint64_t b);
uint64_t jp_ada_smallest_prime_divisor(uint64_t n);
uint64_t jp_ada_euler_totient(uint64_t n);
diof_wyn jp_ada_solve_diophantine(uint64_t a, uint64_t b, uint64_t c);

uint64_t jp_rust_gcd(uint64_t a, uint64_t b);
uint64_t jp_rust_smallest_prime_divisor(uint64_t n);
uint64_t jp_rust_euler_totient(uint64_t n);
diof_wyn jp_rust_solve_diophantine(uint64_t a, uint64_t b, uint64_t c);

uint64_t jp_c_wrap_ada_gcd(uint64_t a, uint64_t b);
uint64_t jp_c_wrap_ada_smallest_prime_divisor(uint64_t n);
uint64_t jp_c_wrap_ada_euler_totient(uint64_t n);
diof_wyn jp_c_wrap_ada_solve_diophantine(uint64_t a, uint64_t b, uint64_t c);

uint64_t jp_c_wrap_rust_gcd(uint64_t a, uint64_t b);
uint64_t jp_c_wrap_rust_smallest_prime_divisor(uint64_t n);
uint64_t jp_c_wrap_rust_euler_totient(uint64_t n);
diof_wyn jp_c_wrap_rust_solve_diophantine(uint64_t a, uint64_t b, uint64_t c);