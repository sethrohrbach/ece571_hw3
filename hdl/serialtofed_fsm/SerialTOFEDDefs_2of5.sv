//////////////////////////////////////////////////////////////////////////////
// SerialTOFEDDefs_2of5.sv - Global definitions for Serial TOFED problem
//
// Author:			Roy Kravitz
// Version:			2.0
// Last modified:	15-Jan-2020
//
// Contains the global typedefs, const, enum, structs, etc. for the Serial
// TOFED problem.
//
// NOTE:  This version of the assignment does 2-of-5 detection
/////////////////////////////////////////////////////////////////////////////
package SerialTOFEDDefs_2of5;

parameter FBIBBLE_SIZE = 5;
parameter ONESPERFBIBBLE = 2;

typedef enum {FALSE, TRUE} bool_t;

endpackage
