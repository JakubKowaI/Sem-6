with Ada.Long_Long_Integer_Text_IO;

package body Ring_Mod_N is

   function Normalize (X : Long_Long_Integer) return Long_Long_Integer is
      Mod_N : constant Long_Long_Integer := Long_Long_Integer (N);
   begin
      return ((X mod Mod_N) + Mod_N) mod Mod_N;
   end Normalize;

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

   function Inverse (B : Ring) return Ring is
      T     : Long_Long_Integer := 0;
      New_T : Long_Long_Integer := 1;
      R     : Long_Long_Integer := Long_Long_Integer (N);
      New_R : Long_Long_Integer := Normalize (B.Val);
      Q     : Long_Long_Integer;
      Tmp   : Long_Long_Integer;
      Out_V : Ring;
   begin
      if New_R = 0 or else GCD (New_R, Long_Long_Integer (N)) /= 1 then
         raise Constraint_Error with "No inverse in ring";
      end if;

      while New_R /= 0 loop
         Q := R / New_R;

         Tmp   := New_T;
         New_T := T - Q * New_T;
         T     := Tmp;

         Tmp   := New_R;
         New_R := R - Q * New_R;
         R     := Tmp;
      end loop;

      Out_V.Val := Normalize (T);
      return Out_V;
   end Inverse;

   function "+" (A, B : Ring) return Ring is
      R : Ring;
   begin
      R.Val := Normalize (A.Val + B.Val);
      return R;
   end "+";

   function "-" (A, B : Ring) return Ring is
      R : Ring;
   begin
      R.Val := Normalize (A.Val - B.Val);
      return R;
   end "-";

   function "*" (A, B : Ring) return Ring is
      R : Ring;
   begin
      R.Val := Normalize (A.Val * B.Val);
      return R;
   end "*";

   function "/" (A, B : Ring) return Ring is
   begin
      return A * Inverse (B);
   end "/";

   function "=" (A, B : Ring) return Boolean is
   begin
      return A.Val = B.Val;
   end "=";

   function "<=" (A, B : Ring) return Boolean is
   begin
      return A.Val <= B.Val;
   end "<=";

   function ">=" (A, B : Ring) return Boolean is
   begin
      return A.Val >= B.Val;
   end ">=";

   function "<" (A, B : Ring) return Boolean is
   begin
      return A.Val < B.Val;
   end "<";

   function ">" (A, B : Ring) return Boolean is
   begin
      return A.Val > B.Val;
   end ">";

   function To_Integer (A : Ring) return Long_Long_Integer is
   begin
      return A.Val;
   end To_Integer;

   function From_Integer (X : Long_Long_Integer) return Ring is
      R : Ring;
   begin
      R.Val := Normalize (X);
      return R;
   end From_Integer;

   function Modulus return Long_Long_Integer is
   begin
      return Long_Long_Integer (N);
   end Modulus;

   procedure Put (Item : Ring) is
   begin
      Ada.Long_Long_Integer_Text_IO.Put (Item.Val, Width => 0);
   end Put;

end Ring_Mod_N;
