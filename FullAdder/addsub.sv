module AddSub8Bit (result, x, y, ccn, ccz, ccv, ccc, sub);

  parameter BITS=8;

  input logic [BITS-1:0] x;
  input logic [BITS-1:0] y;
  input logic sub;
  output logic [BITS-1:0] result;
  output logic ccn, ccz, ccv, ccc;


  wire [BITS:0]c; //internal couts and cin connections
  logic [BITS-1:0]localY; //local Y for subtraction selection
  logic checkNeg;

  genvar i;
  generate
    for (i=0;i<BITS;i=i+1)
      fulladder FA(result[i],c[i+1],x[i],localY[i],c[i]);
  endgenerate

  genvar j;
  generate
    for(j=0;j<BITS;j=j+1)
      begin
        xor xorY(localY[j],y[j],sub);
      end
  endgenerate

  //condition for zero flag
  nor
  nor1 (ccz, result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7]);

  and

  a1(c[0], sub, 1'b1),
  a2(ccc, c[BITS], 1'b1),
  a3(checkNeg, sub, c[BITS]);


  //xoring last carry out with previous carry out for overflow
  xor
  xor1(ccv, c[BITS], c[BITS-1]),
  xor2(ccn, checkNeg, sub);
  
endmodule