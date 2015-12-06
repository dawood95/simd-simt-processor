/*
 Sheik Dawood
 dawood0@purdue.edu
 
 SIMT Stack
 
 Stack structure :
 
 | mask bits | sync address (sync) | return address (addr) |

*/

`include "cpu_types_pkg.vh"

module simt_stack import cpu_types_pkg::*; 
   #(parameter THREADS = 4) 
   (
	input logic   clk, nRST,
	input logic   pushEn, popEn,
	input word_t  newSync, newAddr,
	input logic   newMask[THREADS],
    output word_t currentSync, currentAddr,
	output logic  currentMask[THREADS],
	output logic  overflow, underflow, isEmpty
	);


   logic maskStack[THREADS][15:0];
   word_t addrStack[15:0];
   word_t syncStack[15:0];
   logic [3:0] index;

   always_comb
	 begin
		currentSync = syncStack[index];
		currentMask = maskStack[index];
		currentAddr = addrStack[index];
		overflow = (index == 4'd15 && pushEn) ? 1'b1 : 1'b0;
		underflow = (index == 0 && popEn) ? 1'b1 : 1'b0;
	 end
   
   always_ff @ (posedge clk or negedge nRST)
	 begin		
		if (!nRST)
		  begin
			 maskStack = '{default:'0};
			 syncStack = '{default:'0};
			 addrStack = '{default:'0};
			 index = 0;
		  end
		else if (pushEn)
		  begin
			 maskStack[index] = newMask;
			 syncStack[index] = newSync;
			 addrStack[index] = newAddr;
			 index = index + 1;
		  end
		else if (popEn)
		  begin
			 index = index - 1;
		  end
	 end
				  
endmodule // simt_stack
