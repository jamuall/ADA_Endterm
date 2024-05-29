with Ada.Text_IO; use Ada.Text_IO;

procedure Mobile_Network is
	
	subtype Id_Type is Integer range 0..255;
	type C_D_Arr is array(Id_Type) of Boolean;
		
	protected Database is
		procedure Auth(Id : in Id_Type; Valid : out Boolean);
		function Is_Connected(Id : in Id_Type) return Boolean;
		procedure Off(Id : in Id_Type);
	private
		Connected_Devices : C_D_Arr := (others => false);
	end Database;
	
	task type Mobile(Id : Id_Type);
	type P_Mobile is access Mobile; 
	
	protected Cell_Tower is
		procedure Init;
		entry Attach(Id : in Id_Type; Success : out Boolean);
		entry Message(Id : in Id_Type; Msg : in String);
		procedure Detach(Id : in Id_Type);
	private
		On_Tower : Boolean := false;
	end Cell_Tower;
	
	protected body Database is
		procedure Auth(Id : in Id_Type; Valid : out Boolean) is
		begin
			Valid := Id < 100;
			if Valid then Connected_Devices(Id) := true; end if;
		end Auth;
		
		function Is_Connected(Id : in Id_Type) return Boolean is
		begin
			return Connected_Devices(Id);
		end Is_Connected;
		
		procedure Off(Id : in Id_Type) is
		begin
			Connected_Devices(Id) := false;
		end Off;
	end Database;
	
	task body Mobile is
		Attached : Boolean := false;
	begin
		delay 0.5;
		Put_Line("(M)" & Integer'Image(Id) & " connecting...");
		Cell_Tower.Attach(Id, Attached);
		if Attached then
			Put_Line("(M)" & Integer'Image(Id) & " connection successful.");
			delay 0.5;
			Put_Line("(M)" & Integer'Image(Id) & " sending ""Hello"" message.");
			Cell_Tower.Message(Id, "Hello");
			delay 0.5;
			Put_Line("(M)" & Integer'Image(Id) & " disconnecting...");
			Cell_Tower.Detach(Id);
		else
			Put_Line("(M)" & Integer'Image(Id) & " connection unsuccessful.");
		end if;
	end Mobile;
	
	protected body Cell_Tower is
		procedure Init is
		begin
			On_Tower := true;
		end Init;
		
		entry Attach(Id : in Id_Type; Success : out Boolean)
		when On_Tower is
		begin
			Database.Auth(Id, Success);
			if Success then
				Put_Line("(T)" & Integer'Image(Id) & " connected to tower.");
			else
				Put_Line("(T)" & Integer'Image(Id) & " can't connect.");
			end if;
		end Attach;
		
		entry Message(Id : in Id_Type; Msg : in String)
		when On_Tower is
		begin
			if Database.Is_Connected(Id) then
				Put_Line("(T)" & Integer'Image(Id) & " received message: """ & Msg & """.");
			else
				Put_Line("(T)" & Integer'Image(Id) & " can't receive message as device is not connected.");
			end if;
		end Message;
		
		procedure Detach(Id : in Id_Type) is
		begin
			Database.Off(Id);
			Put_Line("(T)" & Integer'Image(Id) & " disconnected from tower.");
		end Detach;
	end Cell_Tower;
	

	P : P_Mobile;
	
begin
	P := new Mobile(1);
	delay 2.5;
	Cell_Tower.Init;
	delay 0.5;
	P := new Mobile(100);
	delay 0.5;
	P := new Mobile(10);
	delay 0.5;
	P := new Mobile(20);
	delay 0.5;
	P := new Mobile(200);
end Mobile_Network;
