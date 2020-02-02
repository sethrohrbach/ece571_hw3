//////////////////////////////////////////////////////////////////////////////
// SerialTOFEDDefs_2of5.sv - Global definitions for Serial TOFED problem
//
// Author:			Roy Kravitz
// Last Edited by: Seth Rohrbach
// Version:			2.1
// Last modified:	1-Feb-2020
//
// Contains the global typedefs, const, enum, structs, etc. for the Serial
// TOFED problem.
// Added a typedef for the states of an FSM version of the solution.
//
// NOTE:  This version of the assignment does 2-of-5 detection
/////////////////////////////////////////////////////////////////////////////
package SerialTOFEDDefs_2of5;

parameter FBIBBLE_SIZE = 5;
parameter ONESPERFBIBBLE = 2;

typedef enum {FALSE, TRUE} bool_t;
typedef enum logic [4:0] {S1_0, S1_1, S2_0, S2_1, S2_2, S3_0, S3_1, S3_2, S3_3, S4_0, S4_1, S4_2, S4_3, S4_4, S5_0, S5_1, S5_2, S5_3, S5_4, S5_5, S_RST} state_t;

endpackage
