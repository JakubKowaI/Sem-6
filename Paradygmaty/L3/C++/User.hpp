#pragma once 

#include <cstdint>
#include <random>
#include <ctime>
#include <stdexcept>
#include "../../L2/C++/Ring.hpp"
#include "DHSetup.hpp"

template <typename T>
class User
{
private:
    uint64_t my_secret;
    T shared_key;
    bool has_key;
    DHSetup<T> *dhs;
    
public:
    explicit User(DHSetup<T> &d) : my_secret(0), shared_key(1), has_key(false), dhs(&d) {
        uint64_t p = dhs->getModulo();
        if (p <= 3) {
            throw std::runtime_error("Niepoprawny modul p");
        }

        std::mt19937_64 mt(std::time(nullptr));
        std::uniform_int_distribution<uint64_t> dist(2, p - 2);
        my_secret = dist(mt);
    }

    T getPublicKey() const {
        return dhs->power(dhs->getGenerator(), my_secret);
    }

    void setKey(T a) {
        shared_key = dhs->power(a, my_secret);
        has_key = true;
    }

    T encrypt(T m) const {
        if (!has_key) {
            throw std::runtime_error("Sekret nie ustawiony!");
        }
        return m * shared_key;
    }

    T decrypt(T c) const {
        if (!has_key) {
            throw std::runtime_error("Sekret nie ustawiony!");
        }
        return c / shared_key;
    }

    T getSharedKey() const {
        if (!has_key) {
            throw std::runtime_error("Sekret nie ustawiony!");
        }
        return shared_key;
    }

    ~User() = default;
};
