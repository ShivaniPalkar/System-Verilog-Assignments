////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 Extra Credit
//DESIGN: AddSubTb coverage
/////////////////////////////////////////////////////////////////////////////////////////////////////

module top;

  parameter testcases = 50;

  integer A, B;
  parameter NBITS = 8;
  reg [NBITS-1:0] x, y;
  reg sub;
  wire [NBITS-1:0] DUTResult;

  AddSub8Bit DUT(DUTResult, x, y, DUTCCN, DUTCCZ, DUTCCV, DUTCCC, sub);
 
  int totalcases;


  covergroup conditioncodes with function sample(bit DUTCCN, DUTCCZ, DUTCCV, DUTCCC, sub);

    negative : coverpoint DUTCCN
    {
      bins bin1Zero = { [ 0 :1 ] };
    }

    zero : coverpoint DUTCCZ
    {
      bins bin2 = { [ 0 : 1 ] };
    }

    overflow : coverpoint DUTCCV
    {
      bins bin3 = { [ 0 : 1 ] };
    }

    carry : coverpoint DUTCCC
    {
      bins bin4 = { [ 0 : 1 ] };
    }
    
    SUBinput : coverpoint sub
    {
      bins bin5 = { [ 0 : 1 ] };
    }
    
    subCCN: cross  negative, SUBinput;
    subCCZ: cross zero, SUBinput;
    subCCV: cross overflow, SUBinput;
    subCCC: cross carry, SUBinput;


  endgroup

  class AdderSubtractorStimulus;

    rand reg[NBITS-1:0] A,B;
    rand reg CI;

    function int TotTestcases( int count);
      count = count +1;
      return(count);
    endfunction

  endclass

  initial

    begin
      static AdderSubtractorStimulus obj = new; // object
      static int coverage;
      
      static conditioncodes cc = new();
      static int count = 0;


      for(int i = 0; i< testcases; i = i+1)
        begin


          do
            begin
              assert (obj.randomize());
              totalcases = obj.TotTestcases(totalcases);

              #1000;

             
              cc.sample(DUTCCN, DUTCCZ, DUTCCV, DUTCCC, sub);
              coverage = cc.get_coverage();
            
            end
          while(coverage<100);

        end

      `ifdef DEBUG
      $display("coverage = %d", coverage);
      $display("coverage for negative = %d",cc.negative.get_coverage());
      $display("coverage for zero = %d",cc.zero.get_coverage());
      $display("coverage for overflow = %d",cc.overflow.get_coverage());
      $display("coverage for carry = %d",cc.carry.get_coverage());

      
      $display("total testcases are: %d", totalcases);
      `endif
      $display("total testcases are: %d", totalcases);

    end

endmodule



