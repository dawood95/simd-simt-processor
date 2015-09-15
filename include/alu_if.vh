/* Sheik Dawood 
 * dawood0@purdue.edu
 * 
 * ALU Interface
 */

`ifndef ALU_IF_VH
 `define ALU_IF_VH

 `include "cpu_types_pkg.vh"

interface scalar_alu_if;
   
   import cpu_types_pkg::*;
   
   logic nf, zf, of;
   word_t porta, portb, out;
   aluop_t op;
   
   modport alu (
	       input  porta, portb, op,
	       output out, nf, zf, of
	       );

   modport tb (
	       input  out, nf, zf, of,
	       output porta, portb, op
	       );
   
endinterface

interface vector_alu_if #(parameter THREADS = 4);

   import cpu_types_pkg::*;
   
   logic 	      nf[THREADS], zf[THREADS], of[THREADS];
   word_t porta[THREADS], portb[THREADS], out[THREADS];
   aluop_t op[THREADS];
   
   modport alu (
	       input  porta, portb, op,
	       output out, nf, zf, of
	       );
   
   modport tb (
	       input  out, nf, zf, of,
	       output porta, portb, op
	       );
   
endinterface // vector_alu_if

`endif
   
