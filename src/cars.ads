package Cars with SPARK_Mode is

   type Gear is (D, P, N, R);
   Type Battery is range 0..100;
   type Speed is range 0..120;
   type Engine is (On, Off);
   type MinCharge is new Integer;
   type EmergencyCharge is new Integer;
   type WarningLight is (RED, ORANGE, GREEN);
   type Charging is (On, Off);

   type Car is record
      CarGears : Gear := P;
      CarCharge : Battery := 0;
      CarSpeed : Speed := 0;
      CarEngine : Engine := Off;
      CarMinCharge : MinCharge := 15;
      CarEmergencyCharge : EmergencyCharge := 5;
      CarWarningLight : WarningLight := RED;
      CarCharging: Charging := Off;
   end record;
   
   UserCar : Car := (CarGears => P,
                     CarSpeed => 0, 
                     CarCharge => 0,    
                     CarEngine => Off,
                     CarMinCharge => 15,                 
                     CarEmergencyCharge => 5,     
                     CarWarningLight => GREEN,
                     CarCharging => Off);
   
   procedure CreateCar (number: Integer) with 
     Global => (In_Out => UserCar),
     Post => (if number >= 100 then UserCar.CarCharge = 100 elsif Integer(number) <= 0 then UserCar.CarCharge = 0);
     --  (if Integer(number) >= 0 and Integer(number) <= 100 then UserCar.CarCharge = number);
   
   procedure StartCar with 
     Global => (In_Out => UserCar),
     Pre => UserCar.CarGears = P and Integer(UserCar.CarCharge) > 0,
     Post => UserCar.CarEngine = On;
   
   function SpeedInvariant return Boolean is 
      (if UserCar.CarGears = P then UserCar.CarSpeed = 0);
   
   procedure ChangeSpeed (number: Integer) with
     Global => (In_Out => UserCar),
     Pre => number >= 0 and number <= 100 and UserCar.CarGears /= P,
     Post => UserCar.CarSpeed >= 0 and UserCar.CarSpeed <= 100 ;
   
   procedure ChangeGear (str: Gear) with 
     Global => (In_Out => UserCar),
     Pre => UserCar.CarSpeed = 0 and UserCar.CarEngine = On,
     Post => UserCar.CarGears = str ;
   
   procedure DecreaseSpeed with 
     Global => (In_Out => UserCar),
     Pre => UserCar.CarSpeed >= 0,
     Post => UserCar.CarSpeed = 0;
  
   function ChargingInvariant return Boolean is
     (if Integer(UserCar.CarSpeed) /= 0 or 
          UserCar.CarGears /= P then 
             UserCar.CarCharging = Off);
   
   procedure ChargeCar with 
     Global => (In_Out => UserCar),
     Pre => UserCar.CarSpeed = 0 or UserCar.CarGears = P,
     Post => UserCar.CarCharging = On;
   
   procedure StopCarCharging with 
     Global => (In_Out => UserCar),
     Post => UserCar.CarCharging = Off;
   
   function Invariant return Boolean is 
      (SpeedInvariant and ChargingInvariant);
   
   procedure IncreaseBattery with 
     Global => (In_Out => UserCar),
     Pre => UserCar.CarCharge < 100 and UserCar.CarCharging = On,
     Post => UserCar.CarCharge'Old < UserCar.CarCharge or UserCar.CarCharge = 100;
   
   procedure DecreaseBattery with 
     Global => (In_Out => UserCar),
     Pre => UserCar.CarCharge > 0,
     Post => UserCar.CarCharge'Old > UserCar.CarCharge or UserCar.CarCharge = 0;
   
       
   
   
end Cars;
