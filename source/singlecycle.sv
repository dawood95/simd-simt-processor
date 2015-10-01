/*
 Eric Villasenor
 evillase@gmail.com

 single cycle top block
 holds data path components
 and cache level
 */

module singlecycle (
		    input logic  CLK, nRST,
		    output logic halt,
		    cpu_ram_if.cpu scif
		    );

   parameter PC0 = 0;
   parameter THREADS = 4;

   // bus interface
   load_store_unit_if         lsif ();
   
   // coherence interface
   cache_control_if    #(.CPUID(0))       ccif ();
   
   // map datapath
   datapath #(.PC_INIT(PC0)) DP (CLK, nRST, lsif);
   // map caches
   caches #(.CPUID(0))       CM (CLK, nRST, lsif, ccif);
   // map coherence
   memory_control            CC (CLK, nRST, ccif);

   // interface connections
   assign scif.memaddr = ccif.ramaddr;
   assign scif.memstore = ccif.ramstore;
   assign scif.memREN = ccif.ramREN;
   assign scif.memWEN = ccif.ramWEN;

   assign ccif.ramload = scif.ramload;
   assign ccif.ramstate = scif.ramstate;

   assign halt = lsif.flushed;
endmodule
