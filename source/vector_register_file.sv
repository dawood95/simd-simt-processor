/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Vector Register File
 */

`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module vector_register_file #(parameter THREADS = 4)
   (
    input logic clk, nRST,
    vector_register_file_if.rf rf
    );
   
   import cpu_types_pkg::*;

   int 		i;
   
   word_t register_file[31:0][THREADS];

   always_ff @ (posedge clk or negedge nRST)
     begin
	if(!nRST)
	  register_file <= '{default:'0};
	else
	  begin
	     for(int i = 0; i < THREADS; i++)
	       begin
		  if(rf.wsel && rf.wen[i])
		    register_file[rf.wsel][i] <= rf.wdata[i];
	       end
	  end // else: !if(!nRST)
     end

   always_comb
     begin
	rf.rdata1 = register_file[rf.rsel1];
	rf.rdata2 = register_file[rf.rsel2];
     end
   
endmodule // vector_register_file
