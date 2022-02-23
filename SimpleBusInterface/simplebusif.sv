////////////////////////////////////////////////////////////////////////////////////////////////////
//PSU ID: 920177877, SHIVANI PALKAR, spalkar@pdx.edu
//ECE571 HOMEWORK 6
//DESIGN: Simple Bus Interface
/////////////////////////////////////////////////////////////////////////////////////////////////////

module top;

  parameter NUMMEM = 20;
  logic clock = 1;
  logic resetN = 0;
  tri dataValid, start, read;
  tri [7:0] data, address;

  always #5 clock = ~clock;

  initial #2 resetN = 1;

  simpleBus main(clock, resetN);
  ProcessorIntThread #(NUMMEM) dut1(main.ProcessorIntThread);

  genvar i;
  generate

    for(i = 0; i < NUMMEM; i = i+1)
      begin
        MemoryIntThread #(i) dut2(main.MemoryIntThread);
      end
  endgenerate;

endmodule

interface simpleBus(input logic clock, resetN);

  wire dataValid;
  logic start;
  logic read;
  wire [7:0] data;
  logic [7:0] address;

  modport ProcessorIntThread(
    input resetN, clock,
    output start, read,
    inout dataValid,
    output address,
    inout data);

  modport MemoryIntThread(   
    input resetN, clock,
    input start, read,
    inout dataValid,
    input address,
    inout data);


endinterface

module ProcessorIntThread (simpleBus.ProcessorIntThread port);
  parameter NUMMEM = 20;

  logic en_AddrSelect, en_AddrUp, en_AddrLo, ld_Data, en_Data, access = 0; //creating additional signal to load higher order 8 select bits
  logic doRead, wDataRdy, dv;
  logic [7:0] DataReg;
  logic [23:0] AddrReg;

  logic [7:0]thread;
  logic [15:0]i;
  logic [7:0]expectedDatareg;

  enum {MS,MA,MB,MC,MD} State, NextState;

  assign port.data = (en_Data) ? DataReg : 'bz;
  assign port.dataValid = (State == MD) ? dv : 1'bz;

  always_comb
    begin
      if (en_AddrLo) port.address = AddrReg[7:0];
      else if (en_AddrUp) port.address = AddrReg[15:8];
      else if (en_AddrSelect) port.address = AddrReg[23:16]; //loading the higher order select bits 
      else port.address = 'bz;
    end

  always_ff @(posedge port.clock)
    if (ld_Data) DataReg <= port.data;

  always_ff @(posedge port.clock, negedge port.resetN)
    if (!port.resetN) State <= MS;
  else State <= NextState;


  always_comb
    begin
      port.start = 0;
      en_AddrSelect = 0;
      en_AddrUp = 0;
      en_AddrLo = 0;
      port.read = 0;
      ld_Data = 0;
      en_Data = 0;
      dv = 0;

      case(State)
        MS:begin
          NextState = (access) ? MA : MS;
          port.start = (access) ? 1 : 0;
          en_AddrSelect = (access) ? 1 : 0;
          end
        MA:begin
           NextState = MB;
           en_AddrUp = 1;
           end
        MB:begin
           NextState = (doRead) ? MC : MD;
           en_AddrLo = 1;
           port.read = (doRead) ? 1 : 0;
           end
        MC:begin
           NextState = (port.dataValid) ? MS : MC;
           ld_Data = (port.dataValid) ? 1 : 0;
           end
        MD:begin
           NextState = (wDataRdy) ? MS : MD;
           en_Data = (wDataRdy) ? 1 : 0;
           dv = (wDataRdy) ? 1 : 0;
           end
      endcase
    end

  task WriteMem(input [23:0] Avalue, input [7:0] Dvalue);   
    begin
      access <= 1;
      doRead <= 0;
      wDataRdy <= 1;
      AddrReg <= Avalue;
      DataReg <= Dvalue;
      @(posedge port.clock) access <= 0;
      @(posedge port.clock);
      wait (State == MS); 
      repeat (2) @(posedge port.clock);
    end
  endtask


  task ReadMem(input [23:0] Avalue);   
    begin
      access <= 1;
      doRead <= 1;
      wDataRdy <= 0;
      AddrReg <= Avalue;
      @(posedge port.clock) access <= 0;
      @(posedge port.clock);
      wait (State == MS); 
      repeat (2) @(posedge port.clock);
    end
  endtask


  initial
    begin
      repeat (2) @(posedge port.clock);
      // Note this is from the textbook but is *not* a good test!!
      /*
      @(posedge port.clock)WriteMem(24'h000000, 8'hDC);
      @(posedge port.clock)WriteMem(24'h040000, 8'hAB);
      @(posedge port.clock)ReadMem(24'h100000);
      @(posedge port.clock)WriteMem(24'h030000, 8'hAB);
      @(posedge port.clock)ReadMem(24'h000000);
      @(posedge port.clock)ReadMem(24'h000000);
      @(posedge port.clock)ReadMem(24'h000000);
      @(posedge port.clock)ReadMem(24'h000000);
      @(posedge port.clock)ReadMem(24'h030000);
      @(posedge port.clock)ReadMem(24'h030000);
      @(posedge port.clock)ReadMem(24'h030000);
      @(posedge port.clock)ReadMem(24'h030000);
      */

      //Self checking logic: assign values of memory locations in ascending order and compare
      for(thread = 0; thread < NUMMEM ; thread = thread + 1)
        begin
          for(i = '0; i < 250; i= i+1)
            begin
              @(posedge port.clock) WriteMem({thread,i},250-i);
            end
        end

      @(posedge port.clock);

      for(thread = 0; thread < NUMMEM ; thread = thread + 1)
        begin
          for(i = '0; i < 250; i= i+1)
            begin
              @(posedge port.clock) ReadMem({thread,i});
              expectedDatareg = 250-i;
              if(DataReg !== expectedDatareg)
                $display("*****ERROR:address register = %h, data register = %h, expectedDatareg = %h", {thread,i}, DataReg, expectedDatareg);
            end
        end

      $finish;
    end

endmodule





module MemoryIntThread(simpleBus.MemoryIntThread port);

  parameter BASEADDRESS = 5;

  logic [7:0] Mem[16'hFFFF:0], MemData;
  logic found, ld_AddrUp, ld_AddrLo, memDataAvail = 0;
  logic en_Data, ld_Data, dv;
  logic [7:0] DataReg;
  logic [15:0] AddrReg;

  enum {SS, SA, SB, SC, SD} State, NextState;


  initial
    begin
      for (int i = 0; i < 16'hFFFF; i++)
        Mem[i] <= 0;
    end


  assign port.data = (en_Data) ? MemData : 'bz;
  assign port.dataValid = (State == SC) ? dv : 1'bz;
  assign found = (BASEADDRESS == port.address) ? 1 : 0; //comparison logic for memory modules alongwith assertion of start signal 


  always @(AddrReg, ld_Data)
    MemData = Mem[AddrReg];

  always_ff @(posedge port.clock)
    if (ld_AddrUp) AddrReg[15:8] <= port.address;

  always_ff @(posedge port.clock)
    if (ld_AddrLo) AddrReg[7:0] <= port.address;

  always @(posedge port.clock)
    begin
      if (ld_Data)
        begin
          DataReg <= port.data;
          Mem[AddrReg] <= port.data;
        end
    end

  always_ff @(posedge port.clock, negedge port.resetN)
    if (!port.resetN) State <= SS;
  else State <= NextState;

  always_comb
    begin
      ld_AddrUp = 0;
      ld_AddrLo = 0;
      dv = 0;
      en_Data = 0;
      ld_Data = 0;

      case (State)
        SS:begin
          NextState = (port.start & found) ? SA : SS;
          end
        SA:begin
          NextState = SB;
          ld_AddrUp = 1;
          end
        SB:begin
           NextState = (port.read) ? SC : SD;
           ld_AddrLo = 1;
           end
        SC:begin
           NextState = (memDataAvail) ? SS : SC;
           dv = (memDataAvail) ? 1 : 0;
           en_Data = (memDataAvail) ? 1 : 0;
           end
        SD:begin
           NextState = (port.dataValid) ? SS: SD;
           ld_Data = (port.dataValid) ? 1 : 0;
           end
      endcase
    end

  // *** testbench code
  always @(State)
    begin
      bit [2:0] delay;
      memDataAvail <= 0;
      if (State == SC)
        begin
          delay = $random;
          repeat (2 + delay)
            @(posedge port.clock);
          memDataAvail <= 1;
        end
    end

endmodule