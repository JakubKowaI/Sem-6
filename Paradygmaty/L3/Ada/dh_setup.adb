with Ada.Numerics.Float_Random;

package body DH_Setup is

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

   function Is_Generator (X, P : Long_Long_Integer) return Boolean is
      Phi : constant Long_Long_Integer := P - 1;
      V   : Long_Long_Integer := Phi;
      D   : Long_Long_Integer := 2;
   begin
      if X <= 1 or else X >= P then
         return False;
      end if;

      while D * D <= V loop
         if V mod D = 0 then
            if Mod_Pow (X, Phi / D, P) = 1 then
               return False;
            end if;
            while V mod D = 0 loop
               V := V / D;
            end loop;
         end if;
         D := D + 1;
      end loop;

      if V > 1 and then Mod_Pow (X, Phi / V, P) = 1 then
         return False;
      end if;

      return True;
   end Is_Generator;

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

   function Create (PP : Long_Long_Integer) return Instance is
      Temp : Long_Long_Integer;
      Obj  : Instance;
   begin
      if PP < 5 or else not Is_Prime (PP) then
         raise Constraint_Error with "Modulo p must be prime and >= 5";
      end if;

      if Rings.Modulus /= PP then
         raise Constraint_Error with "Ring modulus must match DH modulo";
      end if;

      Temp := Random_In_Range (2, PP - 2);
      while not Is_Generator (Temp, PP) loop
         Temp := Random_In_Range (2, PP - 2);
      end loop;

      Obj.P := PP;
      Obj.G := Rings.From_Integer (Temp);
      return Obj;
   end Create;

   function Get_Modulo (Self : Instance) return Long_Long_Integer is
   begin
      return Self.P;
   end Get_Modulo;

   function Get_Generator (Self : Instance) return Rings.Ring is
   begin
      return Self.G;
   end Get_Generator;

   function Power (Self : Instance; A : Rings.Ring; B : Long_Long_Integer) return Rings.Ring is
      Value : constant Long_Long_Integer := Rings.To_Integer (A);
   begin
      return Rings.From_Integer (Mod_Pow (Value, B, Self.P));
   end Power;

end DH_Setup;
