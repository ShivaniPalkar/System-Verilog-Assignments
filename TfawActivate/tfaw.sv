
////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 7
//DESIGN: Tfaw assertion
/////////////////////////////////////////////////////////////////////////////////////////////////////

module TFAWChecker(Clock, Reset, ACT);

  localparam MAXACT = 4;
  localparam TFAW = 10;

  input logic Reset;
  input logic Clock;
  input logic ACT;

  //CREATING A DYNAMIC ARRAY FOR INPUT STIMULUS
  bit stimulus[];

  initial
    begin
      Clock = 1;
      forever #(5) Clock = ~Clock;
    end


  initial
    begin

      @(negedge Clock)
      Reset = 1'b1;
      @(negedge Clock)
      Reset = 1'b0;

      stimulus = '{1,0,1,1,1,0,0,0,0,1,
                   1,0,1,1,1,0,0,0,0,0,
                   0,1,1,0,0,1,0,0,0,0,
                   0,1,0,0,1,0,0,0,0,0,
                   1,1,1,1,1,1,0,0,0,0,
		   0,0,0,0,0,0,0,0,0,1};

      
      //assigning input stimulus to ACT
      foreach (stimulus[i])
        begin
          @(negedge Clock)
          begin
            ACT = stimulus[i];
           $display($time," ACT = %b", ACT);
          end

        end
      repeat(1) @(negedge Clock);
      $finish();
    end 
    

    //Creating a sequence for clock cycles equal to TFAW value and intersecting with another sequence which has ACT as true between 0 to MAXACT number
   // Property asserted and sequences begin whenever an ACT is encuntered as true
    property TFAWcheck_p;
    @(posedge Clock)
    disable iff(Reset)
    	ACT |=> ( (1[*(TFAW-1)]) intersect (ACT[=0:(MAXACT-1)]) );
    endproperty  
    	TFAWcheck_a: assert property(TFAWcheck_p)
      	else $error($time," TFAW Violation");
    
endmodule