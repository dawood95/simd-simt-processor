/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Vector Register File Testbench
 */

`include "register_file_if.vh"

`timescale 1ns/1ns

module vector_register_file_tb;

   parameter PERIOD = 10;

   logic clk = 0, nRST;

   always #(PERIOD/2) clk++;

   vector_register_file_if #(2) rfif();

`ifndef MAPPED
   vector_register_file #(2) DUT(clk, nRST, rfif);
`else
   vector_register_file #(2) DUT(
				 .\clk (clk),
				 .\nRST (nRST),
				 .\rf.wen (rfif.wen),
				 .\rf.wsel (rfif.wsel),
				 .\rf.rsel1 (rfif.rsel1),
				 .\rf.rsel2 (rfif.rsel2),
				 .\rf.wdata (rfif.wdata),
				 .\rf.rdata1 (rfif.rdata1),
				 .\rf.rdata2 (rfif.rdata2)
				 );
`endif // !`ifndef MAPPED
   
   test PROG (clk, nRST, rfif);
   
endmodule // vector_register_file_tb

program test
  import cpu_types_pkg::*;
   (
    input logic clk,
    output logic nRST,
    vector_register_file_if.tb rf
    );

   int 		 i = 0;
   
   initial
     begin
	$monitor("Register[%2d] = %10d Register[%2d] = %10d",rsel1,rdat1,rsel2,rdat2);
	nRST = 1'b1;
	rf.wen = 0;
	rf.wdata = 0;
	rf.wsel = 0;
	rf.rsel1 = 0;
	rf.rsel2 = 0;
	
	@(posedge CLK);
	nRST = 1'b0;
	
	$display("Initial Reset");
	
	@(posedge CLK);
	nRST = 1'b1;
	rf.wen = 2'b11;
	for (i = 0; i < 32; i++)
	  begin
	     wdat[0] = 2**i;
	     wdat[1] = 2**i+1;
	     wsel = i;
	     $display("Writing %10d to Register %10d", wdat, wsel);
	     @(posedge CLK);
	  end
	for (i = 0; i < 16; i++)
	  begin
	     rsel1 = i;
	     rsel2 = 31 - i;
	     @(posedge CLK);
	  end
	nRST = 1'b0;
	$display("Reset");
	for (i = 0; i < 16; i++)
	  begin
	     rsel1 = i;
	     rsel2 = 31 - i;
	     @(posedge CLK);
	  end
     end

   final;
     
endprogram // test
   
