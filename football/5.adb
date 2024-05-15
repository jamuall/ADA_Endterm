with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Float_Random;
with Ada.Real_Time; use Ada.Real_Time;


procedure match is

    -- Random
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

    -- Printer
    protected Printer is 
        procedure Print(str : in STRING := "");
    end Printer;
    protected body Printer is
        procedure Print(str : in STRING := "") is
        begin
            Put_Line(str);
        end Print;
    end Printer;

    -- Scoreboard
    type CArr is array (1..2) of Integer;
    protected Scoreboard is 
        procedure Score(ID : Integer);
        function Get_Score(ID : Integer) return Integer;
    private 
        Score_Count : CArr := (0,0);
    end Scoreboard;
    protected body Scoreboard is
        procedure Score(ID : Integer) is 
        begin 
            Score_Count(ID) := Score_Count(ID) + 1;
        end Score;

        function Get_Score(ID : Integer) return Integer is 
        begin 
            return Score_Count(ID);
        end Get_Score;
    end Scoreboard;

    -- Gate
    task Gate is 
        entry Shoot;
        entry Keeper(Ready : Boolean);
    end Gate;
    task body Gate is 
        Is_Ready : Boolean := False;
    begin 
        loop
            select 
                when Is_Ready =>
                    accept Shoot;
            or 
                accept Keeper(Ready : Boolean) do
                    if Ready then 
                        Printer.Print("Keeper is ready.");
                    else 
                        Printer.Print("Keeper is not ready");
                    end if;
                    Is_Ready := Ready;
                end Keeper;
            or 
                terminate;
            end select;
        end loop;
    end Gate;

    -- Goalkeeper
    task Goalkeeper is 
    end Goalkeeper;
    task body Goalkeeper is 
        Active_Interval : constant Time_Span := Seconds (10);
        End_Time  : Time := Clock + Active_Interval;
        Check_Interval : constant Time_Span := Milliseconds (1500);
        Next_Check : Time := Clock + Check_Interval;
    begin 
        while Clock <= End_Time loop
            delay until Next_Check;
            if Safe_Random.Generate < 0.7 then
                Gate.Keeper(True);
            else 
                Gate.Keeper(False);
            end if;
            Next_Check := Next_Check + Check_Interval;
        end loop;

        Gate.Keeper(False);
        Printer.Print("Keeper terminated");
    end;

    -- Ball
    type String_Access is access all String;

    task type Ball(Name : String_Access; ID : Integer) is 
        entry Shoot;
    end Ball;
    task body Ball is 
        --Keeper
    begin 
        loop 
            select
                accept Shoot do 
                    select
                        Gate.Shoot;
                        Scoreboard.Score(ID);
                        Printer.Print("Player " & Name.all & " shoots");
                    else 
                        null;
                    end select;
                end Shoot;
            or 
                terminate;
            end select;
        end loop;
    end Ball;
    type Ball_Access is access Ball;

    -- Player

    task type Player(Name : String_Access; ID : Integer);
    task body Player is 
        Active_Interval : constant Time_Span := Seconds (10);
        End_Time  : Time := Clock + Active_Interval;
        B : Ball_Access;
    begin
        B := new Ball(Name, ID);
        delay 1.0;
        while Scoreboard.Get_Score(ID) < 4 loop
            select 
                B.Shoot;
            else 
                null;
            end select;
            delay 1.0;
        end loop;
        Printer.Print("Player " & Name.all & " terminated");
    end;
    type Player_Access is access Player;

    P : Player_Access;

begin 
    Safe_Random.Reset;

    P := new Player(new String'("A"),1);
    delay 1.0;
    P := new Player(new String'("B"),2);

end match;
