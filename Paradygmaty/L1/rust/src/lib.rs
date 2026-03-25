#[repr(C)]
#[derive(Clone, Copy, Debug)]
pub struct JpDioResult {
    pub bool_wyn: u8,
    pub x: i64,
    pub y: i64,
    pub a: i64,
    pub b: i64,
    pub d: i64,
}

fn ext_gcd(a: i64, b: i64) -> (i64, i64, i64) {
    if b == 0 {
        return (a, 1, 0);
    }
    let (d, x1, y1) = ext_gcd(b, a % b);
    (d, y1, x1 - (a / b) * y1)
}

#[unsafe(no_mangle)]
pub extern "C" fn jp_rust_gcd(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let t = b;
        b = a % b;
        a = t;
    }
    a
}

#[unsafe(no_mangle)]
pub extern "C" fn jp_rust_smallest_prime_divisor(n: u64) -> u64 {
    if n <= 1 {
        return 0;
    }
    if n % 2 == 0 {
        return 2;
    }

    let mut d = 3_u64;
    while d <= n / d {
        if n % d == 0 {
            return d;
        }
        d += 2;
    }
    n
}

#[unsafe(no_mangle)]
pub extern "C" fn jp_rust_euler_totient(n: u64) -> u64 {
    if n == 0 {
        return 0;
    }
    let mut result = n;
    let mut x = n;

    if x % 2 == 0 {
        result -= result / 2;
        while x % 2 == 0 {
            x /= 2;
        }
    }

    let mut p = 3_u64;
    while p <= x / p {
        if x % p == 0 {
            result -= result / p;
            while x % p == 0 {
                x /= p;
            }
        }
        p += 2;
    }

    if x > 1 {
        result -= result / x;
    }

    result
}

#[unsafe(no_mangle)]
pub extern "C" fn jp_rust_solve_diophantine(a: u64, b: u64, c: u64) -> JpDioResult {
    let mut out = JpDioResult {
        bool_wyn: 0,
        x: 0,
        y: 0,
        a: 0,
        b: 0,
        d: 0,
    };
    let b_signed = -(b as i64);

    if a == 0 && b == 0 {
        if c == 0 {
            out.bool_wyn = 1;
        }
        return out;
    }

    if a == 0 {
        if c % b == 0 {
            out.bool_wyn = 1;
            out.y = -((c as i64) / (b as i64));
        }
        return out;
    }

    if b == 0 {
        if c % a == 0 {
            out.bool_wyn = 1;
            out.x = (c / a) as i64;
        }
        return out;
    }

    let mut d = jp_rust_gcd(a, b) as i64;
    if d == 0 || c % (d as u64) != 0 {
        return out;
    }

    let aprim = (a / d as u64) as i64;
    let bprim = b_signed / d;
    let cprim = (c / d as u64) as i64;

    let (mut ext_d, mut x0, mut y0) = ext_gcd(aprim, bprim);
    if ext_d < 0 {
        ext_d = -ext_d;
        x0 = -x0;
        y0 = -y0;
    }

    d = ext_d;
    out.bool_wyn = 1;
    out.x = x0 * cprim;
    out.y = y0 * cprim;
    out.a = a as i64;
    out.b = b_signed;
    out.d = d;
    out
}