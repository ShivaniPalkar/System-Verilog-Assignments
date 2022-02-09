/////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 1
//DESIGN: BRAILLE DIGITS TESTBENCH
////////////////////////////////////////////////////
module top();
	integer i;
	reg [3:0]BCD;
	wire w,x,y,z;
	reg expectedW,expectedX,expectedY,expectedZ;
  
	BrailleDigits dut(.BCD(BCD),.w(w),.x(x),.y(y),.z(z));
  
	initial 
	begin
                //Generate BCD input
		for( i=0;i<10; i=i+1)
		begin
			BCD = i;
         
			#100
			$display( " BCD= %b, w=%b,x=%b,y=%b,z=%b", BCD,w,x,y,z);
     
                        //Check erroneous outputs
			case(i)
	
			0:
			begin
			expectedW = 1'b0;
			expectedX = 1'b1;
			expectedY = 1'b1;
			expectedZ = 1'b1;
			end

			1:
			begin
			expectedW = 1'b1;
			expectedX = 1'b0;
			expectedY = 1'b0;
			expectedZ = 1'b0;
			end

			2:
			begin
			expectedW = 1'b1;
			expectedX = 1'b0;
			expectedY = 1'b0;
			expectedZ = 1'b1;
			end

			3:
			begin
			expectedW = 1'b1;
			expectedX = 1'b1;
			expectedY = 1'b0;
			expectedZ = 1'b0;
			end

			4:
			begin
			expectedW = 1'b1;
			expectedX = 1'b1;
			expectedY = 1'b1;
			expectedZ = 1'b0;
			end

			5:
			begin
			expectedW = 1'b1;
			expectedX = 1'b0;
			expectedY = 1'b1;
			expectedZ = 1'b0;
			end

			6:
			begin
			expectedW = 1'b1;
			expectedX = 1'b1;
			expectedY = 1'b0;
			expectedZ = 1'b1;
			end

			7:
			begin
			expectedW = 1'b1;
			expectedX = 1'b1;
			expectedY = 1'b1;
			expectedZ = 1'b1;
			end

			8:
			begin
			expectedW = 1'b1;
			expectedX = 1'b0;
			expectedY = 1'b1;
			expectedZ = 1'b1;
			end

			9:
			begin
			expectedW = 1'b0;
			expectedX = 1'b1;
			expectedY = 1'b0;
			expectedZ = 1'b1;
			end
     
			endcase

		#100

                //Notify erroneous outputs
		if (expectedW !== w) begin
		$display("***OOPS! Wrong dot raised: BCD no.:%0d, Expected w=%0d, received w = %0d", i, expectedW, w);
		end
		if (expectedX !== x) begin
		$display("***OOPS! Wrong dot raised: BCD no.:%0d, Expected x=%0d, received x = %0d", i, expectedX, x);
		end
		if (expectedY !== y) begin
		$display("***OOPS! Wrong dot raised: BCD no.:%0d, Expected y=%0d, received y = %0d", i, expectedY, y);
		end
		if (expectedZ !== z) begin
		$display("***OOPS! Wrong dot raised: BCD no.:%0d, Expected z=%0d, received z = %0d", i, expectedZ, z);
		end
     
		end    
       
	end
endmodule
    


