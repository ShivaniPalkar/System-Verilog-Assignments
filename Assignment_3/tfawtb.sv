module top();
  parameter TFAW = 10;
  parameter ACT_CMD = 4;
  parameter testcases = 1000;


  logic Clock, Reset, ACTREQ, expectedACTOK;
  wire ACTOK;
  
  //Internal wires
   logic ACTREQ_count = 0;
   logic TFAW_count = 0;
  
 //Instantiate the module
  ActivationWindow dut(.Clock(Clock), .Reset(Reset), .ACTREQ(ACTREQ), .ACTOK(ACTOK));

  initial 
    begin 
      Clock = 1'b0;
      forever #5 Clock = ~Clock;
    end 

  initial 
    begin //Initialise reset

      @(negedge Clock) Reset <= 1'b0;
      @(negedge Clock) Reset <= 1'b1;

      //Check for consecutive ACTREQ and check for erronous permission of ACKOK
      for (int i=0; i<=testcases; i=i+1)
        begin
          @(negedge Clock) 
          begin
            if(ACTOK !== expectedACTOK) 
              $display($time , "***ERROR : ACTREQ = %0b, ACTOK = %0b, expectedACTOK = %0b", ACTREQ, ACTOK, expectedACTOK);
          end
        end
  
      #100
      $finish;
    end

 //Golden module
always_ff @(posedge Clock, negedge Reset)
    begin
      
      int i; 
      int j;
          
      ACTREQ <= $random();  //generate random ACTREQ
      if(!Reset) begin
        ACTREQ_count <= '0;
      	TFAW_count = '0;
      end
      
      else
        begin //Compare if number of ACT commands issued <=4 and allow the following ACTCMD to be issued
          
          for( i = 0; i <= testcases; i = i+1)
		 	begin
        
      
              for( j= 0; j <= TFAW ; j = j+1)
				begin
					if(ACTREQ)
          			begin
                      if  ((ACTREQ_count <= ACT_CMD) && TFAW_count <= TFAW)
						begin
                          		expectedACTOK <= 1'b1;
								ACTREQ_count = ACTREQ_count + 1'b1;
                        end
                      else if (ACTREQ_count >= 4 && TFAW_count <= TFAW)
                       
							    expectedACTOK <= 1'b0;
				
                      else if (ACTREQ_count >= 4 && TFAW_count >= TFAW) 
								expectedACTOK <= 1'b0;
                      
					end
                ACTREQ_count <= ACTREQ_count - 1'b1;
				TFAW_count <= TFAW_count - 1'b1;
              end
              //ACTREQ_count <= ACTREQ_count - 1'b1;
			  //TFAW_count <= TFAW_count - 1'b1;
		 end
          
       end
    end
 
endmodule
