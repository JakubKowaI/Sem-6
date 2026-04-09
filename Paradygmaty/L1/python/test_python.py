from __future__ import annotations

import ctypes
from ctypes import c_int64, c_uint8, c_uint64, Structure
from pathlib import Path


class DioResult(Structure):
    _fields_ = [
        ("bool_wyn", c_uint8),
        ("x", c_uint64),
        ("y", c_uint64),
        ("a", c_uint64),
        ("b", c_uint64),
        ("d", c_uint64),
    ]


def bind_lib(path: Path):
    lib = ctypes.CDLL(str(path))

    lib.NWD.argtypes = [c_uint64, c_uint64]
    lib.NWD.restype = c_uint64
    lib.NWD_prime.argtypes = [c_uint64]
    lib.NWD_prime.restype = c_uint64
    lib.euler_totient.argtypes = [c_uint64]
    lib.euler_totient.restype = c_uint64
    lib.diophantine.argtypes = [c_uint64, c_uint64, c_uint64]
    lib.diophantine.restype = DioResult

    return lib


def bind_ada(path: Path):
    lib = ctypes.CDLL(str(path))

    lib.jp_ada_gcd.argtypes = [c_uint64, c_uint64]
    lib.jp_ada_gcd.restype = c_uint64
    lib.jp_ada_smallest_prime_divisor.argtypes = [c_uint64]
    lib.jp_ada_smallest_prime_divisor.restype = c_uint64
    lib.jp_ada_euler_totient.argtypes = [c_uint64]
    lib.jp_ada_euler_totient.restype = c_uint64
    lib.jp_ada_solve_diophantine.argtypes = [c_uint64, c_uint64, c_uint64]
    lib.jp_ada_solve_diophantine.restype = DioResult

    return lib


def bind_rust(path: Path):
    lib = ctypes.CDLL(str(path))

    lib.jp_rust_gcd.argtypes = [c_uint64, c_uint64]
    lib.jp_rust_gcd.restype = c_uint64
    lib.jp_rust_smallest_prime_divisor.argtypes = [c_uint64]
    lib.jp_rust_smallest_prime_divisor.restype = c_uint64
    lib.jp_rust_euler_totient.argtypes = [c_uint64]
    lib.jp_rust_euler_totient.restype = c_uint64
    lib.jp_rust_solve_diophantine.argtypes = [c_uint64, c_uint64, c_uint64]
    lib.jp_rust_solve_diophantine.restype = DioResult

    return lib


def print_dio(prefix: str, value: DioResult) -> None:
    if value.bool_wyn == 0:
        print(f"{prefix}: brak rozwiazania")
    else:
        print(f"{prefix}: x={value.x} y={value.y}")


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    build = root / "build"

    lib_c = bind_lib(build / "libjp_c.so")
    lib_ada = bind_ada(build / "libjp_ada.so")
    lib_rust = bind_rust(build / "libjp_rust.so")

    print("=== Test Python (zad. 7) ===")

    print(f"[C wrapper] gcd={lib_c.NWD(84, 30)}")
    print(f"[C wrapper] spd={lib_c.NWD_prime(91)}")
    print(f"[C wrapper] phi={lib_c.euler_totient(123)}")
    print_dio("[C wrapper] dio", lib_c.diophantine(28, 59, 4))

    print(f"[Ada wrapper] gcd={lib_ada.jp_ada_gcd(84, 30)}")
    print(f"[Ada wrapper] spd={lib_ada.jp_ada_smallest_prime_divisor(91)}")
    print(f"[Ada wrapper] phi={lib_ada.jp_ada_euler_totient(123)}")
    print_dio("[Ada wrapper] dio", lib_ada.jp_ada_solve_diophantine(28, 59, 4))

    print(f"[Rust wrapper] gcd={lib_rust.jp_rust_gcd(84, 30)}")
    print(f"[Rust wrapper] spd={lib_rust.jp_rust_smallest_prime_divisor(91)}")
    print(f"[Rust wrapper] phi={lib_rust.jp_rust_euler_totient(123)}")
    print_dio("[Rust wrapper] dio", lib_rust.jp_rust_solve_diophantine(28, 59, 4))

    print_dio("[C wrapper] dio", lib_c.diophantine(-28, 59, 4))
    #print_dio("[Ada wrapper] dio", lib_ada.jp_ada_solve_diophantine(-28, 59, 4))
    print_dio("[Rust wrapper] dio", lib_rust.jp_rust_solve_diophantine(-28, 59, 4))

    print_dio("[C wrapper] dio", lib_c.diophantine(0, 2, 4))
    print_dio("[Ada wrapper] dio", lib_ada.jp_ada_solve_diophantine(0, 2, 4))
    print_dio("[Rust wrapper] dio", lib_rust.jp_rust_solve_diophantine(0, 2, 4))

if __name__ == "__main__":
    main()