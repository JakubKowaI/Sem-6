with Ada.Numerics.Float_Random;

package body Users is
   use type Rings.Ring;

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

   function Create (D : access constant Dhs.Instance) return Instance is
      P : Long_Long_Integer;
   begin
      if D = null then
         raise Constraint_Error with "DH setup pointer cannot be null";
      end if;

      P := Dhs.Get_Modulo (D.all);
      if P <= 3 then
         raise Constraint_Error with "Invalid modulo p";
      end if;

      return (
         My_Secret  => Random_In_Range (2, P - 2),
         Shared_Key => Rings.From_Integer (1),
         Has_Key    => False,
         Setup      => D
      );
   end Create;

   function Get_Public_Key (Self : Instance) return Rings.Ring is
   begin
      return Dhs.Power (Self.Setup.all, Dhs.Get_Generator (Self.Setup.all), Self.My_Secret);
   end Get_Public_Key;

   procedure Set_Key (Self : in out Instance; A : Rings.Ring) is
   begin
      Self.Shared_Key := Dhs.Power (Self.Setup.all, A, Self.My_Secret);
      Self.Has_Key := True;
   end Set_Key;

   function Encrypt (Self : Instance; M : Rings.Ring) return Rings.Ring is
   begin
      if not Self.Has_Key then
         raise Constraint_Error with "Shared secret is not set";
      end if;
      return M * Self.Shared_Key;
   end Encrypt;

   function Decrypt (Self : Instance; C : Rings.Ring) return Rings.Ring is
   begin
      if not Self.Has_Key then
         raise Constraint_Error with "Shared secret is not set";
      end if;
      return C / Self.Shared_Key;
   end Decrypt;

   function Get_Shared_Key (Self : Instance) return Rings.Ring is
   begin
      if not Self.Has_Key then
         raise Constraint_Error with "Shared secret is not set";
      end if;
      return Self.Shared_Key;
   end Get_Shared_Key;

end Users;
