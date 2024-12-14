with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Calendar;
use Ada.Calendar;

procedure Main is
   protected Printer is
      procedure Print(S : String);
   end Printer;

   protected body Printer is
      procedure Print(S : String) is
      begin
         Put_Line(S);
      end Print;
   end Printer;


   protected type Train is
      entry Board;

      function GetTouristCount return Natural;
   private
      tourist_aboard : Natural := 0;
      -- why clock - 5 sec, to let tourist aboard from the very start.
      -- if it was just clock, the tourist can only aboard after 1.5s of the program start
      previous_aboard_time : Ada.Calendar.Time := Ada.Calendar.Clock - 5.0;
   end Train;

   protected body Train is
      entry Board when tourist_aboard < 7 and Ada.Calendar.Clock - previous_aboard_time > 1.5 is
      begin
         tourist_aboard := tourist_aboard + 1;
         previous_aboard_time := Ada.Calendar.Clock;
      end Board;

      function GetTouristCount return Natural is
      begin
         return tourist_aboard;
      end GetTouristCount;
   end Train;

   type TrainArray is array(Positive range 1..3) of Train;
   trains : TrainArray;

   task type Tourist(trainID : Positive);
   task body Tourist is
      trial : Natural := 0;
      hasBoarded : Boolean := False;
   begin

      loop
         exit when trial = 3 or hasBoarded;

         select
            trains(trainID).Board;
            hasBoarded := True;
         or
            delay 1.0;
            trial := trial + 1;
         end select;

      end loop;


   end Tourist;

   type TouristPtr is access Tourist;
   useless_tourist_variable : TouristPtr;

   task StationChief is
      entry Stop;
   end StationChief;

   task body StationChief is
      shouldStop : Boolean := false;
   begin
      loop
         exit when shouldStop;

         delay 2.0;

         for I in trains'range loop
            Printer.Print("Train"&I'img&" has"&trains(I).GetTouristCount'img);
         end loop;

         select
            accept Stop do
               shouldStop := True;
            end Stop;
         else
            null;
         end select;


      end loop;

   end StationChief;

begin

   for I in 1..20 loop
      -- Even though this variable is re-assigned every time,
      -- the previous value which is a tourist task,
      -- doesn't get overwritten. It is still running.

      -- It's purpose is just to act as a temp variable for dynamic creation of tourists
      useless_tourist_variable := new Tourist(I mod 3 + 1);
   end loop;

   delay 5.0;
   StationChief.Stop;
end Main;
