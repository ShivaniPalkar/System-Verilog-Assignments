////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 EXTRA credit
//DESIGN: Barrel Shifter assertions
/////////////////////////////////////////////////////////////////////////////////////////////////////
module Assertions(Clock, In, ShiftAmount, ShiftIn, Out);

  parameter WIDTH = 32;
  localparam muxNum = ($clog2(WIDTH));

  input logic Clock;
  input logic [WIDTH-1:0]In;
  input logic ShiftIn;
  input logic [muxNum-1:0]ShiftAmount;
  input logic [WIDTH-1:0]Out;

  
  //Function with high level logic to be called in the assertion
  function logic [WIDTH-1:0] ExpectedBarrelResult(input logic [WIDTH-1 : 0]in, logic [muxNum - 1:0]shiftamount, logic shiftin);

    logic [WIDTH - 1:0]shift;
    logic [WIDTH - 1:0]addNumber;
    logic [WIDTH - 1:0]expectedOut;

    shift = in << shiftamount;
    if(shiftin)
      begin
        addNumber = (2 ** (shiftamount)) - 1'b1;
        expectedOut = shift + addNumber;
      end
    else
      expectedOut = shift;
    return(expectedOut);
  endfunction

  //Display function to be called in the assertion
  function bit Display(input logic [WIDTH-1 : 0]in, logic [muxNum - 1:0]shiftamount, logic shiftin,  logic [WIDTH-1:0]out);
    $display("In = %b, ShiftAmount = %b, ShiftIn = %b, Out = %b", in, shiftamount, shiftin, out);
    return(1);
  endfunction

  //Property
  property BarrelShiftPipelineCheck_p;
    logic [WIDTH-1 : 0]in; logic [muxNum-1:0] shiftamount; logic shiftin;
    @(posedge Clock)
    if (!$isunknown(In)) //If value is unknown, clock for assertion will be wrongly interpreted
      (1, in = In, shiftamount = ShiftAmount, shiftin = ShiftIn) ##5 (Out == (ExpectedBarrelResult(in, shiftamount, shiftin))) ##0 Display(in, shiftamount, shiftin, Out);
  endproperty

  BarrelShiftPipelineCheck_a : assert property(BarrelShiftPipelineCheck_p)
    else $error("Barrel shift violation");

endmodule









