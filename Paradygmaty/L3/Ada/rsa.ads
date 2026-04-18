with Ring_Mod_N;

generic
   with package Rings is new Ring_Mod_N (<>);
package RSA is

   type Instance is private;

   function Create (P, Q : Long_Long_Integer) return Instance;
   function Get_Modulo (Self : Instance) return Long_Long_Integer;
   function Get_Public_Key (Self : Instance) return Rings.Ring;
   function Encrypt (Self : Instance; M : Rings.Ring) return Rings.Ring;
   function Decrypt (Self : Instance; S : Rings.Ring) return Rings.Ring;

private
   type Instance is record
      Private_Key : Long_Long_Integer;
      Public_Key  : Long_Long_Integer;
      N           : Long_Long_Integer;
   end record;
end RSA;
