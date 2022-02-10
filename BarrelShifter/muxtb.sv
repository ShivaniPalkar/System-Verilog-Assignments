////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 4
//DESIGN: N bits 2:1 mux testbench
/////////////////////////////////////////////////////////////////////////////////////////////////////

module top();
  
  parameter DATAWIDTH = 32;
  
 logic [DATAWIDTH-1:0]D0, D1;
 logic Sel;
 wire [DATAWIDTH-1:0]Y;
  
   
   logic [DATAWIDTH-1:0]expectedY;
 
 parameter testcases = 200;
  
 integer i;
  
  MuxNbits dut(D0, D1, Sel, Y);
  
  initial begin
    
    for( i= 0; i < testcases; i= i+1)
      begin
       Sel = $random();
       D0 = $random();
       D1 = $random();
	
	
        if(Sel == 1)
          expectedY = D1;
        else
          expectedY = D0;
        
        #100
	
	  if(expectedY !== Y)
          	$display("***ERROR! expectedY = %b, Y = %b", expectedY, Y);

      end
    
  end
endmodule