with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure main 
  protected Safe_Random is 
          procedure Reset;
          function Generate return Float;
      private
          RGen : Ada.Numerics.Float_Random.Generator;
      end Safe_Random;
      protected body Safe_Random is 
          procedure Reset is 
          begin 
              Ada.Numerics.Float_Random.reset(RGen);
          end Reset;
  
          function Generate return Float is 
          begin
              return Ada.Numerics.Float_Random.Random(RGen);
          end Generate;
      end Safe_Random;
begin
  null;
end main;
