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

   task type Device(Id : deviceId);
   type P_Device is access Device;

   P: P_Device;

   task Router is
      entry connect(Id: deviceId; success: out Boolean);
      entry send(Id: deviceId; msg: string);
      entry close(Id: deviceId);
   end Router;

   task body Router is
   begin
      loop
         select
            accept connect(Id: deviceId; success: out Boolean) do
               Printer.Print("Device: " & Integer'Image(Id) & " connected to router.");
               success := True;
            end connect;
         or
            accept send(Id: deviceId; msg: string)  do
               Printer.Print("Device: " & Integer'Image(Id) & " received message: """ & Msg & """.");
            end send;
         or
            accept close(Id: deviceId) do
               Printer.Print("Device: " & Integer'Image(Id) & " disconnected from router.");
            end close;
            exit;
         end select;
      end loop;
   end Router;

task body Device is
   Attached : Boolean := false;
	begin
		delay 0.5;
		Printer.Print("Device " & Integer'Image(Id) & " connecting...");
		Router.connect(Id, Attached);
		if Attached then
			Printer.Print("Device " & Integer'Image(Id) & " connection successful.");
			delay 0.5;
			Printer.Print("Device " & Integer'Image(Id) & " sending ""Hello"" message.");
			Router.send(Id, "Hello");
			delay 0.5;
			Printer.Print("Device " & Integer'Image(Id) & " disconnecting...");
			Router.close(Id);
		else
			Printer.Print("Device " & Integer'Image(Id) & " connection unsuccessful.");
		end if;
	end Device;

begin
   P := new Device(10);
end Main;
