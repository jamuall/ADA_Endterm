with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Numerics.Float_Random;

procedure Grade4 is
   
   --Protected Printer
   protected Printer is
      procedure Print(S: String := "");
   end Printer;
   
   protected body Printer is
      procedure Print(S: String := "") is
      begin
         Put_Line(S);
      end Print;
   end Printer;
   
   --Protected Safe_Random
   protected Safe_Random is
      procedure Init;
      function Generate return Float;
   private
      G: Generator;
   end Safe_Random;
   
   protected body Safe_Random is
      procedure Init is
      begin
         Reset(G);
      end Init;
      
      function Generate return Float is
      begin
         return Random(G) * (4.0 - 0.0) + 0.0;
      end Generate;
   end Safe_Random;
   
   --Door task
   task type Door(ID: Positive) is
      entry Open;
      entry Close;
   end Door;
   
   type PDoor is access Door;
   type DoorArray is array(1..5) of PDoor;
   
   --Task Burglar
   task Burglar is
      entry Hit;
   end Burglar;
   
   --Task Trap
   task type Trap;
   
   type PTrap is access Trap;
   
   --Protected House
   protected House is
      procedure Init;
      procedure Get_Door(D: out PDoor);
   private
      Doors: DoorArray;
   end House;
   
   --Task Body Door
   task body Door is
      IsOpen: Boolean := False;
      T: PTrap;
   begin
      loop
         select when(not IsOpen) => accept Open  do
                  IsOpen := True;
                  Printer.Print("Door was " & Positive'Image(ID) & " opened");
                  T := new Trap;
               end Open;
         or
            when IsOpen => accept Close  do
                  IsOpen := False;
                  Printer.Print("Door was " & Positive'Image(ID) & " closed");
               end Close;
         or
            terminate;
         end select;
      end loop;
   end Door;
   
   --Task Body Burglar
   task body Burglar is
      Door: PDoor;
   begin
      delay 1.0;
      House.Get_Door(Door);
      Door.Open;
      select
         accept Hit;
      or
         delay 3.0;
      end select;
      Door.Close;
   end Burglar;
   
   --Task Body Trap
   task body Trap is
      Rand_Num: Float;
   begin
      Rand_Num := Safe_Random.Generate;
      Printer.Print("Trap waiting for " & Float'Image(Rand_Num) & "seconds");
      delay Duration(Rand_Num);
      select
         Burglar.Hit;
         Printer.Print("Burglar was caught");
      or
         delay 0.1;
      end select;
   end Trap;
   
   --Protected House
   protected body House is
      procedure Init is
      begin
         for I in 1..5 loop
            Doors(I) := new Door(I);
         end loop;
      end Init;
      
      procedure Get_Door(D: out PDoor) is
         package Rand_Door is new Ada.Numerics.Discrete_Random(Positive);
         use Rand_Door;
         
         Rand_ID: Positive;
         G: Rand_Door.Generator;
      begin
         Rand_Door.Reset(G);
         Rand_ID := (Rand_Door.Random(G) mod 5) + 1;
         D:= Doors(Rand_ID);
      end Get_Door;
      
   end House;
         
         

begin
   House.Init;
   Safe_Random.Init;
end Grade4;
