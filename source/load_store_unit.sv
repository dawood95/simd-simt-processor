/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Vector load store unit
 */

`include "load_store_unit_if.vh"

`include "cpu_types_pkg.vh"

module load_store_unit (
			input logic CLK, nRST,
			load_store_unit_if.loadstore ls
			);
   
   import cpu_types_pkg::*;

   parameter THREADS = 4;
   parameter CPUID = 0;

   logic [$clog2(THREADS)-1:0] 	    index, nextIndex;
   logic 			    isData, iHit;
   word_t                           daddr, dstore;
   word_t                           dload[THREADS];
   
   
   always_comb
     begin
	isData = ls.readReq | ls.writeReq;
	nextIndex = (!ls.isVector | !isData) ? index : index + 1;
     end
   
   always_ff @ (posedge CLK or negedge nRST)
     begin
	if (!nRST)
	  index <= 0;
	else if (ls.dcacheHit)
	  index <= nextIndex;
     end

   assign ls.iload = ls.imemload;	
   assign ls.sdload = (!ls.isVector) ? ls.dmemload : 32'hDEADBEEF;   

   always_comb
     begin
	ls.iHit = ls.icacheHit;
	ls.dHit = (nextIndex == 0) ? ls.dcacheHit : 0;

	ls.chalt = ls.dhalt;
	ls.imemREN = ls.instReq;
	//ls.dmemREN = (iHit) ? ls.readReq : 1'b0;
	//ls.dmemWEN = (iHit) ? ls.writeReq : 1'b0;
	
	ls.imemaddr = ls.iaddr;
	ls.dmemaddr = (!ls.isVector) ? ls.sdaddr : ls.vdaddr[index];
	ls.dmemstore = (!ls.isVector) ? ls.sdstore : dstore;
	ls.vdload = dload;
	ls.vdload[THREADS-1] = ls.dmemload;
     end

   always_ff @ (posedge CLK, negedge nRST)
     begin
	if(!nRST)
	  begin
	     ls.dmemREN <= 1'b0;
	     ls.dmemWEN <= 1'b0;
	     iHit <= 1'b0;
	  end
	else if(ls.dcacheHit && (nextIndex == 0))
	  begin
	     ls.dmemREN <= 1'b0;
	     ls.dmemWEN <= 1'b0;
	     iHit <= 1'b0;
	  end
	else 
	  begin
	     ls.dmemREN <= ls.readReq;
	     ls.dmemWEN <= ls.writeReq;
	     iHit <= 1'b1;
	  end
     end // always_ff @

   always_ff @ (posedge CLK, negedge nRST)
     begin
	if (!nRST)
	  begin
	     daddr <= ls.vdaddr[0];
	     dstore <= ls.vdstore[0];
	     dload <= '{default:0};
	  end
	else if (ls.dcacheHit)
	  begin
	     daddr <= ls.vdaddr[nextIndex];
	     dstore <= ls.vdstore[nextIndex];
	     dload[index] <= ls.dmemload;
	  end
     end
   
endmodule // load_store_unit

