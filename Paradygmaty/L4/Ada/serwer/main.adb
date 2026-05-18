with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Main is
   function Arg_Positive(Index : Positive; Default : Positive) return Positive is
   begin
      if Ada.Command_Line.Argument_Count >= Index then
         return Positive'Value(Ada.Command_Line.Argument(Index));
      else
         return Default;
      end if;
   exception
      when others =>
         return Default;
   end Arg_Positive;

   function Img(N : Natural) return String is
      S : constant String := Natural'Image(N);
   begin
      if S(S'First) = ' ' then
         return S(S'First + 1 .. S'Last);
      end if;
      return S;
   end Img;

   Users_Num         : constant Positive := Arg_Positive(1, 5);
   Messages_Per_User : constant Positive := Arg_Positive(2, 5);

   task type Receiver_Task (Id : Natural) is
      entry Receive(From : Natural);
      entry Stop;
   end Receiver_Task;

   type Receiver_Access is access Receiver_Task;
   type Receiver_Array is array (Natural range <>) of Receiver_Access;
   type Receiver_Array_Access is access Receiver_Array;

   Receivers : Receiver_Array_Access;

   task type Server_Task is
      entry Receive(From : Natural; To : Natural);
      entry Done;
   end Server_Task;

   Server : access Server_Task;

   task type Sender_Task (Id : Natural);

   type Sender_Access is access Sender_Task;
   type Sender_Array is array (Natural range <>) of Sender_Access;
   type Sender_Array_Access is access Sender_Array;

   Senders : Sender_Array_Access;

   task body Receiver_Task is
   begin
      loop
         select
            accept Receive(From : Natural) do
               Put_Line("User " & Img(Id) & " otzymalem wiadomosc.");
            end Receive;
         or
            accept Stop;
            exit;
         end select;
      end loop;
   end Receiver_Task;

   task body Server_Task is
      Completed : Natural := 0;
   begin
      loop
         select
            accept Receive(From : Natural; To : Natural) do
               Put_Line("Serwer otrzymal message do " & Img(To));
               Put_Line("Serwer wysyla do " & Img(To));
               Receivers.all(To).Receive(From);
            end Receive;
         or
            accept Done do
               Completed := Completed + 1;
            end Done;
         end select;

         exit when Completed = Users_Num;
      end loop;

      for I in 0 .. Users_Num - 1 loop
         Receivers.all(I).Stop;
      end loop;

      Put_Line("Serwer skonczyl prace");
   end Server_Task;

   task body Sender_Task is
      package Rand is new Ada.Numerics.Discrete_Random(Natural);
      Gen  : Rand.Generator;
      Sent : Natural := 0;
   begin
      Rand.Reset(Gen, Integer(Id + 1));
      while Sent < Messages_Per_User loop
         declare
            Target : Natural := Rand.Random(Gen) mod Users_Num;
         begin
            Put_Line("Wysylam wiadomosc do " & Img(Target));
            Server.all.Receive(Id, Target);
            Sent := Sent + 1;
         end;
      end loop;
      Server.all.Done;
   end Sender_Task;

begin
   Receivers := new Receiver_Array(0 .. Users_Num - 1);
   for I in 0 .. Users_Num - 1 loop
      Receivers.all(I) := new Receiver_Task(I);
   end loop;

   Server := new Server_Task;

   Senders := new Sender_Array(0 .. Users_Num - 1);
   for I in 0 .. Users_Num - 1 loop
      Senders.all(I) := new Sender_Task(I);
   end loop;
end Main;
