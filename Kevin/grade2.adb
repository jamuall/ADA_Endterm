with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Numerics.Float_Random;

procedure Grade2 is
   
   protected Printer is
      procedure Print(S: String := "");
   end Printer;
   
   protected body Printer is
      procedure Print(S: String := "") is
      begin
         Put_Line(S);
      end Print;
   end Printer;
   
   task Door is
      entry Open;
      entry Close;
   end Door;
   
   task body Door is
      IsOpen: Boolean := False;
   begin
      loop
         select 
            when(not IsOpen) => accept Open  do
                  IsOpen := True;
                  Printer.Print("Door was opened");
               end Open;
         or
            when IsOpen => accept Close  do
                  IsOpen := False;
                  Printer.Print("Door was closed");
               end Close;
         or
            terminate;
         end select;
      end loop;
   end Door;
   
   task Burglar;
   
   task body Burglar is
   begin
      delay 1.0;
      Door.Open;
      delay 3.0;
      Door.Close;
   end Burglar;
   

begin
   --  Insert code here.
   null;
end Grade2;
