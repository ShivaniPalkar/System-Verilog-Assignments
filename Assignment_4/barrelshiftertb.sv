////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 4
//DESIGN: BarrelShifter Testbench
/////////////////////////////////////////////////////////////////////////////////////////////////////

module top();

  parameter DATAWIDTH = 32;
  localparam muxNum = ($clog2(DATAWIDTH));
  parameter testcases = 200;


  logic [DATAWIDTH-1:0]In;
  logic ShiftIn;
  logic [muxNum-1:0]ShiftAmount;
  wire [DATAWIDTH-1:0]Out;

  logic [DATAWIDTH-1:0]shift;      //to store shifted data
  logic [DATAWIDTH-1:0]addNumber; //Number of shiftIns to be replicated and filled in vacated MSBs.
  integer j;
  logic [DATAWIDTH-1:0]expectedOut;

  BarrelShifter #(DATAWIDTH) dut(In, ShiftAmount, ShiftIn, Out);

  initial 
    begin


      for(j = 0; j < testcases; j = j+1)
        begin
          In = $random();
          ShiftAmount = $random();
          ShiftIn = $random();

          //Self check logic: if shiftIn is 1, OR the number of 1s by which the data has been left shifted to the MSB. Else, shift by amount and let vacated bits be replaced by 0.
          shift = In << ShiftAmount;
          if(ShiftIn)
            begin
              addNumber = (2 ** (ShiftAmount)) - 1'b1;
              expectedOut = shift + addNumber;
            end
          else
            expectedOut = shift;

          #100
          //generate error messages
          if(expectedOut!== Out)
            $display("***Error: In = %b, ShiftAmount = %b, ShiftIn = %b, expectedOut = %b, Out = %b", In, ShiftAmount, ShiftIn, expectedOut, Out);

        end

    end
endmodule