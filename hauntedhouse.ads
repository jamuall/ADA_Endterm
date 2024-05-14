package HauntedHouse is

   --W: Wall, R: Room, C: Corridor, E: Exit
   type Fields is (W, R, C, E);
   
   type Position is record
      X: Natural;
      Y: Natural;
   end record;
   
   function IsWall(Pos: Position) return Boolean;
   function IsCorrect(Pos: Position) return Boolean;
   function GetField(Pos: Position) return Fields;
   function GetRandPos return Position;
   
private
   
   type Field_Array is array(Natural range <>, Natural range <>) of Fields;
   
   House: constant Field_Array(1..5, 1..5) := ((C,C,C,W,R),
                                               (R,W,C,W,C),
                                               (W,C,C,R,R),
                                               (C,R,W,W,R),
                                               (R,C,E,C,C));

end HauntedHouse;
