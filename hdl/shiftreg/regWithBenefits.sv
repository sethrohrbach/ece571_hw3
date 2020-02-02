///////////////////////////////////////////////////////////
// regWithBenefits.sv - this module is a parameterized parallel load shift register.
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Version 1.0
// Last Updated: Jan 21 2020
//
// Description:
// This module is a simple parallel load register with parameterized width.
// Default width shall be 4 bits.
// Inputs:
// d - paralell input
// rst - asynchronous, asserted high. (priority 0)
// ck - system clock
// clr - synchronous clear (priority 1)
// shl - shifts the register contents left one bit. no overflow protection. serialIn shifted into lsb. (priority 3)
// ld - loads register with parallel d port input. serialIn ignored while asserted. (priority 2)
// When multiple control signals are asserted, only one takes effect in ascending order of priority (0 -> 3).
///////////////////////////////////////////////////////////

module regWithBenefits #(parameter W = 4)
  (
  input logic [W-1 : 0] d, //paralell load
  input logic rst, ck, clr, ld, shl, serialIn, //control signals
  output logic [W-1 : 0] q //data out
  );

  logic [W-1 : 0] internal_reg;

  always_ff @(posedge ck, posedge rst) //Include rst so it is asych
  begin
    if (rst) //if rst, we reset.
    q <= 0;
    else if (clr) //also clear if clr is asserted high, but not on sensitivty list so it should be synchronous. after rst as well so rst will take precedecent if asserted.
    q <= 0;
    else if (ld) //Else if ld is asserted, we load
    q <= d;
    else if (shl) //Else if shl, we do the shift.
    begin
      q <= q << 1;
      q[0] <= serialIn;
    end
    //I don't see anything to give to a default case. We only want something to happen if a control signal is asserted.
  end


endmodule
