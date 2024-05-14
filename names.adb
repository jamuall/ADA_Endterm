with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Names is

   protected type Semaphore_Protected (Max : Natural; Initial : Natural) is
      entry Seize;
      entry Release;

   private
      Count    : Natural := Initial;
      MaxCount : Natural := Max;
   end Semaphore_Protected;

   protected body Semaphore_Protected is
      entry Seize when Count > 0 is
      begin
         Count := Count - 1;
      end Seize;

      entry Release when Count < MaxCount is
      begin
         Count := Count + 1;
      end Release;
   end Semaphore_Protected;

   Semaph : Semaphore_Protected (1, 1);

   task type Print is
      entry Init (S : in String := "");
   end Print;

   A, B : Print;

   task body Print is
      type PStr is access String;
      Name : PStr;
   begin
      accept Init (S : in String := "") do
         Name     := new String (1 .. S'Length);
         Name.all := S;
      end Init;

      for I in Positive'Range loop
         Semaph.Seize;
         Put_Line (Name.all);
         Semaph.Release;
      end loop;
   end Print;
begin

   A.Init ("John");
   B.Init ("Mary");

end Names;
