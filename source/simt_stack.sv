/*
 Sheik Dawood
 dawood0@purdue.edu
 
 SIMT Stack
 
 Stack structure :
 
 | mask bits | sync address (sync) | return address (addr) |

*/

`include "cpu_types_pkg.vh"

module simt_stack 
  import cpu_types_pkg::*; 
   (
	input logic CLK, nRST,
	simt_stack_if.stack stif
	);

   parameter THREADS = 4
					   
   logic maskStack[THREADS][15:0];
   word_t addrStack[15:0];
   word_t syncStack[15:0];
   logic [3:0] index;

   always_comb
	 begin
		stif.currentSync = syncStack[index];
		stif.currentMask = maskStack[index];
		stif.currentAddr = addrStack[index];
		stif.overflow = (index == 4'd15 && stif.pushEn) ? 1'b1 : 1'b0;
		stif.underflow = (index == 0 && stif.popEn) ? 1'b1 : 1'b0;
	 end
   
   always_ff @ (posedge CLK or negedge nRST)
	 begin		
		if (!nRST)
		  begin
			 maskStack = '{default:'0};
			 syncStack = '{default:'0};
			 addrStack = '{default:'0};
			 index = 0;
		  end
		else if (stif.pushEn)
		  begin
			 maskStack[index] = stif.newMask;
			 syncStack[index] = stif.newSync;
			 addrStack[index] = stif.newAddr;
			 index = index + 1;
		  end
		else if (stif.popEn)
		  begin
			 index = index - 1;
		  end
	 end
				  
endmodule // simt_stack
