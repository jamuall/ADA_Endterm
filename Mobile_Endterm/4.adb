with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Mobile_Network is
	
	subtype Id_Type is Integer range 0..255;
	subtype Cell_Id_Type is Integer range 1..3;
	
	type C_D_Arr is array(Id_Type) of Boolean;
	
	package Random_Cell_Id is new Ada.Numerics.Discrete_Random(Cell_Id_Type);
	use Random_Cell_Id;
	G : Generator;
	
	protected Database is
		procedure Auth(Id : in Id_Type; Valid : out Boolean; Cell_Id : in Cell_Id_Type);
		function Is_Connected(Id : in Id_Type) return Boolean;
		procedure Off(Id : in Id_Type);
	private
		Connected_Devices : C_D_Arr := (others => false);
	end Database;
	
	task type Mobile(Id : Id_Type);
	type P_Mobile is access Mobile; -- PMobil :D
	
	protected type Cell_Tower is
		procedure Init(Id : in Cell_Id_Type);
		entry Attach(Id : in Id_Type; Success : out Boolean);
		entry Message(Id : in Id_Type; Msg : in String);
		procedure Detach(Id : in Id_Type);
	private
		On_Tower : Boolean := false;
		Cell_Id : Cell_Id_Type;
	end Cell_Tower;
	
	type Tower_Arr is array(Cell_Id_Type) of Cell_Tower;
	Towers : Tower_Arr;
	
	P : P_Mobile;
	
	
	protected body Database is
		procedure Auth(Id : in Id_Type; Valid : out Boolean; Cell_Id : in Cell_Id_Type) is
		begin
			Valid := Id < 100 * Cell_Id and Id >= 100 * (Cell_Id - 1);
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
		Tower_Id : Cell_Id_Type := Random(G);
	begin
		delay 0.5;
		Put_Line("(M)" & Integer'Image(Id) & " connecting to " & Integer'Image(Tower_Id) & "...");
		Towers(Tower_Id).Attach(Id, Attached);
		if Attached then
			Put_Line("(M)" & Integer'Image(Id) & " connection successful.");
			delay 0.5;
			Put_Line("(M)" & Integer'Image(Id) & " sending ""Hello"" message.");
			Towers(Tower_Id).Message(Id, "Hello");
			delay 0.5;
			Put_Line("(M)" & Integer'Image(Id) & " disconnecting...");
			Towers(Tower_Id).Detach(Id);
		else
			Put_Line("(M)" & Integer'Image(Id) & " connection unsuccessful.");
		end if;
	end Mobile;
	
	protected body Cell_Tower is
		procedure Init(Id : in Cell_Id_Type) is
		begin
			Cell_Id := Id;
			On_Tower := true;
		end Init;
		
		entry Attach(Id : in Id_Type; Success : out Boolean)
		when On_Tower is
		begin
			Database.Auth(Id, Success, Cell_Id);
			if Success then
				Put_Line("(T" & Integer'Image(Cell_Id) & ")" & Integer'Image(Id) & " connected to tower.");
			else
				Put_Line("(T" & Integer'Image(Cell_Id) & ")" & Integer'Image(Id) & " can't connect.");
			end if;
		end Attach;
		
		entry Message(Id : in Id_Type; Msg : in String)
		when On_Tower is
		begin
			if Database.Is_Connected(Id) then
				Put_Line("(T" & Integer'Image(Cell_Id) & ")" & Integer'Image(Id) & " received message: """ & Msg & """.");
			else
				Put_Line("(T" & Integer'Image(Cell_Id) & ")" & Integer'Image(Id) & " can't receive message as device is not connected.");
			end if;
		end Message;
		
		procedure Detach(Id : in Id_Type) is
		begin
			Database.Off(Id);
			Put_Line("(T" & Integer'Image(Cell_Id) & ")" & Integer'Image(Id) & " disconnected from tower.");
		end Detach;
	end Cell_Tower;
	
begin
	Reset(G);
	for I in Towers'Range loop
		Towers(I).Init(I);
	end loop;
	
	for I in 1..8 loop
		delay 0.5;
		P := new Mobile(I * 30);
	end loop;
end Mobile_Network;
