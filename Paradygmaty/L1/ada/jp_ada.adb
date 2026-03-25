with Interfaces;
use type Interfaces.Unsigned_64;
use type Interfaces.Unsigned_8;
use type Interfaces.Integer_64;

package body JP_Ada is

   Two : constant U64 := U64 (2);
   Three : constant U64 := U64 (3);

   function Ext_Gcd (A, B : Long_Long_Integer; X, Y : out Long_Long_Integer) return Long_Long_Integer is
      X1, Y1 : Long_Long_Integer := 0;
      D : Long_Long_Integer := 0;
   begin
      if B = 0 then
         X := 1;
         Y := 0;
         return A;
      end if;

      D := Ext_Gcd (B, A rem B, X1, Y1);
      X := Y1;
      Y := X1 - (A / B) * Y1;
      return D;
   end Ext_Gcd;

   function Gcd (A, B : U64) return U64 is
      X : U64 := A;
      Y : U64 := B;
      T : U64 := 0;
   begin
      while Y /= 0 loop
         T := Y;
         Y := X mod Y;
         X := T;
      end loop;
      return X;
   end Gcd;

   function Smallest_Prime_Divisor (N : U64) return U64 is
      D : U64 := Three;
   begin
      if N <= U64 (1) then
         return 0;
      end if;
      if (N mod Two) = 0 then
         return Two;
      end if;

      while D <= N / D loop
         if (N mod D) = 0 then
            return D;
         end if;
         D := D + Two;
      end loop;

      return N;
   end Smallest_Prime_Divisor;

   function Euler_Totient (N : U64) return U64 is
      Result : U64 := N;
      X : U64 := N;
      P : U64 := Three;
   begin
      if N = 0 then
         return 0;
      end if;

      if (X mod Two) = 0 then
         Result := Result - Result / Two;
         while (X mod Two) = 0 loop
            X := X / Two;
         end loop;
      end if;

      while P <= X / P loop
         if (X mod P) = 0 then
            Result := Result - Result / P;
            while (X mod P) = 0 loop
               X := X / P;
            end loop;
         end if;
         P := P + Two;
      end loop;

      if X > U64 (1) then
         Result := Result - Result / X;
      end if;

      return Result;
   end Euler_Totient;

   function Solve_Diophantine (A, B, C : U64) return Dio_Result is
      Out_R : Dio_Result := (Bool_Wyn => 0, X => 0, Y => 0, A => 0, B => 0, D => 0);
      B_Signed : I64 := -I64 (B);
      X0 : Long_Long_Integer := 0;
      Y0 : Long_Long_Integer := 0;
      D : Long_Long_Integer := 0;
      A_Prim : I64 := 0;
      B_Prim : I64 := 0;
      C_Prim : I64 := 0;
   begin
      if A = 0 and B = 0 then
         if C = 0 then
            Out_R.Bool_Wyn := U8 (1);
         end if;
         return Out_R;
      end if;

      if A = 0 then
         if (C mod B) = 0 then
            Out_R.Bool_Wyn := U8 (1);
            Out_R.Y := (-I64 (C)) / I64 (B);
         end if;
         return Out_R;
      end if;

      if B = 0 then
         if (C mod A) = 0 then
            Out_R.Bool_Wyn := U8 (1);
            Out_R.X := I64 (C / A);
         end if;
         return Out_R;
      end if;

      D := Long_Long_Integer (Gcd (A, B));
      if D = 0 or else (C mod U64 (D)) /= 0 then
         return Out_R;
      end if;

      A_Prim := I64 (A / U64 (D));
      B_Prim := B_Signed / I64 (D);
      C_Prim := I64 (C / U64 (D));

      D := Ext_Gcd (Long_Long_Integer (A_Prim), Long_Long_Integer (B_Prim), X0, Y0);
      if D < 0 then
         D := -D;
         X0 := -X0;
         Y0 := -Y0;
      end if;

      Out_R.Bool_Wyn := U8 (1);
      Out_R.X := I64 (X0) * C_Prim;
      Out_R.Y := I64 (Y0) * C_Prim;
      Out_R.A := I64 (A);
      Out_R.B := B_Signed;
      Out_R.D := I64 (D);
      return Out_R;
   end Solve_Diophantine;

end JP_Ada;