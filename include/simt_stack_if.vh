/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * SIMT Stack unit interface
 */

`ifndef SIMT_STACK_UNIT_IF
 `define SIMT_STACK_UNIT_IF

 `include "cpu_types_pkg.vh"

interface simt_stack_if;

   import cpu_types_pkg::*;

   parameter CPUS = 2;
   parameter CPUID = 0;
   parameter THREADS = 4;
   
   logic [1:0] pushEn;
   logic 	   popEn;
   
   word_t      newSync, newAddr;
   logic 	   newMask[THREADS];
   
   word_t      currentSync, currentAddr;
   logic 	   currentMask[THREADS];
   logic 	   overflow, underflow, isEmpty;
   
   modport simt
	 (
	  input  pushEn, popEn,
   			 newSync, newAddr,
			 newMask[THREADS],
	  
	  output currentSync, currentAddr,
			 currentMask[THREADS],
			 overflow, underflow, isEmpty   
	  );

   modport datapath
	 (
	  output pushEn, popEn,
   			 newSync, newAddr,
			 newMask[THREADS],
	  
	  input  currentSync, currentAddr,
			 currentMask[THREADS],
			 overflow, underflow, isEmpty 
	  );

endinterface // load_store_unit_if

`endif //  `ifndef SIMT_STACK_UNIT_IF

   
