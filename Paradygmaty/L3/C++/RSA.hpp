#pragma once

#include <cstdint>
#include <random>
#include <ctime>
#include <stdexcept>
#include "../../L2/C++/Ring.hpp"

template <typename T>
class RSA
{
private:
    uint64_t privateKey;
    uint64_t publicKey;
    uint64_t n;

    static uint64_t euklides_mod(uint64_t a, uint64_t b, uint64_t mod, uint64_t *x, uint64_t *y) {
        if (b == 0) {
            *x = (mod == 0) ? 1 : (1 % mod);
            *y = 0;
            return a;
        }

        uint64_t x1 = 0;
        uint64_t y1 = 0;
        uint64_t d = euklides_mod(b, a % b, mod, &x1, &y1);

        *x = y1 % mod;
        uint64_t q = (a / b) % mod;
        uint64_t term = static_cast<uint64_t>((static_cast<__uint128_t>(q) * (y1 % mod)) % mod);
        *y = (x1 + mod - term) % mod;
        return d;
    }

    uint64_t mul_mod(uint64_t a, uint64_t b) const {
        return static_cast<uint64_t>((static_cast<__uint128_t>(a) * b) % n);
    }

    uint64_t mod_pow_uint(uint64_t base, uint64_t exp) const {
        uint64_t result = 1 % n;
        base %= n;

        while (exp > 0) {
            if (exp & 1ULL) {
                result = mul_mod(result, base);
            }
            base = mul_mod(base, base);
            exp >>= 1;
        }
        return result;
    }

    bool is_prime(uint64_t n) {
        if (n <= 1)
            return false;

        for (uint64_t i = 2; i < n; i++)
            if (n % i == 0)
                return false;

        return true;
    }

    uint64_t NWD(uint64_t a, uint64_t b) {
        while (b != 0) {
            uint64_t t = b;
            b = a % b;
            a = t;
        }
        return a;
    }

    static uint64_t euklides(const uint64_t a, const uint64_t b, uint64_t *x, uint64_t *y){
        if (x == nullptr || y == nullptr) {
            throw std::invalid_argument("Wskazniki x i y nie moga byc puste");
        }
        if (b == 0) {
            *x = 1;
            *y = 0;
            return a;
        }
        return euklides_mod(a, b, b, x, y);
    }

    T potega(T base, uint64_t exp){
        uint64_t value = static_cast<uint64_t>(base);
        return T(mod_pow_uint(value, exp));
    }
    
public:

    

    RSA(uint64_t p, uint64_t q){
        if(is_prime(p)&&is_prime(q)){
            n=p*q;
            uint64_t lambda=((p-1)*(q-1))/NWD((p-1),(q-1));
            std::mt19937_64 mt(std::time(nullptr));
            std::uniform_int_distribution<uint64_t> dist(2, lambda - 1);
            uint64_t temp = dist(mt);
            while(NWD(temp,lambda)!=1){
                temp = dist(mt);
            }
            publicKey = temp;
            uint64_t x = 0;
            uint64_t k = 0;
            euklides(publicKey, lambda, &x, &k);
            privateKey = x % lambda;
        }else{
            throw std::runtime_error("Podane liczby nie są pierwsze");
        }
    };

    uint64_t getModulo(){
        return n;
    };

    T getPublicKey(){
        return T(publicKey);
    };
    
    T encrypt(T m){
        return potega(m, publicKey);
    };

    T decrypt(T s){
        return potega(s, privateKey);
    };
    ~RSA()=default;
};



