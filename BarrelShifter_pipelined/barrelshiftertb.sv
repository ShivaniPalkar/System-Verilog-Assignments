////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 5 ; Problem 1
//DESIGN: BarrelShifter Pipelined Testbench
/////////////////////////////////////////////////////////////////////////////////////////////////////
module top();

  parameter DATAWIDTH = 32;
  localparam muxNum = ($clog2(DATAWIDTH));
  parameter testcases = 200;

  bit Clock;
  logic [DATAWIDTH-1:0]In;
  logic ShiftIn;
  logic [muxNum-1:0]ShiftAmount;
  wire [DATAWIDTH-1:0]Out;

  logic [DATAWIDTH-1:0]shift;      //to store shifted data
  logic [DATAWIDTH-1:0]addNumber; //Number of shiftIns to be replicated and filled in vacated MSBs.
  integer j;
  logic [DATAWIDTH-1:0]expectedOut;

  logic [DATAWIDTH-1:0]popIn;
  logic popShiftIn;
  logic [muxNum-1:0]popShiftAmount;

  BarrelShifter #(DATAWIDTH) dut(Clock, In, ShiftAmount, ShiftIn, Out);
  
  //Creating queues to store input, shiftin amount and shiftin bit for next clock cycle
  logic [DATAWIDTH-1:0] InQ[$];
  logic ShiftInQ[$];
  logic [muxNum-1:0] ShiftAmountQ[$];

  initial
    begin

      // Clock = 1'b0;
      forever #5 Clock = ~Clock;

    end

  initial 
    begin

	  //Generate random inputs and push into respective queues
      for(j = 0; j < testcases; j = j+1)
        begin

          @(negedge Clock) 
          begin
            In = $random();
            InQ.push_front(In);
            ShiftAmount = $random();
            ShiftAmountQ.push_front(ShiftAmount);
            ShiftIn = $random();
            ShiftInQ.push_front(ShiftIn);

          end

        end
    end

  initial

    begin
     
      //wait for 5 clock cycles then push out queue elements
      repeat(muxNum) @(negedge Clock);
      while(InQ.size() !== 0)
        begin

          @(negedge Clock)
          begin
            popIn = InQ.pop_back();
            popShiftAmount = ShiftAmountQ.pop_back;
            popShiftIn = ShiftInQ.pop_back;
			
            //Comparing with high level logic
            shift = popIn << popShiftAmount;
            if(popShiftIn)
              begin
                addNumber = (2 ** (popShiftAmount)) - 1'b1;
                expectedOut = shift + addNumber;
              end
            else
              expectedOut = shift;

            //generate error message
            if(expectedOut!== Out)
              $display("***Error: In = %b, ShiftAmount = %b, ShiftIn = %b, expectedOut = %b, Out = %b", popIn, popShiftAmount, popShiftIn, expectedOut, Out);



          end

        end
      $finish();
    end



endmodule