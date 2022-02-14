////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 5 ; Problem 1
//DESIGN: BarrelShifter Pipelined
/////////////////////////////////////////////////////////////////////////////////////////////////////

module BarrelShifter #(parameter DATAWIDTH = 32)(Clock, In, ShiftAmount, ShiftIn, Out);

  localparam muxNum = ($clog2(DATAWIDTH));//derived parameter for number of muxes to be instantiated

  input logic Clock;
  input logic [DATAWIDTH-1:0]In;
  input logic ShiftIn;
  input logic [muxNum-1:0]ShiftAmount;
  output logic [DATAWIDTH-1:0]Out;

  
  logic [DATAWIDTH-1:0] op [muxNum:0]; //creating a packed array to get 5 elements of 32 bits each

  
  // structure for pipeline buffer
  typedef struct{ logic [DATAWIDTH-1:0]In;
                  logic ShiftIn;
  		  logic [muxNum-1:0]ShiftAmount;
                 }pipelineBuffer;
  
  pipelineBuffer pipeline[muxNum-1:0];
  
  
          
  genvar i;
  
  
  //Instantiating the first mux
  MuxNbits #(DATAWIDTH) M1( In, {{In[0+:DATAWIDTH-(2**(muxNum-1))]}, {(2**(muxNum-1)){ShiftIn}}} , ShiftAmount[muxNum-1], op[0]);
  
   
    always @(posedge Clock)
    begin
      
      pipeline[0].In <= op[0];
      pipeline[0].ShiftIn <= ShiftIn;
      pipeline[0].ShiftAmount <= ShiftAmount;
      Out <= op[muxNum-1];
      
    end
  
  
  //For select lines: 2^(muxNum-1-i) eg 2^(5-1-0) = 2^4 thus Select input s4
  generate
    
 
    for(i = 0; i < muxNum-1; i = i+1) //generate 5 instances of 2:1 mux
      begin
        
        always @(posedge Clock)
    begin
      
      pipeline[i+1].In <= op[i+1];
      pipeline[i+1].ShiftIn <= pipeline[i].ShiftIn;
      pipeline[i+1].ShiftAmount <= pipeline[i].ShiftAmount; 
  
    end
        
        //If shift amount is 0, transfer input data as it is, if any select line is 1, left shift by amount specified for the mux using part select
        //pipeline instantiations
        MuxNbits #(DATAWIDTH) M( pipeline[i].In, {{pipeline[i].In[0+:DATAWIDTH-(2**(muxNum-2-i))]}, {(2**(muxNum-2-i)){pipeline[i].ShiftIn}}} , pipeline[i].ShiftAmount[muxNum-2-i], op[i+1]);
        
      end
  endgenerate

endmodule