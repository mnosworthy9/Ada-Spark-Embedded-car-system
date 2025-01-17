with Cars; use Cars;
with Ada.Text_IO; use Ada.Text_IO;
procedure Main is

   number: Integer;
   Str: String(1..2);
   Last: Natural;
   bool: Boolean;
   task CheckBattery;
   task ReduceBattery;
   task ChargingBattery;

   task body CheckBattery is
   begin
      loop
      if(UserCar.CarEngine = On and UserCar.CarCharge > 0) then
         if(Integer(UserCar.CarCharge) > Integer(UserCar.CarMinCharge)) then
            UserCar.CarWarningLight := GREEN;
            Put_Line (ASCII.ESC & "[92m" & "Battery is at: " & UserCar.CarCharge'Image & ASCII.ESC & "[0m");
         elsif(Integer(UserCar.CarCharge) > Integer(UserCar.CarEmergencyCharge)) then
            UserCar.CarWarningLight := ORANGE;
            Put_Line (ASCII.ESC & "[93m" & "Battery is at: " & UserCar.CarCharge'Image & ASCII.ESC & "[0m");
         else
            UserCar.CarWarningLight := RED;
            Put_Line (ASCII.ESC & "[91m" & "Battery is at: " & UserCar.CarCharge'Image & ASCII.ESC & "[0m");
         end if;
         if(UserCar.CarEngine = On and UserCar.CarCharge = 0) then
            Put_Line (ASCII.ESC & "[91m" & "Battery DEAD" & ASCII.ESC & "[0m");
         end if;
            delay(2.0);
         end if;
      end loop;
   end CheckBattery;

   task body ReduceBattery is
   begin
      loop
         if(UserCar.CarEngine = On and UserCar.CarCharging = Off) then
            if(Integer(UserCar.CarSpeed) > 70) then
               delay(1.0);
            elsif(Integer(UserCar.CarSpeed) > 30) then
               delay(2.5);
            elsif(Integer(UserCar.CarSpeed) > 10) then
               delay(3.0);
            else
               delay(4.0);
            end if;
            DecreaseBattery;
         end if;
      end loop;
   end ReduceBattery;

   task body ChargingBattery is
   begin
      loop
         if UserCar.CarCharging = On then
            UserCar.CarEngine := Off;
            if UserCar.CarCharge < 100 then
               IncreaseBattery;
               delay 0.2;
            end if;
            if Integer(UserCar.CarCharge) mod 10 = 0 then
               Put_Line(ASCII.ESC & "[92m" & "Charge at: " & UserCar.CarCharge'Image & ASCII.ESC & "[0m");
               if UserCar.CarCharge = 100 then
                  UserCar.CarCharging := Off;
                  exit;
               end if;
            end if;
         end if;
      end loop;
   end ChargingBattery;


begin
   Put_Line("Car Battery: Enter value 0-100");
   number := Integer'Value(Get_Line);
   CreateCar(number);
   StartCar;
   if(UserCar.CarEngine = On) then
      Put_Line(ASCII.ESC & "[92m" & "Car started successfully" & ASCII.ESC & "[0m");
      while (Integer(UserCar.CarCharge) > 0) loop
         Put_Line("What would you like to do? 1-change speed, 2-change gear, 3-create obstacle, 4-Diagnostic Mode, 5-Charge Battery, other-Emergency stop");
         Get_Line(Str,Last);
         case Str(1) is
            when '1' =>
               Put_Line("what would you like new speed to be? Limit 100.");
               number := Integer'Value(Get_Line);
               if(number >= 0 and number <= 100 and UserCar.CarGears /= P) then
                  ChangeSpeed(number);
                  Put_Line("Car Speed is now at: " & UserCar.CarSpeed'Image);
                  task
               else
                  Put_Line("invalid speed or car in park");
               end if;
            when '2' =>
               Put_Line("Enter the Gear ( D, R, P, N )");
               Get_Line(Str, Last);
               if(UserCar.CarSpeed > 0) then
                  Put_Line("Speed too high... Decreasing speed");
                  DecreaseSpeed;
               end if;

               case Str(1) is
                  when 'D' =>
                     if UserCar.CarGears = R then
                        Put_Line("Changing to Neutral");
                     end if;

                     ChangeGear(D);
                  when 'P' =>
                     ChangeGear(P);
                  when 'N' =>
                     ChangeGear(N);
                  when 'R' =>
                     if UserCar.CarGears = D then
                        Put_Line("Changing to Neutral");
                     end if;
                     ChangeGear(R);
                  when 'd' =>
                     if UserCar.CarGears = R then
                        Put_Line("Changing to Neutral");
                     end if;
                     ChangeGear(D);
                  when 'p' =>
                     ChangeGear(P);
                  when 'n' =>
                     ChangeGear(N);
                  when 'r' =>
                     if UserCar.CarGears = R then
                        Put_Line("Changing to Neutral");
                     end if;
                     ChangeGear(R);
                  when others =>
                     Put_Line("Invalid Gear");
               end case;
               Put_Line("Now in gear: " & UserCar.CarGears'Image);
            when '3' =>
               Put_Line("Obstacle created");
               DecreaseSpeed;
               Put_Line("Speed reduced to: " & UserCar.CarSpeed'Image);
               Put_Line("Obstacle avoided");
            when '4' =>
               Put_Line("Entering Diagnostic mode..");
               DecreaseSpeed;
               ChangeGear(P);
               bool := True;
               while bool loop
                  Put_Line("Press any key to exit");
                  Get_Line(Str, Last);
                  case Str(1) is
                     when others =>
                        bool := False;
                  end case;
               end loop;
            when '5' =>
                  if UserCar.CarSpeed > 0 then
                     Put_Line("Speed too high... Decreasing speed");
                  DecreaseSpeed;
                  ChangeGear(P);
                  end if;
                  bool := True;
                  Put_Line("Press any key to exit");
                  while bool loop
                     ChargeCar;
                     Get_Line(Str, Last);
                     case Str(1) is
                        when others =>
                           bool := False;
                           StopCarCharging;
                     end case;
                  end loop;
            when others =>
               Put_Line(ASCII.ESC & "[90m" & "EMERGENCY STOP" & ASCII.ESC & "[0m");
               abort CheckBattery; abort ReduceBattery; exit;
         end case;
      end loop;
   else
      Put_Line(ASCII.ESC & "[91m" & "Battery too low" & ASCII.ESC & "[0m");
   end if;

end Main;
