#pragma once

#include <cstdint>
#include <ctime>
#include <random>
#include <stdexcept>
#include <vector>

#include "../../L2/C++/Ring.hpp"

template <typename T>
class DHSetup {
private:
    uint64_t p;
    T g;

    bool is_prime(uint64_t n) const {
        if (n <= 1) {
            return false;
        }
        for (uint64_t i = 2; i * i <= n; ++i) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

    std::vector<uint64_t> prime_factors(uint64_t value) const {
        std::vector<uint64_t> factors;
        for (uint64_t d = 2; d * d <= value; ++d) {
            if (value % d == 0) {
                factors.push_back(d);
                while (value % d == 0) {
                    value /= d;
                }
            }
        }
        if (value > 1) {
            factors.push_back(value);
        }
        return factors;
    }

    uint64_t mul_mod(uint64_t a, uint64_t b) const {
        return static_cast<uint64_t>((static_cast<__uint128_t>(a) * b) % p);
    }

    uint64_t mod_pow_uint(uint64_t base, uint64_t exp) const {
        uint64_t result = 1 % p;
        base %= p;

        while (exp > 0) {
            if (exp & 1ULL) {
                result = mul_mod(result, base);
            }
            base = mul_mod(base, base);
            exp >>= 1;
        }
        return result;
    }

    bool is_generator(uint64_t x) const {
        if (x <= 1 || x >= p) {
            return false;
        }

        const uint64_t phi = p - 1;
        const std::vector<uint64_t> factors = prime_factors(phi);
        for (uint64_t factor : factors) {
            if (mod_pow_uint(x, phi / factor) == 1) {
                return false;
            }
        }
        return true;
    }

public:
    explicit DHSetup(uint64_t pp) : p(pp), g(1) {
        if (p < 5 || !is_prime(p)) {
            throw std::runtime_error("Modul p musi byc liczba pierwsza >= 5");
        }

        std::mt19937_64 mt(std::time(nullptr));
        std::uniform_int_distribution<uint64_t> dist(2, p - 2);

        uint64_t temp = dist(mt);
        while (!is_generator(temp)) {
            temp = dist(mt);
        }

        g = T(static_cast<int>(temp));
    }

    uint64_t getModulo() const {
        return p;
    }

    T getGenerator() const {
        return g;
    }

    T power(T a, uint64_t b) const {
        const uint64_t value = static_cast<uint64_t>(a);
        return T(static_cast<int>(mod_pow_uint(value, b)));
    }

    ~DHSetup() = default;
};
