with Ada.Text_IO; use Ada.Text_IO;

with Ring_Mod_N;
with DH_Setup;
with Users;
with RSA;

procedure Test is
   package Ring_RSA is new Ring_Mod_N (10007 * 10009);
   package Ring_DH is new Ring_Mod_N (10007);
   use type Ring_DH.Ring;

   package RSA_Impl is new RSA (Ring_RSA);
   package DH_Impl is new DH_Setup (Ring_DH);
   package User_Impl is new Users (Ring_DH, DH_Impl);

   Rsa_Obj : RSA_Impl.Instance := RSA_Impl.Create (10007, 10009);

   M         : Ring_RSA.Ring := Ring_RSA.From_Integer (21152115);
   S         : Ring_RSA.Ring := RSA_Impl.Encrypt (Rsa_Obj, M);
   Decrypted : Ring_RSA.Ring := RSA_Impl.Decrypt (Rsa_Obj, S);

   Dh_Obj : aliased DH_Impl.Instance := DH_Impl.Create (10007);
   Alice  : User_Impl.Instance := User_Impl.Create (Dh_Obj'Access);
   Bob    : User_Impl.Instance := User_Impl.Create (Dh_Obj'Access);

   A_Pub : Ring_DH.Ring := User_Impl.Get_Public_Key (Alice);
   B_Pub : Ring_DH.Ring := User_Impl.Get_Public_Key (Bob);

   Ka : Ring_DH.Ring;
   Kb : Ring_DH.Ring;
   Mm : Ring_DH.Ring := Ring_DH.From_Integer (2115);
   C  : Ring_DH.Ring;
   D  : Ring_DH.Ring;
begin
   Ring_RSA.Put (Decrypted);
   New_Line;

   User_Impl.Set_Key (Alice, B_Pub);
   User_Impl.Set_Key (Bob, A_Pub);

   Ka := User_Impl.Get_Shared_Key (Alice);
   Kb := User_Impl.Get_Shared_Key (Bob);

   C := User_Impl.Encrypt (Alice, Mm);
   D := User_Impl.Decrypt (Bob, C);

   Put ("ka=");
   Ring_DH.Put (Ka);
   Put (" kb=");
   Ring_DH.Put (Kb);
   Put (" m=");
   Ring_DH.Put (Mm);
   Put (" d=");
   Ring_DH.Put (D);
   New_Line;

   if not (Ka = Kb and then Mm = D) then
      raise Program_Error with "DH test failed";
   end if;
end Test;
