//////////////////////////////////////////////////////////
// SerialTOFED_cntr_2of5.sv - this module contains two counters to track a stream of bits and check for two-out-of-five code vailidity.
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Version: 1.1
// Last updated: Jan 21 2020
//
// Description:
// This module contains two counters. One counts how many bits have been sent
// (out of a string of 5), and the other counts how many of the bits in the current sequence have been
// logic high (1s).
// If the assigned code conditions are true, it sets output valid to TRUE for 1 clock cycle.
////////////////////////////////////////////////////////////

import SerialTOFEDDefs_2of5::*;

module SerialTOFED_cntr (
input clk, //Clock
input resetH, //Asynchronous, logic high reset
input din, //Data in
output bool_t valid //valid out
);

logic [2:0] bitCount, onesCount; //Counter variables


always_ff @(posedge clk)
begin
  if (resetH) //Check for reset
  begin
    bitCount <= 1;
    if (din == 1)
    onesCount <= 1;
    else
    onesCount <= 0;
  end

  else //Else not reset asserted, proceed with counter.
    begin
    if (bitCount < FBIBBLE_SIZE) //If we're under fbibble size, increment. check for 1.
      begin
      bitCount <= bitCount +1;
      if (din == 1)
        begin
          onesCount <= onesCount +1;
        end
      end

    else //else we're above fbibble size and we need to reset. resetting to 1 to fix off by one error I was having.
    begin
      bitCount <= 1;
      if (din == 1) //Don't forget to check if its a 1 still.
      begin
      onesCount <= 1;
      end
      else
      onesCount <= 0;
    end
  end
end

always_ff @(posedge bitCount)
begin
  //If code conditions are met, set output to true
  if (bitCount == FBIBBLE_SIZE && onesCount == ONESPERFBIBBLE)
  begin
  valid = TRUE;
  end
  else //Otherwise we will go to false on the next bit update which is also the next clock cycle per instructions.
  begin
  valid = FALSE;
end
end



endmodule
