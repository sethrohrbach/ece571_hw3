////////////////////////////////////////////////////////////////////////
// tb_rwb.sv - test bench for regWithBenefits
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Version 1.0
// Last updated Feb 1 2020
//
// Description:
// This is the test bench for the parallel shift register regWithBenefits
// For Portland State University ECE571 HW#3
/////////////////////////////////////////////////////////////////////////



module test_rwb;

parameter CLK_PERIOD = 10;
parameter WIDTH = 8;

bit rst = 1'b0;
bit ck = 1'b0;
bit clr = 1'b0;
bit ld = 1'b0;
bit shl = 1'b0;
bit serialIn = 1'b0;
logic [WIDTH-1:0] prl_load;
logic [WIDTH-1:0] data_out;


regWithBenefits #(WIDTH)reg_DUT
(
  .d(prl_load),
  .rst(rst),
  .ck(ck),
  .clr(clr),
  .ld(ld),
  .shl(shl),
  .serialIn(serialIn),
  .q(data_out)
);

  always //Get that clock runnin
  begin
    #(CLK_PERIOD / 2) ck = ~ck;
    //$strobe($time, "CONTROL SIGNALS = rst %b - clr %b - ld %b - shl %b\n\tDATA SIGNALS = PARALLEL LOAD: %b -- SERIAL IN: %b -- DATA OUT: %b\n", rst, clr, ld, shl, prl_load, serialIn, data_out);
  end

  always @(posedge ck)
  begin
    $strobe($time, "CONTROL SIGNALS = rst %b - clr %b - ld %b - shl %b\n\tDATA SIGNALS = PARALLEL LOAD: %b -- SERIAL IN: %b -- DATA OUT: %b\n", rst, clr, ld, shl, prl_load, serialIn, data_out);
end


  initial //assert rst to begin.
  begin
    $display("Simulation starting...\n");
    prl_load = 0;
    rst = 1'b1;
    #10 rst = 0;
    $display("Walking a 1 across the register.\n");
    serialIn = 1;
    shl = 1;
    #10 serialIn = 0;
    #80 shl = 0;
    $display("Asserting clr..\n");
    #100 clr = 1;
    #20 clr = 0;
    #20 prl_load = 8'b10101010;
    $display("Loading 0xAA\n");
    ld = 1;
    #10 ld = 0;
    #50 shl = 1;
    $display("Shifting it out... loading nothing in.\n");
    #70 shl = 0;
    #10 clr = 1;
    rst = 1;
    ld = 1;
    shl = 1;
    prl_load = 8'b11111111;
    $display("Asserting all the things so we can see that reset takes precedence.\n");
    #100 $stop;

    $display("Simulation concluded!\n");
    //$stop;
  end

endmodule
