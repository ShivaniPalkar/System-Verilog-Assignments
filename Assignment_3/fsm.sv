module fsm(Clock, Reset, S1, S2, S3, L1, L2, L3);
input Clock;
input Reset;
input // sensors for approaching vehicles
S1, // Northbound on SW 4th Avenue
S2, // Eastbound on SW Harrison Street
S3; // Westbound on SW Harrison Street
output reg [1:0] // outputs for controlling traffic lights
L1, // light for NB SW 4th Avenue
L2, // light for EB SW Harrison Street
L3; // light for WB SW Harrison Street
  
  
  /*enum logic[1:0]{ GREEN = 2'b01,
  				   YELLOW = 2'b10,
                   RED = 2'b11
                 }glow;*/
  
  
  logic load;
  logic [7:0]value;
  logic decr;
  wire timeup;
  
  //Instantiating the given counter module
  counter down(.clk(Clock), .reset(Reset), .load(load), .value(value), .decr(decr), .timeup(timeup)); 
  
  
  //Assign values to states
  enum logic[8:0]{  	NB_green 			= 9'b000000001,
  						NBgreen_wait 		= 9'b000000010,
  						NB_yellow_load 		= 9'b000000100,
  						NB_yellow 			= 9'b000001000,
  					    NB_red 			    = 9'b000010000,
      					EB_WB_green 		= 9'b000100000,
						EB_WB_yellow_load   = 9'b001000000,  
                        EB_WB_yellow 		= 9'b010000000,
  						EB_WB_red           = 9'b100000000}
  						currentstate, nextstate;
  
  //update state or reset on every positive clock edge
  always @(posedge Clock)
    begin
      if(Reset)
        currentstate = NB_green;
      else
        currentstate = nextstate;
    end
  
  
  //Nextstate logic 
   always @(currentstate or S1 or S2 or S3 or timeup)
    begin
      
      case(currentstate)
      
      //Starting from 4th Avenue signal going green
      NB_green: 
      		begin
              load = 1'b0;
        		decr = 1'b1;
              if(timeup)
          			nextstate = NBgreen_wait;
              //else
                    //nextstate = NB_green;
               
      		end
      
      //wait till traffic on both Eastbound and Westbound SW Harrison
      NBgreen_wait: 
			begin
				if(!S1 && S2 || S3) 
         
         			nextstate = NB_yellow_load;
          		else 
            		nextstate = NBgreen_wait;
	
          		end
     
     //Start counter for 4th Avenue yellow
     NB_yellow_load: 
      		begin
            decr = 1'b0;
            load = 1'b1;
        	value = 4;   //transitioning to each state will take 1 clock cycle
            nextstate = NB_yellow;
            end
      
      NB_yellow: 
			begin
            load = 1'b0;
        	decr = 1'b1;
              if(timeup)
          			nextstate = NB_red;
              else
                    nextstate = NB_yellow;                 
			  end
      
      //4th Avenue signal red & also acts as load state for Harrison street green
      NB_red: 
        	begin
              decr = 1'b0;
              load = 1'b1;
              value = 14;
              nextstate = EB_WB_green;
        	end
      
      EB_WB_green: 
			  begin
               load = 1'b0;
               decr = 1'b1;
                if(timeup)
              
                  nextstate = EB_WB_yellow_load;
                else
                  nextstate = EB_WB_green;
        	  
               end
      
      EB_WB_yellow_load:
      		 begin
               decr = 1'b0;
               load = 1'b1;
               value = 4;   //transitioning to each state will take 1 clock cycle
               nextstate = EB_WB_yellow;
             end
      
      EB_WB_yellow: 
               begin
                  load = 1'b0;
                  decr = 1'b1;
                  if(timeup)
                    nextstate = EB_WB_red;
                  else
                    nextstate = EB_WB_yellow;
               end
        
      EB_WB_red:
          	   begin
                 decr = 1'b0;
                 load = 1'b1;
                 value = 44;  //transitioning to each state will take 1 clock cycle
                 nextstate = NB_green;
            
          	   end
      
      endcase
    end
  
  //output logic
  always @(currentstate)
    begin
      
      case (currentstate)
        
          NB_green:
          begin //L1:GREEN, L2: RED L3: RED
            L1 = 2'b01;
            L2 = 2'b11;
            L3 = 2'b11;
          end
        
        NBgreen_wait:
          begin //L1:GREEN, L2: RED L3: RED
          	L1 = 2'b01;
            L2 = 2'b11;
            L3 = 2'b11;  
          end
        
        NB_yellow_load: 
          begin //L1:YELLOW, L2: RED L3: RED
            L1 = 2'b01;
            L2 = 2'b11;
            L3 = 2'b11; 
          end
        
        NB_yellow:
          begin //L1:YELLOW, L2: RED L3: RED
            L1 = 2'b10;
            L2 = 2'b11;
            L3 = 2'b11;
          end
        
        NB_red:
          begin //L1:RED, L2: RED L3: RED
          	L1 = 2'b11;
            L2 = 2'b11;
            L3 = 2'b11;
          end
        
        
        EB_WB_green:
          begin //L1:RED, L2: GREEN L3: GREEN
            L1 = 2'b11;
            L2 = 2'b01;
            L3 = 2'b01;
          end
        
        EB_WB_yellow_load:
          begin
            L1 = 2'b11;
            L2 = 2'b01;
            L3 = 2'b01;  
          end
        
        EB_WB_yellow:
          begin //L1:RED, L2: YELLOW L3: YELLOW
            L1 = 2'b11;
            L2 = 2'b10;
            L3 = 2'b10;
          end
        
        EB_WB_red:
          begin
            L1 = 2'b11;
            L2 = 2'b11;
            L3 = 2'b11;
          end
        
        
      endcase
      
      
      
    end
endmodule
  
