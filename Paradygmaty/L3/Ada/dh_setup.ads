with Ring_Mod_N;

generic
   with package Rings is new Ring_Mod_N (<>);
package DH_Setup is

   type Instance is private;

   function Create (PP : Long_Long_Integer) return Instance;
   function Get_Modulo (Self : Instance) return Long_Long_Integer;
   function Get_Generator (Self : Instance) return Rings.Ring;
   function Power (Self : Instance; A : Rings.Ring; B : Long_Long_Integer) return Rings.Ring;

private
   type Instance is record
      P : Long_Long_Integer;
      G : Rings.Ring;
   end record;
end DH_Setup;
