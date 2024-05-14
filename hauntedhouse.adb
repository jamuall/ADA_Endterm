with Tools;

package body HauntedHouse is

   subtype Index is Positive range 1..5;
   package Ind_Generator is new Tools.Random_Generator(Index);
   
   function IsWall(Pos: Position) return Boolean is
   begin
        return GetField(Pos) = W;
   end IsWall;
   
   
   function IsCorrect(Pos: Position) return Boolean is
   begin
      if (Pos.X >= Index'First and Pos.X <= Index'Last and
          Pos.Y >= Index'First and Pos.Y <= Index'Last) then
           return not IsWall(Pos);
      else
         return False;
      end if;
   end IsCorrect;
   
      
   function GetField(Pos: Position) return Fields is
   begin
      return House(Pos.X, Pos.Y);
   end GetField;
   
   
   function GetRandPos return Position is
   begin
      return (Ind_Generator.GetRandom, Ind_Generator.GetRandom);
   end GetRandPos;
      

end HauntedHouse;
