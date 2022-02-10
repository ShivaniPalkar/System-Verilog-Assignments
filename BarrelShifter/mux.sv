////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 4
//DESIGN: N bits 2:1 mux
/////////////////////////////////////////////////////////////////////////////////////////////////////

module MuxNbits(D0, D1, Sel, Y);
  
  parameter DATAWIDTH = 32;
  
  input logic [DATAWIDTH-1:0]D0, D1;
  input logic Sel;
  output logic [DATAWIDTH-1:0]Y;
  
  
  assign #5 Y = (Sel) ? D1 : D0;
  
endmodule
  
