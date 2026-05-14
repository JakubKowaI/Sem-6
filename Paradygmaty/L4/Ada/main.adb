with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Calendar; use Ada.Calendar;

procedure Main is
   -- Simple Ada implementation of the dining philosophers with a central waiter (Kelner)

   protected type Waiter_Type is
      procedure Init(Total : Integer);
      entry Request;
      procedure Release;
      procedure Thank_You;
      function Finished return Boolean;
   private
      Forks : Integer := 0;
      TotalPhilos : Integer := 0;
      Eaten : Integer := 0;
   end Waiter_Type;

   protected body Waiter_Type is
      procedure Init(Total : Integer) is
      begin
         Forks := Total;
         TotalPhilos := Total;
         Eaten := 0;
      end Init;

      entry Request when Forks >= 2 is
      begin
         Forks := Forks - 2;
      end Request;

      procedure Release is
      begin
         Forks := Forks + 2;
      end Release;

      procedure Thank_You is
      begin
         Eaten := Eaten + 1;
      end Thank_You;

      function Finished return Boolean is
      begin
         return Eaten = TotalPhilos;
      end Finished;
   end Waiter_Type;

   Waiter : Waiter_Type;

   task type Philosopher_Type(Id : Integer; Hunger : Integer);

   task body Philosopher_Type is
      I : Integer;
   begin
      for I in 1 .. Hunger loop
         Waiter.Request;
         Put_Line("Filozof " & Integer'Image(Id) & " je.");
         delay 0.1; -- seconds
         Waiter.Release;
      end loop;
      Waiter.Thank_You;
   end Philosopher_Type;

   type Philosopher_Access is access all Philosopher_Type;
   PhArray : access Philosopher_Access := null;

   N : Integer := 5;
   Hunger : Integer := 3;
begin
   -- read args if provided
   if Argument_Count >= 1 then
      N := Integer'Value(Argument(1));
   end if;
   if Argument_Count >= 2 then
      Hunger := Integer'Value(Argument(2));
   end if;

   Waiter.Init(N);

   -- create dynamic array of philosopher tasks
   declare
      type Ph_Arr_Type is array (Positive range <>) of Philosopher_Access;
      Phs : Ph_Arr_Type(1 .. N);
   begin
      for I in Phs'Range loop
         Phs(I) := new Philosopher_Type(I, Hunger);
      end loop;

      -- wait until all philosophers finished
      while not Waiter.Finished loop
         delay 0.1;
      end loop;

      Put_Line("Wszyscy filozofowie zakonczone.");
   end;
end Main;
