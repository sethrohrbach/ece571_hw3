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

logic rst, ck, clr, ld, shl, serialIn;
logic [7:0] prl_load;
logic [7:0] data_out;


  regWithBenefits #(8) reg_DUT
  (
  .d(prl_load),
  .rst(rst),
  .ck(ck),
  .clr(clr),
  .ld(ld),
  .shl(shl),
  .serialIn(serialIn)
  .q(data_out)
  );

  always //Get that clock runnin
  begin
    #(CLK_PERIOD / 2) ck = ~ck;
  end

  always @(posedge ck) //A block for printing stuff so we can see its working.
  begin
    $strobe($time, "\t CONTROL SIGNALS = rst %b - clr %b - ld %b - shl %b\b\tDATA SIGNALS = PARALLEL LOAD: %b -- SERIAL IN: %b -- DATA OUT: %b\b", rst, clr, ld, shl, prl_load, serialIn, data_out);
  end


  initial //assert rst to begin.
  begin
    $display("Simulation starting...\n");
    rst = 1;
    #10 rst = 0;
    $display("Walking a 1 across the register.\n");
    serialIn = 1;
    shl = 1;
    #5 serialIn = 0;
    #80 shl = 0;
  end
