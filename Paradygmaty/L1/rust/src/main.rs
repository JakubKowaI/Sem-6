use jp_rust::{
    jp_rust_euler_totient, jp_rust_gcd, jp_rust_smallest_prime_divisor, jp_rust_solve_diophantine,
    JpDioResult,
};

unsafe extern "C" {
    fn NWD(a: u64, b: u64) -> u64;
    fn NWD_prime(n: u64) -> u64;
    fn euler_totient(n: u64) -> u64;
    fn diophantine(a: u64, b: u64, c: u64) -> JpDioResult;

    fn jp_ada_gcd(a: u64, b: u64) -> u64;
    fn jp_ada_smallest_prime_divisor(n: u64) -> u64;
    fn jp_ada_euler_totient(n: u64) -> u64;
    fn jp_ada_solve_diophantine(a: u64, b: u64, c: u64) -> JpDioResult;
}

fn wrap_c_gcd(a: u64, b: u64) -> u64 {
    unsafe { NWD(a, b) }
}

fn wrap_c_smallest_prime_divisor(n: u64) -> u64 {
    unsafe { NWD_prime(n) }
}

fn wrap_c_euler_totient(n: u64) -> u64 {
    unsafe { euler_totient(n) }
}

fn wrap_c_solve_diophantine(a: u64, b: u64, c: u64) -> JpDioResult {
    unsafe { diophantine(a, b, c) }
}

fn wrap_ada_gcd(a: u64, b: u64) -> u64 {
    unsafe { jp_ada_gcd(a, b) }
}

fn wrap_ada_smallest_prime_divisor(n: u64) -> u64 {
    unsafe { jp_ada_smallest_prime_divisor(n) }
}

fn wrap_ada_euler_totient(n: u64) -> u64 {
    unsafe { jp_ada_euler_totient(n) }
}

fn wrap_ada_solve_diophantine(a: u64, b: u64, c: u64) -> JpDioResult {
    unsafe { jp_ada_solve_diophantine(a, b, c) }
}

fn print_dio(name: &str, r: JpDioResult) {
    if r.bool_wyn == 0 {
        println!("{}: brak rozwiazania", name);
    } else {
        println!("{}: x={} y={}", name, r.x, r.y);
    }
}

fn main() {
    println!("=== Test Rust (zad. 6) ===");

    println!("[Rust] gcd={}", jp_rust_gcd(84, 30));
    println!("[Rust] spd={}", jp_rust_smallest_prime_divisor(91));
    println!("[Rust] phi={}", jp_rust_euler_totient(36));
    print_dio("[Rust] dio", jp_rust_solve_diophantine(7, 5, 9));

    println!("[C wrapper] gcd={}", wrap_c_gcd(84, 30));
    println!("[C wrapper] spd={}", wrap_c_smallest_prime_divisor(91));
    println!("[C wrapper] phi={}", wrap_c_euler_totient(36));
    print_dio("[C wrapper] dio", wrap_c_solve_diophantine(7, 5, 9));

    println!("[Ada wrapper] gcd={}", wrap_ada_gcd(84, 30));
    println!("[Ada wrapper] spd={}", wrap_ada_smallest_prime_divisor(91));
    println!("[Ada wrapper] phi={}", wrap_ada_euler_totient(36));
    print_dio("[Ada wrapper] dio", wrap_ada_solve_diophantine(7, 5, 9));
}