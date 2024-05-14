with ADA.Text_IO, Ada.Numerics.Float_Random;
use ADA.Text_IO, Ada.Numerics.Float_Random;


procedure Main is
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
      function Generate return Duration;
   private
      G: Generator;
   end Safe_Random;
   
   protected body Safe_Random is
      procedure Init is
      begin
         Reset(G);
      end Init;
      
      function Generate return Duration is
      begin
         return Duration(Random(G));
      end Generate;
   end Safe_Random;
   
   -- player and casino task
   task Casino is
      entry Enter;
   end Casino;
   
   task body Casino is
      Rand_Time: Duration;
      Player_Entered : Boolean := False;
   begin
      Rand_Time := Safe_Random.Generate;
      delay Rand_Time;      
      Printer.Print("Casino: Opened");
      
      while not Player_Entered loop
         select
            accept Enter do
               Printer.Print("Casino: a player got in");
               Player_Entered := True;
               end Enter;
            or
               terminate;
            end select;            
         end loop;
         Printer.Print("Casino: finished");
   end Casino;
   
   
   task Player;
   
   task body Player is
      Rand_time: Duration;
      Retry_Count: Natural := 0;
      Played : Boolean := False;
   begin
      Rand_time:= Safe_Random.Generate;
      delay Rand_time;
      Printer.Print("player: arrived");
      while not Played and Retry_Count < 3 loop
         select
            Casino.Enter;
            Played := True;
            Printer.Print("Player: got in");
         else
            Retry_Count := Retry_Count + 1;
            Printer.Print("Player: try again");
         end select;
      end loop;
      if not played then
         Printer.Print("player: failed to enter");
      else
         Printer.Print("player: finished");
      end if;
   end Player;
                    
                 
begin
    Safe_Random.Init;
    Put_Line("Game started");
end Main;
