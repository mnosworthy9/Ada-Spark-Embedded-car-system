package body Cars with SPARK_Mode is

   procedure CreateCar (number: Integer) is
   begin
      if(number >= 0 and number <= 100) then
         UserCar.CarCharge := Battery(number);
      elsif(number < 0) then
         UserCar.CarCharge := 0;
      else 
         UserCar.CarCharge := 100;
      end if;  
   end CreateCar;
   
   procedure StartCar is
   begin 
      if UserCar.CarGears = P and Integer(UserCar.CarCharge) > 0 then
         UserCar.CarEngine := On;
      end if;
   end StartCar;
   
   procedure ChangeSpeed (number: Integer) is 
   begin 
      if Integer(UserCar.CarSpeed) = 0 and Integer(UserCar.CarCharge) <= Integer(UserCar.CarMinCharge) then
         null;
      else 
         if(number >= 0 and number <= 100 and UserCar.CarGears /= P) then 
            UserCar.CarSpeed := Speed(number);
         end if;
      end if;
   end ChangeSpeed;
   
   procedure ChangeGear (str: Gear) is 
   begin 
      if( UserCar.CarSpeed = 0) then 
         UserCar.CarGears := str;
      end if;
   end ChangeGear;
   
   procedure DecreaseSpeed is 
   begin 
      UserCar.CarSpeed := 0;
   end DecreaseSpeed;
   
   procedure ChargeCar is 
   begin 
      if UserCar.CarSpeed = 0 or UserCar.CarGears = P then
         UserCar.CarCharging := On;
      end if;
   end ChargeCar;
   
   procedure StopcarCharging is 
   begin 
      UserCar.CarCharging := Off;
   end StopcarCharging;
   
   procedure IncreaseBattery is 
   begin 
      if UserCar.CarCharge < 100 and UserCar.CarCharging = On then 
         UserCar.CarCharge := UserCar.CarCharge + 1;
      end if;
   end IncreaseBattery;
   
   procedure DecreaseBattery is 
   begin 
      if UserCar.CarCharge > 0 then 
         UserCar.CarCharge := UserCar.CarCharge - 1;
      end if;
   end DecreaseBattery;
   

end Cars;
