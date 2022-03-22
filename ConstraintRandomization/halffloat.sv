////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 8
//DESIGN: Package Halffloat
/////////////////////////////////////////////////////////////////////////////////////////////////////

package floatingPoint;

	parameter WIDTH = 16; 
	localparam NEXPONENTBITS = 5,
	NFRACTIONBITS = 10;

	//declaring stativ variables to be used in methods
 	static int track = 0;
	static int count = 0;
	static bit [WIDTH-1:0] stream;

class halffloat;

  rand bit sign;
  rand bit [NEXPONENTBITS-1:0] exponent;
  rand bit [NFRACTIONBITS-1:0] fraction;


  //constraints
  
  //exponent bits range from 00001 to 11110 (including zero)
  constraint NormOnly { exponent inside {[0 : ((2**NEXPONENTBITS)-2)]}; } 

  //exponent bits all 0s and fraction from 0000000001 to all 1s
  constraint DenormOnly {exponent == '0;      
                         !(fraction == '0);} 

  //exponent bits from 00001 to 11110 and all fraction combinations (including zero)
  constraint NormDenorm { exponent inside {[0 : ((2**NEXPONENTBITS)-2)]}; } 

  function void pre_randomize ();
    $display ("The half float generated is:");
  endfunction

 
  //method to report total number of testcases generated
  function int TotTestcases( int count);
    
    count = count +1;
    return(count);
    
  endfunction

  //method to report total number of denormalised testcases generated
  function int TotDenormCases(int track);

    if (this.exponent == 0 && this.fraction != 0)
      track = track +1; //denormTestcases = TotDenormCases(exponent, fraction)
    return(track);
    
  endfunction

  //method to return 16 bit constructed half precision floating point
  function automatic bit[WIDTH-1:0] halfFloatNumber(bit sign, bit [NEXPONENTBITS-1:0] exp, bit [NFRACTIONBITS-1:0] frac);
    
    stream = { >> {this.sign, this.exponent, this.fraction}};
    return(stream);
    
  endfunction


endclass
endpackage