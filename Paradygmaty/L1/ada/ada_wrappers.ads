with Interfaces;
with JP_Ada;

package Ada_Wrappers is
   subtype U64 is Interfaces.Unsigned_64;
   subtype Dio_Result is JP_Ada.Dio_Result;

   function Wrap_C_Gcd (A, B : U64) return U64;
   function Wrap_C_Smallest_Prime_Divisor (N : U64) return U64;
   function Wrap_C_Euler_Totient (N : U64) return U64;
   function Wrap_C_Solve_Diophantine (A, B, C : U64) return Dio_Result;

   function Wrap_Rust_Gcd (A, B : U64) return U64;
   function Wrap_Rust_Smallest_Prime_Divisor (N : U64) return U64;
   function Wrap_Rust_Euler_Totient (N : U64) return U64;
   function Wrap_Rust_Solve_Diophantine (A, B, C : U64) return Dio_Result;
end Ada_Wrappers;