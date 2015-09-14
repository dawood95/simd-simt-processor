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
   parameter THREADS = 2;
   
   logic clk = 0, nRST;

   always #(PERIOD/2) clk++;

   vector_register_file_if #(THREADS) rfif();

`ifndef MAPPED
   vector_register_file #(THREADS) DUT(clk, nRST, rfif);
`else
   vector_register_file #(.THREADS(THREADS)) 
   DUT(
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
`endif // !`ifndef MAPPED*/
   
   test PROG (clk, nRST, rfif);
   
endmodule // vector_register_file_tb

program test
   (
    input logic  clk,
    output logic nRST,
    vector_register_file_if.tb rf
    );

   import cpu_types_pkg::*;
   
   int 		 i = 0;
   
   initial
     begin

	$monitor("Register[%2d][0] = %10d\nRegister[%2d][1] = %10d\nRegister[%2d][0] = %10d\nRegister[%2d][1] = %10d\n",rf.rsel1,rf.rdata1[0],rf.rsel1,rf.rdata1[1],rf.rsel2,rf.rdata2[1],rf.rsel2,rf.rdata2[1]);

	nRST = 1'b1;
	rf.wen = {0,0};
	rf.wdata = {0,0};
	rf.wsel = 0;
	rf.rsel1 = 0;
	rf.rsel2 = 0;
	
	@(posedge clk);
	nRST = 1'b0;
	
	$display("Initial Reset");
	
	@(posedge clk);
	nRST = 1'b1;
	rf.wen = {1'b1,1'b1};
	for (i = 0; i < 32; i++)
	  begin
	     rf.wdata[0] = 2**i;
	     rf.wdata[1] = 2**i+1;
	     rf.wsel = i;
	     $display("Writing %10d, %10d to Register %10d", rf.wdata[0], rf.wdata[1], rf.wsel);
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

endprogram // test
   
