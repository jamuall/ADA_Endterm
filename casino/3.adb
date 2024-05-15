with Ada.Text_IO,Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random, Ada.Real_Time;
use Ada.Text_IO,Ada.Numerics.Float_Random, Ada.Real_Time;


-- Time
-- Time_span

procedure three is
   type PStr is access String;

   package randint is new Ada.Numerics.Discrete_Random(Natural);

   iR : randint.Generator;

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
         return Duration(Random(G));
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
      capacity : Natural := 0;
      open : Boolean := True;
   begin
      delay MyG.Give;
      Printer.Print("Casion: Opened");
      while open loop
         select
            when capacity < 5 =>
            accept Enter do
               Printer.Print("Casino: a player got in");
               capacity := capacity + 1;
            end Enter;
         or
             delay until Clock + Seconds(15);
            open := False;
         end select;
      end loop;
      Printer.Print("Casino: finished");
      exception
      when Tasking_Error => Printer.Print("Casion f");
      when others => Printer.Print("casion ff");
   end Casino; 

   task type Player(name : PStr);
   task body Player is
      trial : Natural := 0;
      played : Boolean := False;
      decide : Boolean := True;
      point : Natural := 0;
   begin
      
      delay MyG.Give;
      Printer.Print("Player"& name.all &" arrives");
      while not played and trial < 2 and decide loop 
         select
               Casino.Enter;
               played := True;
               Printer.Print("Player" & name.all &": got in");
               
               point := ( randint.Random(iR) rem 1001 );
               Printer.Print(name.all & ", he got points:" & point'Image);
         or
            delay 1.0;
            trial := trial + 1;
            Printer.Print("player:" & name.all &" try again");
            if MyG.Give < 0.5 then
               decide := True;
            else 
               decide := False;
            end if;
         end select;
      end loop;
      if not played then
         Printer.Print(name.all & " did not play");
      else
         Printer.Print("player:"&name.all &" finished");
      end if;
   exception
      when Tasking_Error => Printer.Print("Player f");
      when others => Printer.Print("player ff");
   end Player;

   type PPlayer is access Player;
   Players : array(1..10) of PPlayer;
   
begin
   MyG.Init;
   randint.Reset(iR);
   Printer.Print("Game started");
   for I in 1..10 loop
      Players(I) := new Player(new String'(I'Image));
      delay 0.5;
   end loop;
end three;
