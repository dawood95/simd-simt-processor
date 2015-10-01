/*
 * Sheik Dawood
 * dawood0@purdue.edu
 *
 * this block holds the i and d cache
 */


// interfaces
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module caches (
	       input logic CLK, nRST,
	       load_store_unit_if.cache lsif,
	       cache_control_if.caches ccif
	       );
   
   // import types
   import cpu_types_pkg::word_t;

   parameter CPUID = 0;

   word_t instr;
   word_t daddr;

   // icache
   //icache  ICACHE(dcif, ccif);
   // dcache
   //dcache  DCACHE(dcif, ccif);

   // single cycle instr saver (for memory ops)
   always_ff @(posedge CLK)
     begin
	if (!nRST)
	  begin
	     instr <= '0;
	     daddr <= '0;
	  end
	else
	  if (lsif.icacheHit)
	    begin
	       //instr <= ccif.iload[CPUID];
	       instr <= ccif.iload;
	       daddr <= lsif.dmemaddr;
	    end
     end // always_ff @
   
   // dcache invalidate before halt
   assign lsif.flushed = lsif.chalt;

   //single cycle
   assign lsif.icacheHit = (lsif.imemREN) ? ~ccif.iwait[CPUID] : 0;
   assign lsif.dcacheHit = (lsif.dmemREN|lsif.dmemWEN) ? ~ccif.dwait[CPUID] : 0;
   assign lsif.imemload = (ccif.iwait[CPUID]) ? instr : ccif.iload[CPUID];
   assign lsif.dmemload = ccif.dload[CPUID];
   //assign dcif.ihit = (dcif.imemREN) ? ~ccif.iwait : 0;
   //assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~ccif.dwait : 0;
   //assign dcif.imemload = (ccif.iwait) ? instr : ccif.iload;
   //assign dcif.dmemload = ccif.dload;

   assign ccif.iREN[CPUID] = lsif.imemREN;
   assign ccif.dREN[CPUID] = lsif.dmemREN;
   assign ccif.dWEN[CPUID] = lsif.dmemWEN;
   assign ccif.dstore[CPUID] = lsif.dmemstore;
   assign ccif.iaddr[CPUID] = lsif.imemaddr;
   assign ccif.daddr[CPUID] = daddr;
   //assign ccif.iREN = dcif.imemREN;
   //assign ccif.dREN = dcif.dmemREN;
   //assign ccif.dWEN = dcif.dmemWEN;
   //assign ccif.dstore = dcif.dmemstore;
   //assign ccif.iaddr = dcif.imemaddr;
   //assign ccif.daddr = daddr;

endmodule
