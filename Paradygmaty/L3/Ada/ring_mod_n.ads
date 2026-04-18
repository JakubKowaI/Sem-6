with Ada.Text_IO;

generic
   N : Positive;
package Ring_Mod_N is

   type Ring is private;

   function "=" (A, B : Ring) return Boolean;
   function "<=" (A, B : Ring) return Boolean;
   function ">=" (A, B : Ring) return Boolean;
   function "<" (A, B : Ring) return Boolean;
   function ">" (A, B : Ring) return Boolean;

   function "+" (A, B : Ring) return Ring;
   function "-" (A, B : Ring) return Ring;
   function "*" (A, B : Ring) return Ring;
   function "/" (A, B : Ring) return Ring;

   function To_Integer (A : Ring) return Long_Long_Integer;
   function From_Integer (X : Long_Long_Integer) return Ring;
   function Modulus return Long_Long_Integer;

   procedure Put (Item : Ring);

private
   type Ring is record
      Val : Long_Long_Integer;
   end record;
end Ring_Mod_N;
