with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Calendar;
use Ada.Calendar;

with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

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

   protected Randomizer is
      procedure Init; -- why can't this be an entry??

      -- we must use entries here because we want to execute
      -- only after initialization
      entry RandInt(minVal, maxVal : Integer; output : out Integer);
      entry RandFloat(minVal, maxVal : Float; output : out Float);

   private
      MyGenerator : Generator;
      initialized : Boolean := False;
   end Randomizer;

   protected body Randomizer is
      procedure Init is
      begin
         Reset(MyGenerator);
         initialized := True;
      end Init;

      entry RandInt(minVal, maxVal : Integer; output : out Integer) when initialized is
      begin
         output := Integer( Float(maxVal - minVal) * Random(MyGenerator) + Float(minVal) );
      end RandInt;

      entry RandFloat(minVal, maxVal : Float; output : out Float) when initialized is
      begin
         output := (maxVal - minVal) * Random(MyGenerator) + minVal;
      end RandFloat;

   end Randomizer;



   protected type Train is
      entry Board;

      function GetTouristCount return Natural;
   private
      tourist_aboard : Natural := 0;
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

   task type Tourist;
   task body Tourist is
      trial : Natural := 0;
      hasBoarded : Boolean := False;

      number_of_transfers : Integer;
      trainToBoard : Integer;

      arrivalTime : Float;
   begin

      Randomizer.RandInt(1,3, number_of_transfers);

      for I in 1..number_of_transfers loop

         Randomizer.RandFloat(1.0,2.0, arrivalTime);

         delay Duration(arrivalTime);

         trial := 0;
         hasBoarded := False;
         Randomizer.RandInt(1,3, trainToBoard);

         loop
            exit when trial = 3 or hasBoarded;

            select
               --trains(trainID).Board;
               trains(trainToBoard).Board;
            or
               delay 1.0;
               trial := trial + 1;
            end select;

         end loop;

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

         select
            accept Stop do
               shouldStop := True;
            end Stop;
         else
            null;
         end select;

         delay 2.0;

         for I in trains'range loop
            Printer.Print("Train"&I'img&" has"&trains(I).GetTouristCount'img);
         end loop;

      end loop;

   end StationChief;

begin
   Randomizer.Init;

   for I in 1..20 loop
      useless_tourist_variable := new Tourist;
   end loop;

   delay 5.0;
   StationChief.Stop;
end Main;
