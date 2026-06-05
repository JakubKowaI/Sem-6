with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Calendar; use Ada.Calendar;

procedure Main is

   function Img(N : Natural) return String is
      S : constant String := Natural'Image(N);
   begin
      if S(S'First) = ' ' then
         return S(S'First + 1 .. S'Last);
      end if;
      return S;
   end Img;

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

   type Count_Array is array (Positive range <>) of Natural;
   type Count_Array_Access is access Count_Array;

   protected type Stats_Type is
      procedure Init(Total : Positive);
      procedure Inc(Id : Positive);
      function Get(Id : Positive) return Natural;
   private
      Counts : Count_Array_Access;
   end Stats_Type;

   protected body Stats_Type is
      procedure Init(Total : Positive) is
      begin
         Counts := new Count_Array(1 .. Total);
         for I in Counts'Range loop
            Counts(I) := 0;
         end loop;
      end Init;

      procedure Inc(Id : Positive) is
      begin
         Counts(Id) := Counts(Id) + 1;
      end Inc;

      function Get(Id : Positive) return Natural is
      begin
         return Counts(Id);
      end Get;
   end Stats_Type;

   Stats : Stats_Type;

   task type Philosopher_Type(Id : Positive; Hunger : Natural);

   task body Philosopher_Type is
   begin
      for I in 1 .. Hunger loop
         Waiter.Request;
         Stats.Inc(Id);
         delay 0.1;
         Waiter.Release;
      end loop;
      Waiter.Thank_You;
   end Philosopher_Type;

   type Philosopher_Access is access all Philosopher_Type;
   PhArray : access Philosopher_Access := null;

   N : Positive := 5;
   Hunger : Natural := 3;
begin
   if Argument_Count >= 1 then
      N := Positive'Value(Argument(1));
   end if;
   if Argument_Count >= 2 then
      Hunger := Natural'Value(Argument(2));
   end if;

   Waiter.Init(N);
   Stats.Init(N);

   declare
      type Ph_Arr_Type is array (Positive range <>) of Philosopher_Access;
      Phs : Ph_Arr_Type(1 .. N);
   begin
      for I in Phs'Range loop
         Phs(I) := new Philosopher_Type(Positive(I), Hunger);
      end loop;
      while not Waiter.Finished loop
         delay 0.1;
      end loop;

      for I in 1 .. N loop
         Put_Line("Filozof " & Img(Natural(I)));
         Put_Line(Img(Stats.Get(I)));
      end loop;
   end;
end Main;
