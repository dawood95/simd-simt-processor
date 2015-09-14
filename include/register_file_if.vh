/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Register File Interfaces
 */

`ifndef REGISTER_FILE_IF_VH
 `define REGISTER_FILE_IF_VH

 `include "cpu_types_pkg.vh"

interface scalar_register_file_if;
  
  import cpu_types_pkg::*;
   
   logic     wen;
   regbits_t wsel, rsel1, rsel2;
   word_t    wdata, rdata1, rdata2;
   
   modport rf (
	       input  wen, wsel, rsel1, rsel2, wdata,
	       output rdata1, rdata2
	       );
   
   modport tb (
	       input  rdata1, rdata2,
	       output wen, wsel, rsel1, rsel2, wdata
	       );
   
endinterface // scalar_register_file_if


interface vector_register_file_if #(parameter THREADS = 4);
   
   import cpu_types_pkg::*;
   
   regbits_t wsel, rsel1, rsel2;
   logic wen[THREADS];
   
   word_t wdata[THREADS], rdata1[THREADS], rdata2[THREADS];
   
   modport rf(
	      input  wen, wsel, rsel1, rsel2, wdata,
	      output rdata1, rdata2
	      );
   
   modport tb(
	      input  rdata1, rdata2,
	      output wen, wsel, rsel1, rsel2, wdata
	      );
   
endinterface // vector_register_file_if

`endif
