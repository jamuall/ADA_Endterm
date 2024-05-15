with Ada.Text_IO,Ada.Numerics.Float_Random;
use Ada.Text_IO,Ada.Numerics.Float_Random;


-- Time
-- Time_span

procedure test is

   protected MyG is
      procedure Init;
      function Give return Duration;
   private
      G : Generator;
   end MyG;

   protected body MyG is 
      procedure Init is
      begin
         Reset(G);
      end;

      function Give return Duration is
      begin
         return Duration( Random(G) );
      end Give;
   end MyG;
   

   protected Printer is
      procedure Print(S : String := "");
   end Printer;

   protected body Printer is
      procedure Print(S : String := "") is
      begin
         Put_Line(S);
      end Print;

   end Printer;
   
   task Casino is
      entry Enter;
   end Casino;
   task body Casino is
   visited : Boolean := False;
   begin
      delay MyG.Give;
      Printer.Print("Casion: Opened");
      while not visited loop
         select
            accept Enter do
               Printer.Print("Casino: a player got in");
               visited := True;
            end Enter;
         or
              terminate;
         end select;
      end loop;
      Printer.Print("Casino: finished");
   end Casino; 

   task Player;
   task body Player is
      trial : Natural := 0;
      played : Boolean := False;
   begin
      delay MyG.Give;
      Printer.Print("Player arrives");
      while not played and trial < 3 loop 
         select
            Casino.Enter;
            played := True;
            Printer.Print("Player: got in");
         else
            trial := trial + 1;
            Printer.Print("player: try again");
         end select;
      end loop;
      if not played then
         Printer.Print("player: failed to enter");
      else
         Printer.Print("player: finished");
      end if;
   end Player;


   
   
begin
   MyG.Init;
   Printer.Print("Game started");
end test;
