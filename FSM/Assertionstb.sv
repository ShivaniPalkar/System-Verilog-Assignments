////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 7
//DESIGN: fsm assertion TB
/////////////////////////////////////////////////////////////////////////////////////////////////////

module fsmassertions(Clock, Reset, S1, S2, S3, L1, L2, L3);

  parameter GREEN  = 2'b01;
  parameter YELLOW = 2'b10;
  parameter RED    = 2'b11;

  input logic Clock;
  input logic Reset;
  input logic S1, S2, S3;
  input logic [1:0] L1, L2, L3;


  //The sensors never have unknown values
  property SensorValid_p(logic Sensor);
    @(posedge Clock)
    !Reset |=> !$isunknown(Sensor);
  endproperty

  //Sensor 1 invalid
  SensorValidS1_a: assert property (SensorValid_p(S1))
    else $error("Signal S1 is unknown");

    //Sensor 2 invalid
  SensorValidS2_a: assert property (SensorValid_p(S2))
    else $error("Signal S2 is unknown");

      //Sensor 3 invalid
   SensorValidS3_a: assert property (SensorValid_p(S3))
    else $error("Signal S3 is unknown");


  //L2 and L3 signals are always same
  property L2andL3Same_p;
  @(posedge Clock)
  disable iff(Reset)
     ((L2 == RED) && (L3 == RED)) || ((L2 == YELLOW) && (L3 == YELLOW)) || ((L2 == GREEN) && (L3 == GREEN));
   endproperty 
   L2andL3Same_a: assert property(L2andL3Same_p)
     else $error ($time,"L2 and L3 are different");

   //If a light is Yellow, cross light is RED for when L1 is yellow
   property CrossLightRedL1_p;
   @(posedge Clock)
     (L1 == YELLOW) |-> (L2 == RED && L3 == RED);
   endproperty
   CrossLightRedL1_a :assert property (CrossLightRedL1_p)
     else $error (" Cross light from L1 is not red");

   //If a light is yellow, cross light is RED for when L2 and L3 are red
    property CrossLightRed_p;
    @(posedge Clock)
      (L2== YELLOW) && (L3 == YELLOW) |-> (L1 == RED);
    endproperty
    CrossLightRed_a :assert property (CrossLightRed_p)
       else $error (" Cross light from L2 or L3 is not red");

//ILLEGAL TRANSITIONS            

     property NotValidTransistion(logic[1:0] LightNumber, Signal1, Signal2);
     @(posedge Clock)
       (LightNumber == Signal1) ##1 (LightNumber != Signal1) |-> (LightNumber != Signal2);
     endproperty
             
// ILLEGAL TRANSITIONS FOR L1
        NeverGreenToRedL1_a : assert property (NotValidTransistion(L1, GREEN, RED))
        else $error ("L1 going from green to red");

        NeverRedToYellowL1_a : assert property (NotValidTransistion(L1, RED, YELLOW))
        else $error ("L1 going from red to yellow");

        NeverYellowToGreenL1_a : assert property (NotValidTransistion(L1, YELLOW, GREEN))
        else $error ("L1 going from yellow to green");

//ILLEGAL TRANSITIONS FOR L2
        NeverGreenToRedL2_a : assert property (NotValidTransistion(L2, GREEN, RED))
        else $error ("L2 going from green to red");

        NeverRedToYellowL2_a : assert property (NotValidTransistion(L2, RED, YELLOW))
        else $error ("L2 going from red to yellow");

        NeverYellowToGreenL2_a : assert property (NotValidTransistion(L2, YELLOW, GREEN))
        else $error ("L2 going from yellow to green");

//ILLEGAL TRANSITIONS FOR L3
        NeverGreenToRedL3_a : assert property (NotValidTransistion(L3, GREEN, RED))
        else $error ("L3 going from green to red");

        NeverRedToYellowL3_a : assert property (NotValidTransistion(L3, RED, YELLOW))
        else $error ("L3 going from red to yellow");

        NeverYellowToGreenL3_a : assert property (NotValidTransistion(L3, YELLOW, GREEN))
        else $error ("L3 going from yellow to green");

//Time limits

     property SignalDuration_p(logic[1:0]LightNumber, Signal, int Cycles);
     @(posedge Clock)
     disable iff(Reset)
       ((LightNumber != Signal) ##1 (LightNumber == Signal)) |-> (LightNumber == Signal) [*Cycles]##1(LightNumber != Signal);
     endproperty

     //Harrison light remains green for exactly 15 seconds
     HarrisonGreenFor15_a: assert property(SignalDuration_p(L2,GREEN,15))
     else $error ("Harrison light is not green for 15 seconds");


     //Harrison light remains Yellow for exactly 5 seconds
     HarrisonYellowFor5_a: assert property(SignalDuration_p(L2,YELLOW,5))
     else $error ("Harrison light is not yellow for 5 seconds");

     //4th Avenue light remains Yellow for exactly 5 seconds
     FourthAveYellowFor5_a: assert property(SignalDuration_p(L1,YELLOW,5)) 
     else $error ("4th Avenue light is not yellow for 5 seconds");

     //4th Avenue light is red for exactly 21 seconds
     FourthAveRed21_a: assert property (SignalDuration_p(L1,RED,21))
     else $error ("4th Avenue light is not RED for 21 seconds");

     //Considering all signals go to red for 1 second, assertion should check that 4th avenue light should stay red for 22 seconds  
     FourthAveRed22_a: assert property (SignalDuration_p(L1,RED,22))
     else $error ("4th Avenue light is not RED for 21 seconds");

     //Harrison light remains red for atleast 51 seconds
     property HarrisonRedAtleast51_p;
     @(posedge Clock)
     disable iff(Reset)
       ((L2!= RED) ##1 (L2 == RED)) |=> ( (L2 == RED)[*51:$]  ##1 ( L2 !=RED) );
     endproperty
     HarrisonRedAtleast51_a: assert property (HarrisonRedAtleast51_p)
       else $error("Harrison light not red for atleast 51 seconds");

     //Considering 1 cycle for all signals going red, Harrison light should remain red for atleast 52 seconds
     property HarrisonRedAtleast52_p;
     @(posedge Clock)
     disable iff(Reset)
       ((L2!= RED) ##1 (L2 == RED)) |=> ( (L2 == RED)[*52:$]  ##1 ( L2 !=RED) );
     endproperty
     HarrisonRedAtleast52_a: assert property (HarrisonRedAtleast52_p)
       else $error("Harrison light not red for atleast 52 seconds");


      //4th Ave light remains green for atleast 45 seconds and remains so while traffic on 4th avenue and none on Harrison
     
    
      property FourthAveGreen45_p;
      @(posedge Clock)
      disable iff(Reset)
       (L1 != GREEN) ##1 (L1 == GREEN) |-> (L1 == GREEN)[*45] ##1 ( ( (S1==1) && (S2==0) && (S3==0) && (L1==GREEN) )[*0:$] );
      endproperty   
      FourthAveGreen45_a: assert property (FourthAveGreen45_p)
         else $error ("4th Avenue light not remaining green for 45 seconds");




endmodule


 module top;

 parameter TESTCASES = 5000;

 reg Clock;
 reg Reset;
 reg S1, S2, S3;
 wire [1:0] L1, L2, L3;

 int j;
 
fsm  dut(Clock, Reset, S1, S2, S3, L1, L2, L3);
bind fsm fsmassertions f1(Clock, Reset, S1, S2, S3, L1, L2, L3);


  initial
     begin
        
     Clock = 1;
     forever #(5) Clock = ~Clock;

     end
                                                  
 initial 
    begin
        
     Reset = 1;
     repeat (2) @(negedge Clock);
     Reset = 0;
     //Generate random inputs 
      for(j = 0; j < TESTCASES; j = j+1)
        begin
          @(negedge Clock) 
          begin
            S1= $random();
            S2 = $random();
            S3= $random();
          end
    end 
    repeat(1)@(negedge Clock);
    $finish;
    end 
endmodule



