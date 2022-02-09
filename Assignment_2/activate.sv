//////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 2
//DESIGN: Activate.sv
/////////////////////////////////////////////////////

module ActivationWindow
  # (parameter WIDTH = 10, ACT_CMD = 4)
  (
    input logic Clock, Reset, ACTREQ,
    output logic ACTOK
  );

  //internal signals 
  logic [WIDTH-1:0] OP;
  int ACT_CNT;

  always_ff @(posedge Clock, negedge Reset)
    begin

      if(!Reset)
        begin
          OP <= '0;
          ACTOK <= 1'b0;
          ACT_CNT <= '0;
        end

      else begin

        case (ACTREQ)


          1'b0: // No new ACTREQ

            // If no. of ACT commands <5, but no act requests, shift in a 0 and reduce count of 1s if an ACT CMD shifted out, ACTOK=1
            begin 

              OP <= {OP[WIDTH-2:0],ACTREQ};
              
              ACT_CNT <= ((ACT_CNT <= ACT_CMD) && (OP[WIDTH-1] == 1'b1)) ? (ACT_CNT - 1'b1) : (ACT_CNT);
              ACTOK <= (ACT_CNT < ACT_CMD) ? 1'b1 : 1'b0;

            end

          1'b1: //New ACTREQ asserted

            begin

              // ACTREQ =1, NO OF ACT commands < 5, shift in 1
              if ((ACT_CNT < ACT_CMD) && (OP[WIDTH-1] == 1'b0))
                begin ACTOK <= 1'b1;
                  
                  OP <= {OP[WIDTH-2:0],ACTREQ};
                  ACT_CNT <= ACT_CNT + 1'b1 ; 
                end

              // ACTREQ = 1, No of ACT commands <5, shift in 1 and shift out 1
              else if((ACT_CNT <= ACT_CMD) && (OP[WIDTH-1] == 1'b1)) 
                begin
                  ACTOK <= 1'b1;
                  OP <= {OP[WIDTH-2:0],ACTREQ};
                  ACT_CNT <= ACT_CNT;
                end

              // ACTREQ=1, No. of 1s >5, TFAW violated, shift in 0
              else  
                begin
                  ACTOK <= 1'b0;
                  OP <= {OP[WIDTH-2:0],1'b0};
                  ACT_CNT <= ACT_CNT;

                end  
            end
        endcase
      end
    end
endmodule


