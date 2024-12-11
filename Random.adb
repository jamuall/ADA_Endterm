with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure main 
  --Protected Safe_Random
   protected Safe_Random is
      procedure Init;
      function Generate return Float;
   private
      G: Generator;
   end Safe_Random;
   
   protected body Safe_Random is
      procedure Init is
      begin
         Reset(G);
      end Init;
      
      function Generate return Float is
      begin
         --return Random(G) * (4.0 - 0.0) + 0.0;
          return Random(G) --returns between 0.0 and 1.0;
      end Generate;
   end Safe_Random;
begin
  null;
end main;
