with ADA.Text_IO;
use ADA.Text_IO;

procedure Main is

   subtype deviceId is Integer range 0..255;

   protected Printer is
      procedure Print(S: String := "");
   end Printer;

   protected body Printer is
      procedure Print(S: String := "") is
      begin
         Put_Line(S);
      end Print;
   end Printer;

   task type Device(Id : deviceId; routId: deviceId);
   type P_Device is access Device;

   P: P_Device;

   task type Router(routId: deviceId) is
      entry connect(Id: deviceId; success: out Boolean);
      entry send(Id: deviceId; msg: string);
      entry close(Id: deviceId);
   end Router;
   type P_Router is access Router;

   type Router_Arr is array(deviceId) of P_Router;
	Rout : Router_Arr;

   task body Router is
      DevId: deviceId;
   begin
      loop
         select
            accept connect(Id: deviceId; success: out Boolean) do
               Printer.Print("Device: " & Integer'Image(Id) & " connected to router " & Integer'Image(routId));
               success := True;
               DevId := Id;
            end connect;
         or
            delay 5.0;
         end select ;
         select
            accept send(Id: deviceId; msg: string)  do
               Printer.Print("Device: " & Integer'Image(Id) & " received message: """ & Msg & """.");
            end send;
         or
            delay 5.0;
         end select;
         select
            accept close(Id: deviceId) do
               Printer.Print("Device: " & Integer'Image(Id) & " disconnected from router."  & Integer'Image(routId));
            end close;
            exit;
         or
            delay 5.0;
            exit;
         end select;
      end loop;
   end Router;

task body Device is
   Attached : Boolean := false;
	begin
		delay 0.5;
		Printer.Print("Device " & Integer'Image(Id) & " connecting to Router: " & Integer'Image(routId));
		Rout(routId).connect(Id, Attached);
		if Attached then
			Printer.Print("Device " & Integer'Image(Id) & " connection to Router: " & Integer'Image(routId) & " successful.");
			delay 0.5;
			Printer.Print("Device " & Integer'Image(Id) & " sending ""Hello"" message to Router: " & Integer'Image(routId));
			Rout(routId).send(Id, "Hello");
			delay 0.5;
			Printer.Print("Device " & Integer'Image(Id) & " disconnecting from Router: " & Integer'Image(routId));
			Rout(routId).close(Id);
		else
			Printer.Print("Device " & Integer'Image(Id) & " connection to Router: " & Integer'Image(routId) & " unsuccessful.");
		end if;
	end Device;

begin
   Rout(1) := new Router(1);
   Rout(2) := new Router(2);
   P := new Device(10, 1);
   P := new Device(20, 1);
   P := new Device(30, 1);

   P := new Device(10, 2);
   P := new Device(20, 2);
   P := new Device(30, 2);

end Main;
