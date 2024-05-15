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
                        Printer.Print("Player shoot");
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
        Printer.Print("Keeper terminated");
    end;

    task type Player is 
    end Player;
    task body Player is 
        Active_Interval : constant Time_Span := Seconds (10);
        End_Time  : Time := Clock + Active_Interval;
        Scored : Boolean := False;
    begin
        delay 1.0;
        while Clock <= End_Time and Scored = False loop
            select 
                Gate.Shoot;
                Scored := True;
            or 
                delay 1.0;
            end select;
        end loop;
        Printer.Print("Player terminated");
    end;
    type Player_Access is access Player;

    P : Player_Access;

begin 
    Safe_Random.Reset;

    P := new Player;
    delay 1.0;
    P := new Player;

end match;
