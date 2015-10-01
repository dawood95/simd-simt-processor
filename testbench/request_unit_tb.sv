/* 
 Sheik Dawood
 dawood0@purdue.edu
 
 Test Bench for request unit
 */

`timescale 1ns/1ns


module request_unit_tb;

   parameter PERIOD = 20;
   logic CLK = 1, nRST;
   
   always #(PERIOD/2) CLK++;

   logic halt, r_req, w_req, iHit, dHit;
   logic iRen, dRen, dWen;
   
   request_unit DUT(
		    .CLK(CLK), .nRST(nRST), 
		    .halt(halt), .r_req(r_req), .w_req(w_req), .iHit(iHit), .dHit(dHit),
		    .iRen(iRen), .dRen(dRen), .dWen(dWen)
		    );
   
   initial
     begin
	nRST = 1'b1;	
	halt = 1'b0;
	r_req = 1'b0;
	w_req = 1'b0;
	iHit = 1'b0;
	dHit = 1'b0;
	@(posedge CLK);
	$display("Test Bench Started");
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	nRST = 1'b0;	
	@(posedge CLK);
	@(negedge CLK);
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	nRST = 1'b1;
	r_req = 1'b1;
	@(posedge CLK);
	@(negedge CLK);
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	dHit = 1'b1;
	@(posedge CLK);
	@(negedge CLK);
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	r_req = 1'b0;
	dHit = 1'b0;
	w_req = 1'b1;
	@(posedge CLK);
	@(negedge CLK);	
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	dHit = 1'b1;
	@(posedge CLK);	
	@(negedge CLK);
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	w_req = 1'b0;
	dHit = 1'b0;
	halt = 1'b1;
	@(posedge CLK);	
	@(negedge CLK);
	$display("Halt = %d, Read Req = %d, Write Req = %d, iHit = %d, dHit = %d\niRen = %d, dRen = %d, dWen = %d", halt, r_req, w_req, iHit, dHit, iRen, dRen, dWen);
	$finish;
     end
endmodule // request_unit_tb
