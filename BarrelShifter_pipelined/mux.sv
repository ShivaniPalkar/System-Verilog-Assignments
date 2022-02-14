////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 5 ; Problem 1
//DESIGN: N BIT MUX
/////////////////////////////////////////////////////////////////////////////////////////////////////
module MuxNbits(D0, D1, Sel, Y); //2:1 mux for N bits
  
  parameter DATAWIDTH = 32;
  
  input logic [DATAWIDTH-1:0]D0, D1;
  input logic Sel;
  output logic [DATAWIDTH-1:0]Y;
  
  
  assign #5 Y = (Sel) ? D1 : D0;
  
endmodule
  
