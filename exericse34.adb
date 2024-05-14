with ADA.Text_IO;
use ADA.Text_IO;

procedure Exericse34 is
   
   type Color is (Red, Yellow, Green);
   
   protected Lamp is
      procedure Change;
      function IsColor return Color;
   private
      Light: Color := Red;
   end Lamp;

   protected body Lamp is
      procedure Change is
         begin
         if Light = Green then
            Light := Red;
         else
            Light := Color'Succ(Light);
         end if;
         Put_Line(Color'Image(Light));
      end Change;

      function IsColor return Color is
      begin
         return Light;
      end IsColor;
   end Lamp;

   task Scheduler;

   task body Scheduler is
   begin
      Put_Line(Color'Image(Lamp.IsColor));
      for I in 1..3 loop
         Lamp.Change;
         delay 2.0;
         Lamp.Change;
         delay 1.5;
         Lamp.Change;
         delay 0.5;
      end loop;
   end Scheduler;



begin
   null;
end Exericse34;
