with ADA.Text_IO, Ada.Numerics.Discrete_Random;
use ADA.Text_IO;

procedure Chicken is
   
   Gone: exception;
   Fly: exception;
   
   task Chicken is
      entry Feed;
      entry Play;
   end Chicken;
   
   task body Chicken is
      SeedInStomach: Natural := 4;
      SeedDelay: Duration := 1.0;
   begin
      loop
         if SeedInStomach = 0 then
            raise Gone;
         else if SeedInStomach = 30 then
            raise Fly;
         else
            select
               accept Feed do
                  SeedInStomach := SeedInStomach + 3;
                  Put_Line("Chicken: I am getting fed: " & Natural'Image(SeedInStomach));
               end;
            or
               accept Play do
                  SeedInStomach := SeedInStomach - 1;
                  Put_Line("Chicken: I am playing with the kid: " & Natural'Image(SeedInStomach));
               end;
            or
               delay SeedDelay;
               SeedInStomach := SeedInStomach - 1;
               Put_Line("Chicken: losing a seed: " & Natural'Image(SeedInStomach));
            end select;
         end if;
      end loop;

   exception
         when Fly => Put_Line("Chicken flew away");
         when Gone => Put_Line("Chicken died");
   end Chicken;

   package ChickenR is new ADA.Numerics.Discrete_Random(Boolean);
   use ChickenR;
   G: ChickenR.Generator;
   

   task Child;

   task body Child is
      B: Boolean;
   begin
      loop
         delay 1.1;
         B := Random(G);
         if B then
            Chicken.Feed;
         else
            Chicken.Play;
         end if;
      end loop;
   exception
      when Tasking_Error => Put_Line("Child is Sad");
   end Child;
                  
   
begin
   ChickenR.Reset(G);

   
end Chicken;
