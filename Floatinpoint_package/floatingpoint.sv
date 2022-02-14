////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 5 ; Problem 2
//DESIGN: Package test
/////////////////////////////////////////////////////////////////////////////////////////////////////

module top();

  localparam NEXPONENTBITS = 5;
  localparam NFRACTIONBITS = 10;  

  import floatingPoint ::*; //importing package

  //declaring variables with respective datatypes for return values
  halffloat result;
  bit isZero, isDenorm;


  bit sign;
  bit [NEXPONENTBITS-1:0] exp;
  bit [NFRACTIONBITS-1:0] frac;


  initial 
    begin

      sign = 1;
      exp = 5;
      frac = 10;
      #10;
    


      sign = 0;
      exp = 0;
      frac = 0;
      #10;
     

      sign = 1;
      exp = 0;
      frac = 21;
      #10;
     

      sign = 0;
      exp = 0;
      frac = 256;
      #10;
     
      
      sign = 1;
      exp = 0;
      frac = 4095;
      #10;
      
      sign = 1;
      exp = 50;
      frac = 2049;
      #10;
      
      
      sign = 1;
      exp = 31;
      frac = 4095;
      #10;
      
    end

	always @(sign,exp,frac)
        begin
          result = fpnumberfromcomponents(sign,exp,frac);
          printfp(result);
          isZero = iszero(result);
          $display("Floating point zero = %b", isZero);
          isDenorm = isdenorm(result); 
          $display("Floating point denormalized = %b", isDenorm);
        end

endmodule