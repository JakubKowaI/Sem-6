with Ring_Mod_N;
with DH_Setup;

generic
   with package Rings is new Ring_Mod_N (<>);
   with package Dhs is new DH_Setup (Rings);
package Users is

   type Instance is private;

   function Create (D : access constant Dhs.Instance) return Instance;
   function Get_Public_Key (Self : Instance) return Rings.Ring;
   procedure Set_Key (Self : in out Instance; A : Rings.Ring);
   function Encrypt (Self : Instance; M : Rings.Ring) return Rings.Ring;
   function Decrypt (Self : Instance; C : Rings.Ring) return Rings.Ring;
   function Get_Shared_Key (Self : Instance) return Rings.Ring;

private
   type Instance is record
      My_Secret  : Long_Long_Integer;
      Shared_Key : Rings.Ring;
      Has_Key    : Boolean;
      Setup      : access constant Dhs.Instance;
   end record;
end Users;
