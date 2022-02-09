///////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 1
//DESIGN: BRAILLE DIGITS USING STRUCTURAL DESCRIPTION
///////////////////////////////////////////////////////

module BrailleDigits(BCD,w,x,y,z);
input [3:0]BCD;
output w,x,y,z;

wire W1,W2,W3,W4,W5,W6,W7,W8,W9,W10,W11;
wire [3:0]nBCD;

   
    //Creating ~BCD[0],BCD[1],BCD[2],BCD[3]
	      
     not #(10)  n1(nBCD[0],BCD[0]);
     not #(10)  n2(nBCD[1],BCD[1]);
     not #(10)	n3(nBCD[2],BCD[2]);
     not #(10)	n4(nBCD[3],BCD[3]);

   //Wire and gate connections
   
              
     and #(10) a1(W2, nBCD[3],nBCD[1],nBCD[0]);
     and #(10) a2(W4, W3, BCD[1]);
     and #(10) a3(W6,W5,BCD[3]);
     and #(10) a4(W7,nBCD[1],nBCD[0]);
     and #(10) a5(W8,BCD[2],BCD[0]);
     and #(10) a6(W9, BCD[3], BCD[1]);
     and #(10) a7(W10,nBCD[2],nBCD[0]);
     and #(10) a8(W11, BCD[2], BCD[1]);
   
               
     or #(10)  o1(w, W1,BCD[1],BCD[2]);
     or #(10)  o2(W3,BCD[3],BCD[2], BCD[0]);
     or #(10)  o3(W5,BCD[2],BCD[0]);
     or #(10)  o4(x,W2,W4,W6);
     or #(10)  o5(y,W7,W8,W9);
     or #(10)  o6(z,BCD[3],W10,W11);
   
		
     xor #(10) xor1(W1,BCD[3],BCD[0]);
		
endmodule: BrailleDigits
