`timescale 1ns / 1ps
///////////////////////////////
// test_SerialTOFED.sv -  test bench for Serial 2-of-5 checker
//
// Author: Roy Kravitz
// Last Edited by: Seth Rohrbach
// Version:			1.3
// Last modified:	1-Feb-2020
//
// This testbench verifies (or not) the functionality of the
// two 2-of-5 checkers implemented for the Serial TOFED problem
//
// The testbench does an exhaustive text on all of the 5-bit combinations,
// applying the stimulus to two different implementations.
// -Modified by Seth Rohrbach to work with a FSM version of the same serial checker, on a 2-of-5 code.
///////////////////////////////

import SerialTOFEDDefs_2of5::*;

module test_SerialTOFED_2of5;

parameter	NUMTESTCASES = 2**FBIBBLE_SIZE;					// exhaustively test all combinations
parameter	STIMBITS_SIZE = (NUMTESTCASES + 1) * FBIBBLE_SIZE;	// width of the test vector (32 cases x 5 bits/case)
parameter	CLK_PERIOD = 10;								// clock period is 10 time units

bit 	[STIMBITS_SIZE-1:0]		stimulus, datastream;		// serial data stream to check
bit		[FBIBBLE_SIZE-1:0]		code;						// current data word
bit								din;						// Serial data input
bool_t						 	valid_cntr;					// Valid outputs


// results checking variables
int 							bitCount;			// number of bits in current data word
int								onesCount;			// number of 1's in current data word
int								errorcount = 0;		// counts the number of errors
bit								check;				// asserted when it's time to check the valid bit

// clock and reset variables
bit 						clk = 1'b0;			// system clock
bit							resetH = 1'b1;		// reset signal is asserted high
bit							flag;
// instantiate the counter DUT
SerialTOFED_cntr cntr_DUT
(
	.clk(clk),
	.resetH(resetH),
	.din(din),
	.valid(valid_cntr)
);


// populate the stimulus vector
initial begin
	// fill the stimulus vector from lowest to highest FBIBBLE value
	for (int i = 0; i <NUMTESTCASES; i++) begin
		code = i;
		stimulus = (stimulus << FBIBBLE_SIZE) | code;
	end

	// add dummy test case to get past potential reset oddities
	stimulus = (stimulus << FBIBBLE_SIZE) | 5'b00000;

end // populate the stimulus vector

// generate the system clock
always begin
	#(CLK_PERIOD / 2) clk = ~clk;
end // clock generator

// generate the data input to the TOFED detector
assign din = datastream[0];

// generate the check signal
assign check = (bitCount == (FBIBBLE_SIZE - 1));

// error checking logic
assign onesCount = $countones(code);

// generate the FBIBBLE bit counter
always @(posedge clk) begin
	if (resetH) begin
		bitCount <= -1;
	end
	else begin
		if (bitCount == (FBIBBLE_SIZE - 1)) begin
			bitCount <= 0;
		end
		else begin
			bitCount <= bitCount + 1;
		end
	end
end // generate the check signal

// display/check the results when check is asserted
always @(posedge clk) begin
	if (resetH) begin
		$display($time, "\tSystem is in reset");
		$display($time, "\tDatastream = %b\n\n", datastream);
	end
	else if (check)begin
		if ((onesCount == ONESPERFBIBBLE) && (valid_cntr != TRUE)) begin
			$display($time, "\tERROR: data word = %5b\tNumber of 1's = %d\t\tvalid(counters) = %5s", code, onesCount, valid_cntr);
			errorcount++;
		end
		else if ((onesCount != ONESPERFBIBBLE) && (valid_cntr == TRUE)) begin
			$display($time, "\tERROR: data word = %5b\tNumber of 1's = %d\t\tvalid(counters) = %5s", code, onesCount, valid_cntr);
			errorcount++;
		end
		else begin
			$display($time, "\tdata word = %5b\tvalid(counters) = %5s", code, valid_cntr);
		end
	end
end // display/check the results when check is asserted

// update the datastream and save the new data word when we
// start the next fbibble
always @(posedge clk) begin
	if (resetH) begin
		datastream <= stimulus;
		code <= datastream[4:0];
		flag = 1'b1;
	end
	else begin
		if (flag) begin
		datastream = datastream;
		flag = 1'b0; end
                else
		datastream = datastream >> 1;
		if (bitCount == (FBIBBLE_SIZE - 1)) begin
			// on to the next data word
			code <= datastream[4:0];
		end
	end
end // generate the next value to serialize




// test the model
initial begin
	// toggle the reset signal
	#20 resetH = 1'b1;
	#20 resetH = 1'b0;

	// run until the pattern has been exhausted
	while (datastream != 0) begin
		#1;
	end

	#100 // finish out the 00000 test case
	if (errorcount == 0) begin
		$display("\n\nNO ERRORS DETECTED - GOOD JOB!");
	end
	else begin
		$display ("\n\n%2d ERRORS DETECTED - IF AT FIRST YOU DON'T SUCCEED <blah>,<blah><blah>", errorcount);
	end

	$stop;
end

endmodule
