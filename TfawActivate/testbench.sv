//////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 2
//DESIGN: Testbench.sv
/////////////////////////////////////////////////////
module top();
  parameter WIDTH = 10;
  parameter ACT_CMD = 4;

  logic Clock, Reset, ACTREQ, expectedACTOK;
  wire ACTOK;
  
  //Internal wires
  logic [WIDTH-1:0] OP;
  
 //Instantiate the module
  ActivationWindow dut(.Clock(Clock), .Reset(Reset), .ACTREQ(ACTREQ), .ACTOK(ACTOK));

  initial 
    begin //Provide clock
      Clock = 1'b0;
      forever #5 Clock = ~Clock;
    end 

  initial 
    begin //Initialise reset

      @(negedge Clock) Reset <= 1'b0;
      @(negedge Clock) Reset <= 1'b1;

      //Check for consecutive ACTREQ and check for erronous permission of ACKOK
      for (int i=0; i<=200; i=i+1)
        begin
          @(negedge Clock) 
          begin
            if(ACTOK !== expectedACTOK) 
              $display($time , "***ERROR : ACTREQ = %0b, ACTOK = %0b, expectedACTOK = %0b", ACTREQ, ACTOK, expectedACTOK);
          end
        end
  
      #100
      $finish;
    end

 //Golden module
  always_ff @(posedge Clock, negedge Reset)
    begin
      ACTREQ <= $random();  //generate random ACTREQ
      if(!Reset)
        OP <= '0;
      else
        begin //Compare if number of ACT commands issued <=4 and allow the following ACTCMD to be issued
          if(ACTREQ)
            begin
              if( (($countones(OP)<ACT_CMD) && (OP[WIDTH-1]==1'b0)) || (($countones(OP)<=ACT_CMD) && (OP[WIDTH-1]==1'b1)) )
                begin
                  OP <= {OP[WIDTH-2:0], 1'b1};
                  expectedACTOK <= 1'b1;
                end
              else
                begin
                  OP <= {OP[WIDTH-2:0],1'b0};
                  expectedACTOK <= 1'b0;
                end
            end
          else
            begin
              OP <= {OP[WIDTH-2:0], 1'b0} ;
              if ($countones(OP)<ACT_CMD)
                expectedACTOK <= 1'b1;
              else
                expectedACTOK <= 1'b0;
            end
        end
    end

endmodule