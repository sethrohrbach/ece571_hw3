//////////////////////////////////////////////////////////
// SerialTOFED_cntr_2of5.sv - this module is for a FSM version of a serial 2 of 5 code checker.
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Version: 1.0
// Last updated: Feb 2 2020
//
// Description:
// This module checks for valid 2-of-5 serial codes using a FSM design.
// For Portland State University ECE571 HW#3
//
////////////////////////////////////////////////////////////

import SerialTOFEDDefs_2of5::*;

module SerialTOFED_FSM (
input clk, //Clock
input resetH, //Asynchronous, logic high reset
input din, //Data in
output bool_t valid //valid out
);

state_t current_s;
state_t next_s;

//State update block:
always_ff @(posedge clk)
begin
  if (resetH)
  begin
    if (din)
    current_s = S_RST;
    else
    current_s = S_RST;
  end
  else begin
  current_s <= next_s;
  end
end


//Next state comb logic block:
always_comb
begin
  if (resetH) //Allow for asynchronous reset.
  next_s = S_RST;
  else
//Proceed with next state logic. hooo boy lots of states here we go.
  unique case (current_s)
    S1_0 : begin
            if (din)
            next_s = S2_1;
            else
            next_s = S2_0;
          end
    S1_1 : begin
            if (din)
            next_s = S2_2;
            else
            next_s = S2_1;
          end
    S2_0 : begin
            if (din)
            next_s = S3_1;
            else
            next_s = S3_0;
          end
    S2_1 : begin
            if (din)
            next_s = S3_2;
            else
            next_s = S3_1;
          end
    S2_2 : begin
            if (din)
            next_s = S3_3;
            else
            next_s = S3_2;
          end
    S3_0 : begin
            if (din)
            next_s = S4_1;
            else
            next_s = S4_0;
          end
    S3_1 : begin
            if (din)
            next_s = S4_2;
            else
            next_s = S4_1;
          end
    S3_2 : begin
            if (din)
            next_s = S4_3;
            else
            next_s = S4_2;
          end
    S3_3 : begin
            if (din)
            next_s = S4_4;
            else
            next_s = S4_3;
          end
    S4_0 : begin
            if (din)
            next_s = S5_1;
            else
            next_s = S5_0;
          end
    S4_1 : begin
            if (din)
            next_s = S5_2;
            else
            next_s = S5_1;
          end
    S4_2 : begin
            if (din)
            next_s = S5_3;
            else
            next_s = S5_2;
          end
    S4_3 : begin
            if (din)
            next_s = S5_4;
            else
            next_s = S5_3;
          end
    S4_4 : begin
            if (din)
            next_s = S5_5;
            else
            next_s = S5_4;
          end
    S5_0 : begin
            if (din)
            next_s <= S1_1;
            else
            next_s <= S1_0;
          end
    S5_1 : begin
            if (din)
            next_s = S1_1;
            else
            next_s = S1_0;
          end
    S5_2 : begin
            if (din)
            next_s = S1_1;
            else
            next_s = S1_0;
          end
    S5_3 : begin
            if (din)
            next_s = S1_1;
            else
            next_s = S1_0;
          end
    S5_4 : begin
            if (din)
            next_s = S1_1;
            else
            next_s = S1_0;
          end
    S5_5 : begin
            if (din)
            next_s = S1_1;
            else
            next_s = S1_0;
          end
    S_RST : begin
              if (din)
              next_s = S1_1;
              else
              next_s = S1_0;
            end
  endcase
end


//And finally, output logic block:
always_comb
begin
  if (current_s == S5_2)
  valid = TRUE;
  else
  valid = FALSE;
end

endmodule
