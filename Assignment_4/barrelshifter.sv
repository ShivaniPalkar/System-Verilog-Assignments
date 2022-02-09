////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 4
//DESIGN: BarrelShifter
/////////////////////////////////////////////////////////////////////////////////////////////////////

module BarrelShifter #(parameter DATAWIDTH = 32) (In, ShiftAmount, ShiftIn, Out);

  localparam muxNum = ($clog2(DATAWIDTH));//derived parameter for number of muxes to be instantiated


  input logic [DATAWIDTH-1:0]In;
  input logic ShiftIn;
  input logic [muxNum-1:0]ShiftAmount;
  output logic [DATAWIDTH-1:0]Out;


  logic [DATAWIDTH-1:0] op [muxNum:0]; //creating a packed array to get 5 elements of 32 bits each



  genvar i;

  assign op[0] = In;         //assign incoming 32 bit data to input of 1st mux
  assign Out = op[muxNum];   //assign output of last mux to Out


  //For select lines: 2^(muxNum-1-i) eg 2^(5-1-0) = 2^4 thus Select input s4
  generate
    for(i = 0; i < muxNum; i = i+1) //generate 5 instances of 2:1 mux
      begin
        //If shift amount is 0, transfer input data as it is, if any select line is 1, left shift by amount specified for the mux using part select
        MuxNbits #(DATAWIDTH) M( op[i], {{op[i][0+:DATAWIDTH-(2**(muxNum-1-i))]}, {(2**(muxNum-1-i)){ShiftIn}}} , ShiftAmount[muxNum-1-i], op[i+1]);

      end
  endgenerate

endmodule