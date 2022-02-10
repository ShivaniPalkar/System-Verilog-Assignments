module top();
logic Clock;
logic Reset;
logic // sensors for approaching vehicles
S1, // Northbound on SW 4th Avenue
S2, // Eastbound on SW Harrison Street
S3; // Westbound on SW Harrison Street
wire [1:0] // outputs for controlling traffic lights
L1, // light for NB SW 4th Avenue
L2, // light for EB SW Harrison Street
L3; // light for WB SW Harrison Street
  
  
  parameter clock_cycle = 10;
  parameter clock_width = clock_cycle/2;
  parameter idle_clocks = 1;
  
  fsm dut(Clock, Reset, S1, S2, S3, L1, L2, L3);
  
  //setting up monitor
  	initial begin
      
      #10;
     $display("               TIME   S1   S2  S3   L1   L2   L3                   currentstate                        nextstate");
      $monitor($time, "   %b   %b   %b   %b   %b   %b                      %s                        %s", S1, S2, S3, L1, L2, L3, dut.currentstate.name, dut.nextstate.name);
    end
      
      
  
  //free running clock
    initial begin
    Clock = 1'b0;
    forever #clock_width Clock = ~Clock;
    end 
  
  	initial begin
    Reset = 1'b1;
      repeat (idle_clocks) @(negedge Clock);
    Reset = 1'b0;
    end
  
     initial begin
       
      @(negedge Clock)
       {S1,S2,S3} = 3'b100;
       #10;
      @(negedge Clock)
       {S1,S2,S3} = 3'b010; 
 	#10;      
       @(negedge Clock)
       {S1,S2,S3} = 3'b001;  
 	#10;
       @(negedge Clock)
       {S1,S2,S3} = 3'b100;  
	#10;     
     @(negedge Clock)
       {S1,S2,S3} = 3'b011;
 	#10;
      @(negedge Clock)
       {S1,S2,S3} = 3'b100;
 	#10;
      @(negedge Clock)
       {S1,S2,S3} = 3'b101;
 	#10;
      @(negedge Clock)
       {S1,S2,S3} = 3'b110;
 	#10;
      @(negedge Clock)
       {S1,S2,S3} = 3'b111;
      #500;
       $stop;
    end
                 
endmodule
      
    
    

  
  
  
  
  
  
