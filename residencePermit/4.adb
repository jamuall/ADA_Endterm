with Ada.Numerics.Float_Random, Ada.Text_IO;
use Ada.Numerics.Float_Random, Ada.Text_IO;

with Ada.Numerics.Discrete_Random;

procedure Main is

   RandFloat : Generator;

   type Priority is new Integer range 0..2;
   package RandomPriorityPackage is new Ada.Numerics.Discrete_Random(Priority);
   RandPriority : RandomPriorityPackage.Generator;


   protected Printer is
      procedure Print(S: String);

   end Printer;

   protected body Printer is
      procedure Print(S: String) is
      begin
         Put_Line(S);
      end Print;

   end Printer;


   type StringPtr is access String;
   task type Freshman(id : StringPtr);

   task type Immigration is
      entry IssueRP;
   end Immigration;

   type ImmigrationPtr is access Immigration;
   type OfficeArray is array(Positive range 1..3) of ImmigrationPtr;
   immigrationOffices : OfficeArray;

   task body Immigration is
      waitTime : Float;
   begin
      -- If needed within a range,
      -- waitTime := (maxTime - minTime) * Random(RandFloat) + minTime;
      waitTime := Random(RandFloat);
      delay Duration(waitTime);

      loop
         select
            accept IssueRP  do
               delay 1.0;
               --  Printer.Print("Immigration: freshman gets his residence");
            end IssueRP;
         or
            terminate;
         end select;
      end loop;

   end Immigration;


   task body Freshman is
      priorityValue : Priority;
      officeIndex : Positive;
   begin

      RandomPriorityPackage.Reset(RandPriority);
      priorityValue := RandomPriorityPackage.Random(RandPriority);


      officeIndex := Integer( Float(3 - 1) * Random(RandFloat) ) + 1;

      loop
         exit when priorityValue = 0;

         Printer.Print(id.all&" has priority "&priorityValue'img);

         select
            immigrationOffices(officeIndex).IssueRP;
            Printer.Print(id.all&" got residence permit from Office"&officeIndex'img);
            exit;
         or
            delay Duration( Random(RandFloat) );

            if priorityValue = 2 then
               officeIndex := Integer( Float(3 - 1) * Random(RandFloat) ) + 1;
               Printer.Print(id.all&" will try again later in Office"&officeIndex'img);
            else
               Printer.Print(id.all&" couldn't get the residence from Office"&officeIndex'img&" going home");
            end if;
         end select;

         priorityValue := priorityValue - 1;

      end loop;

   end Freshman;

   type FreshmanPtr is access Freshman;
   type StudentArray is array(Positive range 1..42) of FreshmanPtr;
   students : StudentArray;



   id : StringPtr;
begin
   for I in 1..3 loop
      immigrationOffices(I) := new Immigration;
      delay 0.5;
   end loop;


   for I in 1..42 loop
      id := new String'(I'img);
      students(I) := new Freshman(id);
      delay 0.5;
   end loop;

end Main;
