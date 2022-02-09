////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 1
//DESIGN: BRAILLE DIGITS USING DATAFLOW DESCRIPTION
/////////////////////////////////////////////////////////////////////////////////////////////////////

module BrailleDigits(BCD,w,x,y,z);
input [3:0] BCD;
output w,x,y,z;
  
  assign w = (BCD[3]^BCD[0]) | BCD[1] | BCD[2];
  
  assign x = ((~BCD[3]) & (~BCD[1]) & (~BCD[0])) | (BCD[1] & (BCD[3] | BCD[2] | BCD[0])) | (BCD[3] & (BCD[0] | BCD[2]));
  
  assign y = ((~BCD[1]) & (~BCD[0])) | (BCD[2] & BCD[0])  | (BCD[3] & BCD[1]);
  
  assign z = BCD[3] | ((~BCD[2]) & (~BCD[0])) | (BCD[2] & BCD[1]);
  
endmodule : BrailleDigits
    
   
