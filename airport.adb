with Ada.Text_IO, Ada.Integer_Text_IO, Tools;
use Ada.Text_IO, Ada.Integer_Text_IO, Tools;

procedure Airport is

   type TAircraft is (A320, A330, A340, A350, A380);
   for TAircraft use (1, 2, 3, 4, 5);

   Diversion : exception;
   Late : exception;

   package AircraftR is new Tools.Random_Generator(TAircraft);

   Val: TAircraft;
   Num : Integer;

   protected type Airport_Protected is
      procedure Init(Max: Natural);
      entry Arrival;
      entry Departure;

   private
      NumAircraft: Natural := 0;
      MaxAircraft: Natural := 0;
   end Airport_Protected;

   protected body Airport_Protected is
      procedure Init(Max: Natural) is
      begin
         MaxAircraft:= Max;
      end Init;

      entry Arrival when NumAircraft < MaxAircraft is
      begin
         NumAircraft := NumAircraft + 1;
         Print.Puts("Plane arrived. Number of Aircraft in Airport: " & NumAircraft'Image);
      end Arrival;

      entry Departure when NumAircraft > 0 is
      begin
         NumAircraft := NumAircraft - 1;
         Print.Puts("Plane departed. Number of Aircraft in Airport: " & NumAircraft'Image);
      end Departure;
   end Airport_Protected;

   Airport: Airport_Protected;
   
   task Fuel is
      entry Refuel(FlightNum: Natural; Aircraft_Type: TAircraft);
   end Fuel;

   task body Fuel is
   begin
      loop
         select
            accept Refuel(FlightNum: Natural; Aircraft_Type: TAircraft) do
               Print.Puts("Refuel => Flight number: " & FlightNum'Image & ", Aircraft type: " & Aircraft_Type'Image);
               delay Duration(TAircraft'Enum_Rep(Aircraft_Type));
            end Refuel;
         or
            delay 30.0;
            exit;
         end select;
      end loop;
   end Fuel;
   
   task type Runway(Name: access String) is
      entry Takeoff(FlightNum: Natural; Aircraft_Type: TAircraft);
      entry Land(FlightNum: Natural; Aircraft_Type: TAircraft);
   end Runway;

   R1 : Runway(new String'("12R/30L"));
   R2 : Runway(new String'("12L/30R"));

   task body Runway is 
      begin
      loop
         select
            accept Takeoff(FlightNum: Natural; Aircraft_Type: TAircraft) do
               Airport.Departure;
               Print.Puts("Takeoff => Flight number: " & FlightNum'Image &
                            ", Aircraft type: " & Aircraft_Type'Image & ", Runway: " & Name.all);
               delay duration(TAircraft'Enum_Rep(Aircraft_Type)) / 5.0 ;
            end Takeoff;
         or
           accept Land(FlightNum: Natural; Aircraft_Type: TAircraft) do
               Airport.Arrival;
               Print.Puts("Land => Flight number: " & FlightNum'Image &
                            ", Aircraft type: " & Aircraft_Type'Image & ", Runway: " & Name.all);
               delay 0.5;
            end Land;
         or
            delay 30.0;
            exit;
         end select;
      end loop;
   end Runway;

   task type Flight is
     entry Init(Num: Natural; A: TAircraft);
   end Flight;

   F1: Flight;

   task body Flight is
      FlightNum: Natural; 
      Aircraft_Type: TAircraft;
      Circles: Natural := 0; -- for landing
      Attempts: Natural := 0; -- for take off                       
      
   begin
      accept Init(Num: Natural; A: TAircraft) do
         FlightNum := Num;
         Aircraft_Type := A;
      end Init;
      loop
         select
            R1.Land(FlightNum, Aircraft_Type);
            Print.Puts("Landing flight => Flight number: " 
                       & FlightNum'Image & ", Aircraft Type: " 
                       & Aircraft_Type'Image & " on Runway R1.");
            
            exit;
         or
            delay 0.2;
            Circles := Circles + 1;
            if Circles >= 3 then
               raise Diversion;
            end if;
            Print.Puts("Circling => Flight number: " & FlightNum'Image 
                       & " has circled " & Circles'Image & " times.");
         end select;
      end loop;

      Fuel.Refuel(FlightNum, Aircraft_Type);
      delay duration(TAircraft'Enum_Rep(Aircraft_Type)) * 2.0;
            
      loop
         select 
            R2.Takeoff(FlightNum, Aircraft_Type);
            Print.Puts("Taking off flight => Flight number: " 
                       & FlightNum'Image & ", Aircraft Type: "
                       & Aircraft_Type'Image & " on Runway R2.");
            exit;
         or
            delay 0.2;
            Attempts := Attempts + 1;
            if Attempts >= 3 then
               raise Late;
            end if;
            Print.Puts("Waiting for takeoff => Flight number: " 
                         & FlightNum'Image & ", Aircraft Type: "
                         & Aircraft_Type'Image & " on Runway R2, attempt: " 
                       & Attempts'Image);
         end select;
      end loop;
   exception
      when Diversion =>
         Print.Puts("Diversion => Flight number: " & FlightNum'Image & ", Aircraft Type: " & Aircraft_Type'Image & " has been diverted after " & Circles'Image & " circles.");
      when Late => 
         Print.Puts("Delay for departion => Flight number: " & FlightNum'Image & ", Aircraft Type: " & Aircraft_Type'Image & " has been delayed after " & Attempts'Image & " attempts.");
      when others =>
         Print.Puts("Unexpected Issue => Flight number: " & FlightNum'Image & " encountered an unspecified problem.");
   end Flight;
   
   Flights : array(1..10) of Flight;

   --type PFlight is access Flight;
   --type Flights is array(1..10) of PFlight;
   --My_Flights: Flights;
   
begin
   Val := AircraftR.GetRandom;
   Num := Integer(TAircraft'Enum_Rep(Val));
   Print.Puts(Val'Image);
   Print.Puts(Num'Image);
   
   Put_Line(" ");
   Airport.Init(10);
   Airport.Arrival;
   Airport.Arrival;
   Airport.Departure;
   Airport.Departure;
   Put_Line(" ");

   Fuel.Refuel(101, A320);
   Fuel.Refuel(102, A350);

   Put_Line(" ");
   R2.Land(102, A350);
   R2.Takeoff(101, A320);

   Put_Line(" ");

   for I in Flights'Range loop
      Flights(I).Init(I, TAircraft'(AircraftR.GetRandom));
      delay 0.5; -- Delay between initializing each flight
   end loop;

   delay Duration(30.0);
   
end Airport;
