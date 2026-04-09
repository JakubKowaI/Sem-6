#pragma once

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    uint8_t bool_wyn;
    uint64_t x;
    uint64_t y;
    uint64_t a;
    uint64_t b;
    uint64_t d;
} diof_wyn;

uint64_t NWD(uint64_t a, uint64_t b);
uint64_t NWD_prime(uint64_t n);
uint64_t euler_totient(uint64_t n);
diof_wyn diophantine(uint64_t a, uint64_t b, uint64_t c);