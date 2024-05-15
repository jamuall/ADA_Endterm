with Ada.Numerics.Float_Random, Ada.Text_IO;
use Ada.Numerics.Float_Random, Ada.Text_IO;

procedure Main is
   RandFloat : Generator;

   protected Printer is
      procedure Print(S: String);

   end Printer;

   protected body Printer is
      procedure Print(S: String) is
      begin
         Put_Line(S);
      end Print;

   end Printer;


   task Freshman;

   task Immigration is
      entry IssueRP;
   end Immigration;

   task body Immigration is
      waitTime : Float;
   begin
      -- If needed within a range, 
      -- waitTime := (maxTime - minTime) * Random(RandFloat) + minTime;
      waitTime := Random(RandFloat);
      delay Duration(waitTime);
      select
         accept IssueRP  do
            Printer.Print("Immigration: freshman gets his residence");
         end IssueRP;
      or
         terminate;
      end select;

   end Immigration;




   task body Freshman is
   begin
      select
         Immigration.IssueRP;
         Printer.Print("Freshman: got his residence");
      or
         delay 0.5;
         Printer.Print("Freshman: did not get residence");
      end select;
   end Freshman;

begin
   null;
end Main;
