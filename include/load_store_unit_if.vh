/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Vector load store unit interface
 */

`ifndef LOAD_STORE_UNIT_IF
 `define LOAD_STORE_UNIT_IF

 `include "cpu_types_pkg.vh"

interface load_store_unit_if;

   import cpu_types_pkg::*;

   parameter CPUS = 2;
   parameter CPUID = 0;
   parameter THREADS = 4;

   // Datapath signals
   
   logic readReq, writeReq, instReq;

   logic dHit, iHit;

   logic isVector;
   
   word_t vdaddr[THREADS], vdstore[THREADS], vdload[THREADS];
   word_t sdaddr, sdstore, sdload;
   word_t iaddr, iload;

   // Cache signals

   logic halt, imemREN, dmemREN, dmemWEN;

   logic icacheHit, dcacheHit;
   
   word_t dmemaddr, dmemstore, dmemload;
   word_t imemaddr, imemload;


   modport loadstore 
     (
      // Datapath
      input  instReq, readReq, writeReq, isVector, halt,
	     vdaddr, vdstore, sdaddr, sdstore, iaddr, 
      output iHit, dHit,
	     iload, vdload, sdload,
      // Cache
      input  imemload, dmemload, icacheHit, dcacheHit,
      output halt, imemREN, dmemREN, dmemWEN,
	     imemaddr, dmemaddr, dmemstore
      );

   modport datapath 
     (
      output instReq, readReq, writeReq, isVector, halt,
	     vdaddr, vdstore, sdaddr, sdstore, iaddr, 
      input  iHit, dHit,
	     iload, vdload, sdload
      );
   
   modport cache 
     (
      output imemload, dmemload, icacheHit, dcacheHit,
      input  halt, imemREN, dmemREN, dmemWEN,
	     imemaddr, dmemaddr, dmemstore
      );
   
   
endinterface // load_store_unit_if

`endif //  `ifndef LOAD_STORE_UNIT_IF

   
