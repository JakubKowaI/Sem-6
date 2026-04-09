#include "../include/c_lib.h"

static int64_t euklides(int64_t a, int64_t b, int64_t *x, int64_t *y) {
    if (b == 0) {
        *x = 1;
        *y = 0;
        return a;
    }
    //printf("a: %lld, b: %lld\n",a,b);
    int64_t x1 = 0;
    int64_t y1 = 0;
    int64_t d = euklides(b, a % b, &x1, &y1);
    *x = y1;
    *y = x1 - (a / b) * y1;
    return d;
}

bool is_prime(int n) {
    if (n <= 1)
        return false;

    for (int i = 2; i < n; i++)
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

uint64_t NWD_prime(uint64_t a) {
    uint64_t dziel = 1;
    while (dziel<=a) {
        if(a%dziel==0&&is_prime(dziel))
            return dziel;

        dziel++;
    }
    return 1;
}

uint64_t euler_totient(uint64_t n) {
    uint64_t result = n;
    for (uint64_t i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            while (n % i == 0)
                n /= i;
            result -= result / i;
        }
    }
    if (n > 1)
        result -= result / n;
    return result;
}

diof_wyn diophantine(uint64_t a, uint64_t b, uint64_t c) {
    diof_wyn out = {0, 0, 0, 0, 0, 0};
    int64_t b_signed = -(int64_t)b;

    if (a == 0 && b == 0) {
        if (c == 0) {
            out.bool_wyn = 1;
        }
        return out;
    }

    if (a == 0) {
        if (c == 0) {
            out.bool_wyn = 1;
        }
        return out;
    }

    if (b == 0) {
        if (c % a == 0) {
            out.bool_wyn = 1;
            out.x = c / a;
        }
        return out;
    }

    uint64_t x0 = 0;
    uint64_t y0 = 0;
    uint64_t d = NWD(a,b);
    //printf("D: %lld\n",d);

    if (d == 0 || c % d != 0) {
        return out;
    }

    uint64_t aprim = a / d;
    uint64_t bprim = b_signed / d;
    uint64_t cprim = c / d;

    d = euklides(aprim, bprim, &x0, &y0);
    // if (d < 0) {
    //     d = -d;
    //     x0 = -x0;
    //     y0 = -y0;
    // }
    //printf("x0: %ld, y0: %ld\n",x0,y0);

    out.bool_wyn = 1;
    out.x = x0 * cprim;
    out.y = y0 * cprim;
    out.a = a;
    out.b = b_signed;
    out.d = d;
    return out;
}