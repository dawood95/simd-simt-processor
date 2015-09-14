/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Vector Register File Testbench
 */

`include "register_file_if.vh"

`timescale 1ns/1ns

module scalar_register_file_tb;

   parameter PERIOD = 10;

   logic clk = 0, nRST;

   always #(PERIOD/2) clk++;

   scalar_register_file_if rfif();

`ifndef MAPPED
   scalar_register_file DUT(clk, nRST, rfif);
`else
   scalar_register_file DUT(
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
    scalar_register_file_if.tb rf
    );

   int 		 i = 0;
   
   initial
     begin
	$monitor("Register[%2d] = %10d Register[%2d] = %10d",rf.rsel1,rf.rdata1,rf.rsel2,rf.rdata2);
	nRST = 1'b1;
	rf.wen = 0;
	rf.wdata = 0;
	rf.wsel = 0;
	rf.rsel1 = 0;
	rf.rsel2 = 0;
	
	@(posedge clk);
	nRST = 1'b0;
	
	$display("Initial Reset");
	
	@(posedge clk);
	nRST = 1'b1;
	rf.wen = 2'b11;
	for (i = 0; i < 32; i++)
	  begin
	     rf.wdata = 2**i;
	     rf.wsel = i;
	     $display("Writing %10d to Register %10d", rf.wdata, rf.wsel);
	     @(posedge clk);
	  end
	for (i = 0; i < 16; i++)
	  begin
	     rf.rsel1 = i;
	     rf.rsel2 = 31 - i;
	     @(posedge clk);
	  end
	nRST = 1'b0;
	$display("Reset");
	for (i = 0; i < 16; i++)
	  begin
	     rf.rsel1 = i;
	     rf.rsel2 = 31 - i;
	     @(posedge clk);
	  end
     end

   final;
     
endprogram // test
   
