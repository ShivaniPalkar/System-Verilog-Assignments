module top();
  parameter BITS=8;

  logic [BITS-1:0]x, y;
  logic sub;
  wire [BITS-1:0]result;
  wire ccc, ccn, ccz, ccv;

  AddSub8Bit dut(.result(result), .ccv(ccv), .ccn(ccn), .ccc(ccc), .ccz(ccz), .x(x), .y(y), .sub(sub));

  logic [BITS:0]expectedresult;
  logic expectedccn;
  logic expectedccc;
  logic expectedccz;
  logic expectedccv;

  initial
    begin
      int i;
      //generate random values for testing      
      for(i=0;i<250;i++)
        begin
          x= $random();
          y= $random();
          sub= $random();

          #10
          expectedresult = (sub) ? (x-y) : (x+y);
          
          expectedccz= (expectedresult== '0) ? 1'b1 : 1'b0;  //if all bits of result are 0, raise ccz
          
          expectedccn= (sub && (x < y)) ? 1'b1 : 1'b0;  //if subtraction and y is greater than x, raise ccn
          
          expectedccv= ( (x[BITS-1] && y[BITS-1] && !expectedccc) || (!x[BITS-1] && !y[BITS-1] && ccc)) ? 1'b1 : 1'b0; //overflow when msb of result opposite of MSBs of both operands

          if(!sub && expectedresult[BITS])
            expectedccc = 1'b1;
          if(!sub && !expectedresult[BITS])
            expectedccc = 1'b0;
          if ((sub && (x<y) && expectedresult[BITS]))
            expectedccc = 1'b0;
          if ((sub && (x>y) && !expectedresult[BITS]) || (sub && (x==y)))
            expectedccc = 1'b1;
          
          //Error messages
          if(expectedresult[7:0] !== result)
            $display($time , ": ***ERROR : x = %0d, y = %0d, sub = %0d, result = %0b, expectedResult = %0b", x, y, sub, result, expectedresult);

          if(expectedccz !== ccz)
            $display($time , ": ***ERROR : x = %0d, y = %0d, sub = %0d, ccz = %0b, expectedccz = %0b", x, y, sub, ccz, expectedccz);

          if(expectedccc !== ccc)
            $display($time , ": ***ERROR : x = %0d, y = %0d, sub = %0d, ccc = %0b, expectedccc = %0b", x, y, sub, ccc, expectedccc);

          if(expectedccn !== ccn)
            $display($time , ": ***ERROR : x = %0d, y = %0d, sub = %0d, ccn = %0b, expectedccn = %0b", x, y, sub, ccn, expectedccn);

          if(expectedccv !== ccv)
            $display($time , ": ***ERROR : x = %0d, y = %0d, sub = %0d, ccv = %0b, expectedccv = %0b", x, y, sub, ccv, expectedccv);

        end  


    end
endmodule

