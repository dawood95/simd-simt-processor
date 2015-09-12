/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Scalar Register File
 */

`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module scalar_register_file
  import cpu_types_pkg::*;
   (
    input logic clk, nRST,
    scalar_register_file_if.rf rf
    );

   word_t register_file[31:0];

   always_ff @ (posedge clk or negedge nRST)
     begin
	if(!nRST)
	  register_file <= '{default:'0};
	else if(rf.wen && rf.wsel)
	  register_file[rf.wsel] <= rf.wdata;
     end

   always_comb
     begin
	rf.rdata1 = register_file[rf.rsel1];
	rf.rdata2 = register_file[rf.rsel2];
     end
   
endmodule // scalar_register_file
