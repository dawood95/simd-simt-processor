/*
 * Sheik Dawood
 * dawood0@purdue.edu
 * 
 * Load Store Unit test bench
 * 
 * test for scalar instruction loads, data loads 
 * and vector data loads
 */

`include "cpu_types_pkg.vh"

`include "load_store_unit_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"

`timescale 1ns/1ns

module load_store_unit_tb;

   logic clk1=0, nRST;
   logic clk=0;
   
   always #(5) clk1++;
   always #(10) clk++;
   
   load_store_unit_if lsif();
   cache_control_if ccif();
   cpu_ram_if ramif();

   assign ramif.memaddr = ccif.ramaddr;
   assign ramif.memstore = ccif.ramstore;
   assign ramif.memREN = ccif.ramREN;
   assign ramif.memWEN = ccif.ramWEN;

   assign ramif.ramWEN = ramif.memWEN;
   assign ramif.ramREN = ramif.memREN;
   assign ramif.ramaddr = ramif.memaddr;
   assign ramif.ramstore = ramif.memstore;

   
   assign ccif.ramload = ramif.ramload;
   assign ccif.ramstate = ramif.ramstate;

   ram RAM(clk1, nRST, ramif);
   memory_control CC(clk, nRST, ccif);
   caches CM (clk, nRST, lsif, ccif);
   load_store_unit LS(clk, nRST, lsif);

   test PROG(clk, nRST, lsif);
   
endmodule // load_store_unit_tb

program test ( input logic clk, 
	       output logic nRST,
	       load_store_unit_if.datapath lsif);
   
   import cpu_types_pkg::*;

   initial
     begin
	nRST = 1'b0;
	lsif.instReq = 1'b0;
	lsif.readReq = 1'b0;
	lsif.writeReq = 1'b0;
	lsif.dhalt = 1'b0;
	lsif.isVector = 1'b0;
	lsif.vdaddr = {32'h0, 32'h0, 32'h0, 32'h0};
	lsif.vdstore = {32'h0, 32'h0, 32'h0, 32'h0};
	lsif.sdaddr = 32'hF;
	lsif.sdstore = 32'h0;
	lsif.iaddr = 32'h0;
	@(posedge clk);

	nRST = 1'b1;
	@(posedge clk);

	lsif.instReq = 1'b1;
	@(posedge clk);
	
	lsif.readReq = 1'b1;
	@(posedge clk);
	
	lsif.readReq = 1'b0;
	lsif.sdstore = 32'hAAAABBBB;
	lsif.writeReq = 1'b1;
	@(posedge clk);

	lsif.isVector = 1'b1;
	lsif.readReq = 1'b1;
	lsif.writeReq = 1'b0;
	lsif.vdaddr = {32'd0, 32'd4, 32'd8, 32'd12};
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);

	lsif.readReq = 1'b0;
	lsif.writeReq = 1'b1;
	lsif.vdstore = {32'hA, 32'hB, 32'hC, 32'hD};
	lsif.vdaddr = {32'd0, 32'd4, 32'd8, 32'd12};
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
     end
   
endprogram // test
   
