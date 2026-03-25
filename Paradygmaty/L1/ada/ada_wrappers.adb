with Interfaces;
with JP_Ada;

package body Ada_Wrappers is
   function C_Gcd (A, B : U64) return U64;
   pragma Import (C, C_Gcd, "NWD");

   function C_Smallest_Prime_Divisor (N : U64) return U64;
   pragma Import (C, C_Smallest_Prime_Divisor, "NWD_prime");

   function C_Euler_Totient (N : U64) return U64;
   pragma Import (C, C_Euler_Totient, "euler_totient");

   function C_Solve_Diophantine (A, B, C : U64) return Dio_Result;
   pragma Import (C, C_Solve_Diophantine, "diophantine");

   function Rust_Gcd (A, B : U64) return U64;
   pragma Import (C, Rust_Gcd, "jp_rust_gcd");

   function Rust_Smallest_Prime_Divisor (N : U64) return U64;
   pragma Import (C, Rust_Smallest_Prime_Divisor, "jp_rust_smallest_prime_divisor");

   function Rust_Euler_Totient (N : U64) return U64;
   pragma Import (C, Rust_Euler_Totient, "jp_rust_euler_totient");

   function Rust_Solve_Diophantine (A, B, C : U64) return Dio_Result;
   pragma Import (C, Rust_Solve_Diophantine, "jp_rust_solve_diophantine");

   function Wrap_C_Gcd (A, B : U64) return U64 is
   begin
      return C_Gcd (A, B);
   end Wrap_C_Gcd;

   function Wrap_C_Smallest_Prime_Divisor (N : U64) return U64 is
   begin
      return C_Smallest_Prime_Divisor (N);
   end Wrap_C_Smallest_Prime_Divisor;

   function Wrap_C_Euler_Totient (N : U64) return U64 is
   begin
      return C_Euler_Totient (N);
   end Wrap_C_Euler_Totient;

   function Wrap_C_Solve_Diophantine (A, B, C : U64) return Dio_Result is
   begin
      return C_Solve_Diophantine (A, B, C);
   end Wrap_C_Solve_Diophantine;

   function Wrap_Rust_Gcd (A, B : U64) return U64 is
   begin
      return Rust_Gcd (A, B);
   end Wrap_Rust_Gcd;

   function Wrap_Rust_Smallest_Prime_Divisor (N : U64) return U64 is
   begin
      return Rust_Smallest_Prime_Divisor (N);
   end Wrap_Rust_Smallest_Prime_Divisor;

   function Wrap_Rust_Euler_Totient (N : U64) return U64 is
   begin
      return Rust_Euler_Totient (N);
   end Wrap_Rust_Euler_Totient;

   function Wrap_Rust_Solve_Diophantine (A, B, C : U64) return Dio_Result is
   begin
      return Rust_Solve_Diophantine (A, B, C);
   end Wrap_Rust_Solve_Diophantine;

end Ada_Wrappers;