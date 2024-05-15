with Ada.Text_IO;
use Ada.Text_IO;


procedure match is

    protected Printer is 
        procedure Print(str : in STRING := "");
    end Printer;
    protected body Printer is
        procedure Print(str : in STRING := "") is
        begin
            Put_Line(str);
        end Print;
    end Printer;

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

    task Goalkeeper is 
    end Goalkeeper;
    task body Goalkeeper is 
    begin 
        Gate.Keeper(True);
        delay 5.0;
        Gate.Keeper(False);
        Printer.Print("Keepr terminated");
    end;

    task Player is 
    end Player;
    task body Player is 
        Scored : Boolean := False;
    begin
        delay 1.0;
        while Scored = False loop
            select 
                Gate.Shoot;
                Scored := True;
            or 
                delay 1.0;
            end select;
        end loop;
        Printer.Print("Player scored and terminated happily");
    end;

begin 

    Printer.Print("OK");

end match;
