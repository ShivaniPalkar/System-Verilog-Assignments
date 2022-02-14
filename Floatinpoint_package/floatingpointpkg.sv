////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 5 ; Problem 2
//DESIGN: Floating point package
/////////////////////////////////////////////////////////////////////////////////////////////////////
package floatingPoint;

localparam NEXPONENTBITS = 5;
localparam NFRACTIONBITS = 10;

//creating a struct for new datatype: halffloat
typedef struct{ bit sign;
               bit [NEXPONENTBITS-1:0] exp;
               bit [NFRACTIONBITS-1:0] frac;
              }halffloat;


// construct a floating point number from components

function halffloat fpnumberfromcomponents(input bit sign, bit [NEXPONENTBITS-1:0] exp, bit [NFRACTIONBITS-1:0] frac);
                                       
  halffloat halffloat_number;
  halffloat_number.sign = sign;
  halffloat_number.exp = exp;
  halffloat_number.frac = frac;

  return halffloat_number;
endfunction

// return true (1) if f is zero, false (0) otherwise
function bit iszero(halffloat f);
  if( !f.exp && !f.frac)
    return 1;
  else
    return 0;
endfunction

// return true(1) if f is a denormalized number, false (0) otherwise
function bit isdenorm(halffloat f);
  if(!f.exp && f.frac)
    return 1;
  else
    return 0;
endfunction

// print a floating point number's components (sign, exponent,fraction)
function void printfp(halffloat f);
  $display("Sign bit is = %b, exponent bits = %b, fraction bits = %b", f.sign, f.exp, f.frac);
endfunction


endpackage


