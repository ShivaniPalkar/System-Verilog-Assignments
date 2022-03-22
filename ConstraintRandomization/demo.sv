////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 8
//DESIGN: Demo - package halffloat
/////////////////////////////////////////////////////////////////////////////////////////////////////

module top();
  
  //importing the package
  import floatingPoint ::*;

  parameter testcases = 200;
  parameter WIDTH = 16;
  localparam NEXPONENTBITS = 5;
  localparam NFRACTIONBITS = 10;

  bit Sign;
  bit [NEXPONENTBITS-1:0] exponent;
  bit [NFRACTIONBITS-1:0] fraction;


  int totalTestcases;
  int denormTestcases;
  bit [WIDTH-1:0] halfFloat;

  logic randSuccessful;
  int chooseContraint;

  halffloat obj = new(); //creating a new object of class halffloat

  initial
    begin



      for(int i = 0; i< testcases; i = i+1)
        begin
          
          //Disabling all constraints
          obj.DenormOnly.constraint_mode(0);
          obj.NormDenorm.constraint_mode(0);
          obj.NormOnly.constraint_mode(0);

          chooseContraint = $urandom_range(1,3);
          
          if(chooseContraint == 1)
            obj.NormOnly.constraint_mode(1);
          else if(chooseContraint == 2)
            obj.DenormOnly.constraint_mode(1);
          else if(chooseContraint == 3)
            obj.NormDenorm.constraint_mode(1);

          //randomizing variables and checking if successful
          randSuccessful = obj.randomize();
          if(randSuccessful)
            
            begin
              
              //call function to count total testcases
              totalTestcases = obj.TotTestcases(totalTestcases);
              
              //call function to count total denormalised testcases
              denormTestcases = obj.TotDenormCases(denormTestcases);
              
              //call method to display the 16 bit floating point
              halfFloat = obj.halfFloatNumber(Sign,exponent,fraction);
              $display("%b", halfFloat);
              
            end
          
        end
      $display("Total testcases = %0d", totalTestcases);
      $display("Total dernomalised testcases = %0d", denormTestcases);
      
      
    end
endmodule


