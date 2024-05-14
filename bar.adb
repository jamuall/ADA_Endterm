with ADA.Text_IO;
use ADA.Text_IO;

procedure Bar is

   type Drinks is (Beer, Wine, Brandy);

   task Barman is
      entry Order(What: in Drinks);
   end 	Barman;

   task body Barman is 
   begin
      for I in 1..20 loop
         accept Order(What: in Drinks) do
            Put_Line("The ordered drink is: " & Drinks'Image(What));
            case What is
               when Beer => delay 1.0;
               when Wine => delay 0.2;
               when Brandy => delay 0.3;
            end case;
         end Order;
      end loop;
   end Barman;

   task type Customer;
   
   task body Customer is
      Beer_Drinking: Duration := 1.0;
   begin
      Barman.Order(Brandy);
      Put_Line("Customer starts with a brandy");
      delay 0.1;
      Barman.Order(Wine);
      Put_Line("Customer ordered Wine");
      delay 0.3;
      loop
         Barman.Order(Beer);
         Put_Line("Customer ordered Beer");
         delay Beer_Drinking;
         Beer_Drinking := 2 * Beer_Drinking;
      end loop;
   end Customer;

   type Customer_Access is access Customer;
   C: Customer_Access;
   
begin
   
   for I in 1..5 loop
      delay 3.0;
      Put_Line("A customer is here");
      C := new Customer;
   end loop;

end Bar;
