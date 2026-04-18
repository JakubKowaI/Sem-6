with Ada.Numerics.Float_Random;

package body RSA is

   function Is_Prime (N : Long_Long_Integer) return Boolean is
      I : Long_Long_Integer := 2;
   begin
      if N <= 1 then
         return False;
      end if;

      while I * I <= N loop
         if N mod I = 0 then
            return False;
         end if;
         I := I + 1;
      end loop;

      return True;
   end Is_Prime;

   function GCD (A, B : Long_Long_Integer) return Long_Long_Integer is
      AA : Long_Long_Integer := A;
      BB : Long_Long_Integer := B;
      T  : Long_Long_Integer;
   begin
      while BB /= 0 loop
         T  := BB;
         BB := AA mod BB;
         AA := T;
      end loop;
      return AA;
   end GCD;

   function LCM (A, B : Long_Long_Integer) return Long_Long_Integer is
   begin
      return (A / GCD (A, B)) * B;
   end LCM;

   function Mul_Mod (A, B, M : Long_Long_Integer) return Long_Long_Integer is
   begin
      return ((A mod M) * (B mod M)) mod M;
   end Mul_Mod;

   function Mod_Pow (Base, Exp, M : Long_Long_Integer) return Long_Long_Integer is
      Result_V : Long_Long_Integer := 1 mod M;
      Base_V   : Long_Long_Integer := Base mod M;
      Exp_V    : Long_Long_Integer := Exp;
   begin
      while Exp_V > 0 loop
         if Exp_V mod 2 = 1 then
            Result_V := Mul_Mod (Result_V, Base_V, M);
         end if;
         Base_V := Mul_Mod (Base_V, Base_V, M);
         Exp_V  := Exp_V / 2;
      end loop;
      return Result_V;
   end Mod_Pow;

   function Mod_Inverse (A, M : Long_Long_Integer) return Long_Long_Integer is
      T     : Long_Long_Integer := 0;
      New_T : Long_Long_Integer := 1;
      R     : Long_Long_Integer := M;
      New_R : Long_Long_Integer := A mod M;
      Q     : Long_Long_Integer;
      Tmp   : Long_Long_Integer;
   begin
      while New_R /= 0 loop
         Q := R / New_R;

         Tmp   := New_T;
         New_T := T - Q * New_T;
         T     := Tmp;

         Tmp   := New_R;
         New_R := R - Q * New_R;
         R     := Tmp;
      end loop;

      if R /= 1 then
         raise Constraint_Error with "No modular inverse";
      end if;

      if T < 0 then
         T := T + M;
      end if;

      return T;
   end Mod_Inverse;

   function Random_In_Range (Low, High : Long_Long_Integer) return Long_Long_Integer is
      package RNG renames Ada.Numerics.Float_Random;
      Gen  : RNG.Generator;
      Span : constant Long_Long_Integer := High - Low + 1;
      R    : Long_Float;
      Raw  : Long_Long_Integer;
   begin
      RNG.Reset (Gen);
      R := Long_Float (RNG.Random (Gen));
      Raw := Low + Long_Long_Integer (R * Long_Float (Span));
      if Raw > High then
         return High;
      end if;
      return Raw;
   end Random_In_Range;

   function Power (Self : Instance; Base : Rings.Ring; Exp : Long_Long_Integer) return Rings.Ring is
      Value : constant Long_Long_Integer := Rings.To_Integer (Base);
   begin
      return Rings.From_Integer (Mod_Pow (Value, Exp, Self.N));
   end Power;

   function Create (P, Q : Long_Long_Integer) return Instance is
      N_Val      : Long_Long_Integer;
      Lambda_Val : Long_Long_Integer;
      E_Val      : Long_Long_Integer;
      D_Val      : Long_Long_Integer;
   begin
      if not Is_Prime (P) or else not Is_Prime (Q) then
         raise Constraint_Error with "P and Q must be prime";
      end if;

      N_Val := P * Q;
      if Rings.Modulus /= N_Val then
         raise Constraint_Error with "Ring modulus must match p * q";
      end if;

      Lambda_Val := LCM (P - 1, Q - 1);
      E_Val := Random_In_Range (2, Lambda_Val - 1);
      while GCD (E_Val, Lambda_Val) /= 1 loop
         E_Val := Random_In_Range (2, Lambda_Val - 1);
      end loop;

      D_Val := Mod_Inverse (E_Val, Lambda_Val);

      return (
         Private_Key => D_Val,
         Public_Key  => E_Val,
         N           => N_Val
      );
   end Create;

   function Get_Modulo (Self : Instance) return Long_Long_Integer is
   begin
      return Self.N;
   end Get_Modulo;

   function Get_Public_Key (Self : Instance) return Rings.Ring is
   begin
      return Rings.From_Integer (Self.Public_Key);
   end Get_Public_Key;

   function Encrypt (Self : Instance; M : Rings.Ring) return Rings.Ring is
   begin
      return Power (Self, M, Self.Public_Key);
   end Encrypt;

   function Decrypt (Self : Instance; S : Rings.Ring) return Rings.Ring is
   begin
      return Power (Self, S, Self.Private_Key);
   end Decrypt;

end RSA;
