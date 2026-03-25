with Ada.Text_IO;
with Interfaces;
with JP_Ada;
with Ada_Wrappers;

procedure Test_Ada is
   use Ada.Text_IO;
   use type Interfaces.Unsigned_8;
   subtype U64 is Interfaces.Unsigned_64;
   subtype I64 is Interfaces.Integer_64;

   procedure Print_Dio (Name : String; R : JP_Ada.Dio_Result) is
   begin
      if R.Bool_Wyn = 0 then
         Put_Line (Name & ": brak rozwiazania");
      else
         Put_Line (Name & ": x=" & I64'Image (R.X) & " y=" & I64'Image (R.Y));
      end if;
   end Print_Dio;
begin
   Put_Line ("=== Test Ada (zad. 5) ===");

   Put_Line ("[Ada] gcd=" & U64'Image (JP_Ada.Gcd (84, 30)));
   Put_Line ("[Ada] spd=" & U64'Image (JP_Ada.Smallest_Prime_Divisor (91)));
   Put_Line ("[Ada] phi=" & U64'Image (JP_Ada.Euler_Totient (36)));
   Print_Dio ("[Ada] dio", JP_Ada.Solve_Diophantine (7, 5, 9));

   Put_Line ("[C wrapper] gcd=" & U64'Image (Ada_Wrappers.Wrap_C_Gcd (84, 30)));
   Put_Line ("[C wrapper] spd=" & U64'Image (Ada_Wrappers.Wrap_C_Smallest_Prime_Divisor (91)));
   Put_Line ("[C wrapper] phi=" & U64'Image (Ada_Wrappers.Wrap_C_Euler_Totient (36)));
   Print_Dio ("[C wrapper] dio", Ada_Wrappers.Wrap_C_Solve_Diophantine (7, 5, 9));

   Put_Line ("[Rust wrapper] gcd=" & U64'Image (Ada_Wrappers.Wrap_Rust_Gcd (84, 30)));
   Put_Line ("[Rust wrapper] spd=" & U64'Image (Ada_Wrappers.Wrap_Rust_Smallest_Prime_Divisor (91)));
   Put_Line ("[Rust wrapper] phi=" & U64'Image (Ada_Wrappers.Wrap_Rust_Euler_Totient (36)));
   Print_Dio ("[Rust wrapper] dio", Ada_Wrappers.Wrap_Rust_Solve_Diophantine (7, 5, 9));
end Test_Ada;