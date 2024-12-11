with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   subtype deviceId is Integer range 0 .. 255;

   protected Printer is
      procedure Print(S : String := "");
   end Printer;

   protected body Printer is
      procedure Print(S : String := "") is
      begin
         Put_Line(S);
      end Print;
   end Printer;

   task Packet is
      entry Transmit_Message(Sender_Id : deviceId; Receiver_Id : deviceId; Msg : String);
   end Packet;


   task body Packet is
   begin
      loop
         select
            accept Transmit_Message(Sender_Id : deviceId; Receiver_Id : deviceId; Msg : String) do
               delay 0.5;
               Printer.Print("Packet: Transmitting message from " & Integer'Image(Sender_Id) &
                             " to " & Integer'Image(Receiver_Id) & ": " & Msg);
            end Transmit_Message;
         or
            delay 1.0;
            Printer.Print("Packet: Transmission timeout.");
            exit;
         end select;
      end loop;
   end Packet;

   task type Device(Id : deviceId; Rout_Id : deviceId; Receiver : deviceId) is
      entry Receiver_Entry;
   end Device;
   type P_Device is access Device;
   P: P_Device;

   task type Router(Rout_Id : deviceId) is
      entry Connect(Id : deviceId; Success : out Boolean);
      entry Send(Id : deviceId; Msg : String; Receiver : deviceId);
      entry Close(Id : deviceId);
   end Router;
   type P_Router is access Router;

   type Router_Arr is array(deviceId) of P_Router;
   Rout : Router_Arr;

   task body Router is
      DevId: deviceId;
   begin
      loop
         select
            accept Connect(Id : deviceId; Success : out Boolean) do
                  Printer.Print("Device: " & Integer'Image(Id) & " connected to router " & Integer'Image(Rout_Id));
               Success := True;
               DevId := Id;

            end Connect;
         or
            delay 5.0;
         end select;

         select
            accept Send(Id : deviceId; Msg : String; Receiver : deviceId) do
            Printer.Print("Router: Message from " & Integer'Image(Id) & " to " & Integer'Image(Receiver) & ": " & Msg);
            Packet.Transmit_Message(Id, Receiver, Msg);
            end Send;
        or
         delay 5.0;
         end select;

         select
            accept Close(Id : deviceId) do
                  Printer.Print("Device: " & Integer'Image(Id) & " disconnected from router " & Integer'Image(Rout_Id));
            end Close;
            exit;
         or
            delay 5.0;
            exit;
         end select;
      end loop;
   end Router;

   task body Device is
      Attached : Boolean := False;
      Msg : String := "Hello World";
   begin
      delay 0.5;
      Printer.Print("Device " & Integer'Image(Id) & " connecting to Router: " & Integer'Image(Rout_Id));
      Rout(Rout_Id).Connect(Id, Attached);
      if Attached then
         Printer.Print("Device " & Integer'Image(Id) & " connection to Router: " & Integer'Image(Rout_Id) & " successful.");
         delay 0.5;
         Printer.Print("Device " & Integer'Image(Id) & " sending ""Hello"" message to Router: " & Integer'Image(Rout_Id));
         Rout(Rout_Id).Send(Id, Msg, Receiver);
         delay 0.5;
         Printer.Print("Device " & Integer'Image(Id) & " waiting to receive messages...");
         select
            accept Receiver_Entry do
               Printer.Print("Device " & Integer'Image(Id) & " received message: " & Msg);
               delay 5.0;
            end Receiver_Entry;
         or
            delay 5.0;
         end select;
         Printer.Print("Device " & Integer'Image(Id) & " disconnecting from Router: " & Integer'Image(Rout_Id));
         Rout(Rout_Id).Close(Id);
      else
         Printer.Print("Device " & Integer'Image(Id) & " connection to Router: " & Integer'Image(Rout_Id) & " unsuccessful.");
      end if;
   end Device;

begin
   Rout(1) := new Router(1);

   P:= new Device(10, 1, 20);
   P:= new Device(20, 1, 10);
   P:= new Device(30, 1, 10);


end Main;
