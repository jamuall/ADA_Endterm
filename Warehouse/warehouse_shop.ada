with ADA.Text_IO, Ada.Numerics.Discrete_Random;
use ADA.Text_IO;

procedure Main is

   --- Declaration

   package Rand_Shop is new ADA.Numerics.Discrete_Random(Positive);
   use Rand_Shop;

   protected Printer is
      procedure Print(S: String := "");
   end Printer;

   protected Safe_Random is
      procedure Init;
      function Generate return Positive;
   private
      G: Generator;
   end Safe_Random;

   protected Warehouse is
      procedure Init;
      procedure Increase_Cargo;
      procedure Decrease_Cargo;
      procedure Print_Warehouse_Stock;
   private
      Cargo_Counter: Natural;
   end Warehouse;

   task Delivery_Truck;

   task type Buyer;

   type PBuyer is access Buyer;

   task type Shop(ID: Positive) is
      entry Notification;
      entry Buy;
      entry Close;
   end Shop;

   type PShop is access Shop;
   type ShopArray is array(1..5) of PShop;

   Shops: ShopArray;

   task Scheduler;

   --- Implementation
    protected body Printer is
      procedure Print(S: String := "") is
      begin
         Put_Line(S);
      end Print;
   end Printer;

   protected body Safe_Random is
      procedure Init is
      begin
         Reset(G);
      end Init;

      function Generate return Positive is
      begin
         return (Random(G) mod 5) + 1;
      end Generate;
   end Safe_Random;

   protected body Warehouse is
      procedure Init is
      begin
         Cargo_Counter := Natural'First;
      end Init;

      procedure Increase_Cargo is
      begin
         Cargo_Counter := Cargo_Counter + 1;
      end Increase_Cargo;

      procedure Decrease_Cargo is
      begin
         Cargo_Counter := Cargo_Counter - 1;
      end Decrease_Cargo;

      procedure Print_Warehouse_Stock is
      begin
         Printer.Print("Warehouse Stock: " & Natural'Image(Cargo_Counter));
      end Print_Warehouse_Stock;
   end Warehouse;

   task body Delivery_Truck is
      Rand_Num: Positive;
   begin
      loop
         delay 0.1;
         Warehouse.Increase_Cargo;
         Rand_Num := Safe_Random.Generate;
         select
            Shops(Rand_Num).Notification;
            Printer.Print("Truck notifies shop " & Positive'Image(Rand_Num));
         or
            delay 0.1;
            Printer.Print("Truck goes back to the garage");
            exit;
         end select;
      end loop;
   end Delivery_Truck;

   task body Buyer is
      Rand_Num: Positive;
   begin
      delay 0.4;
      Rand_Num:= Safe_Random.Generate;
      Printer.Print("Buyer enters shop " & Positive'Image(Rand_Num));
      delay 0.1;
      Shops(Rand_Num).Buy;
   end Buyer;

   task body Shop is
      Open: Boolean := True;
      Stock: Natural := 0;
      Sold: Natural := 0;
   begin
      while Open loop
         select
            accept Notification  do
               Warehouse.Decrease_Cargo;
               Stock := Stock + 1;
            end Notification;
         or
            accept Buy do
               delay 0.2;
               if Stock = 0 then
                  Printer.Print("Shop " & Positive'Image(ID) & " stock is empty");
               else
                  Printer.Print("Buyer bought at shop " & Positive'Image(ID));
                  Stock := Stock - 1;
                  Sold := Sold + 1;
               end if;
            end Buy;
         or
            accept Close do
                  delay 0.5;
                  Printer.Print("Shop " & Positive'Image(ID) & " stock left: " & Natural'Image(Stock));
                  Printer.Print("Shop " & Positive'Image(ID) & " sold: " & Natural'Image(Sold));
                  Open := False;
            end Close;
         end select;
      end loop;
   end Shop;

   task body Scheduler is
      Time: Float := 0.0;
      B: PBuyer;
   begin
      for I in 1..5 loop
         Shops(I):= new Shop(I);
      end loop;

      while Time <= 10.0 loop
         B := new Buyer;
         delay 0.3;
         Time := Time + 0.3;
      end loop;

      for I in 1..5 loop
         Shops(I).Close;
      end loop;

      Warehouse.Print_Warehouse_Stock;
   end Scheduler;

begin
   Safe_Random.Init;
   Warehouse.Init;
end Main;
