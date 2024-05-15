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
    protected Scoreboard is 
        procedure Score;
        function Get_Score return Integer;
    private 
        Score_Count : Integer := 0;
    end Scoreboard;
    protected body Scoreboard is
        procedure Score is 
        begin 
            Score_Count := Score_Count + 1;
        end Score;

        function Get_Score return Integer is 
        begin 
            return Score_Count;
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
                    accept Shoot do
                        Scoreboard.Score;
                    end Shoot;
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

    -- Player
    type String_Access is access all String;

    task type Player(Name : String_Access);
    task body Player is 
        Active_Interval : constant Time_Span := Seconds (10);
        End_Time  : Time := Clock + Active_Interval;
    begin
        delay 1.0;
        while Scoreboard.Get_Score < 4 loop
            select 
                Gate.Shoot;
                Printer.Print("Player " & Name.all & " shoots");
            or 
                delay 1.0;
            end select;
            delay 1.0;
        end loop;
        Printer.Print("Player " & Name.all & " terminated");
    end;
    type Player_Access is access Player;

    P : Player_Access;

begin 
    Safe_Random.Reset;

    P := new Player(new String'("A"));
    delay 1.0;
    P := new Player(new String'("B"));

end match;
