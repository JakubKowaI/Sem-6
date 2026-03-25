with Interfaces;

package JP_Ada is
   subtype U64 is Interfaces.Unsigned_64;
   subtype U8 is Interfaces.Unsigned_8;
   subtype I64 is Interfaces.Integer_64;

   type Dio_Result is record
      Bool_Wyn : U8;
      X : I64;
      Y : I64;
      A : I64;
      B : I64;
      D : I64;
   end record;
   pragma Convention (C, Dio_Result);

   function Gcd (A, B : U64) return U64;
   pragma Export (C, Gcd, "jp_ada_gcd");

   function Smallest_Prime_Divisor (N : U64) return U64;
   pragma Export (C, Smallest_Prime_Divisor, "jp_ada_smallest_prime_divisor");

   function Euler_Totient (N : U64) return U64;
   pragma Export (C, Euler_Totient, "jp_ada_euler_totient");

   function Solve_Diophantine (A, B, C : U64) return Dio_Result;
   pragma Export (C, Solve_Diophantine, "jp_ada_solve_diophantine");
end JP_Ada;