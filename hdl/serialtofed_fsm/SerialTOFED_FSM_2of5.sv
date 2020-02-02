//////////////////////////////////////////////////////////
// SerialTOFED_cntr_2of5.sv - this module is for a FSM version of a serial 2 of 5 code checker.
//
// Author: Seth Rohrbach (rseth@pdx.edu)
// Version: 1.0
// Last updated: Feb 1 2020
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
