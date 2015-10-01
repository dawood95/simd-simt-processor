/*
 Sheik Dawood
 dawood0@purdue.edu
 
 datapath contains register file, control, hazard,
 muxes, and glue logic for processor
 */

`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "load_store_unit_if.vh"
`include "cpu_types_pkg.vh"

module datapath (
		 input logic CLK, nRST,
		 load_store_unit_if.datapath lsif
		 );
   // import types
   import cpu_types_pkg::*;

   // pc init
   parameter PC_INIT = 0;

   // Local variables
   word_t instr;
   i_t iinstr;
   j_t jinstr;
   r_t rinstr;
   word_t immExt, pc, pc_next;
   logic 		     r_req, w_req, porta_sel, immExt_sel, brEn, pcEn, halt;
   logic [1:0] 		     portb_sel, pc_sel, wMemReg_sel, regW_sel;
   scalar_alu_if alif();
   scalar_register_file_if rfif();
   
   
   always_comb
     begin
	// Instruction type cast
	iinstr = i_t'(instr);
	jinstr = j_t'(instr);
	rinstr = r_t'(instr);
     end

   
   
   scalar_register_file reg_file( CLK, nRST, rfif);

   load_store_unit load_store (CLK, nRST, lsif);

   control_unit control_unit(.instr(instr),
			     .zf(alif.zf),
		       	     .of(alif.of),
	       		     .aluOp(alif.op),
       			     .portb_sel(portb_sel),
       			     .porta_sel(porta_sel),
       			     .immExt_sel(immExt_sel), 
       			     .pc_sel(pc_sel), 
       			     .regW_sel(regW_sel),
       			     .wMemReg_sel(wMemReg_sel), 
       			     .memREN(lsif.readReq), 
       			     .memWEN(lsif.writeReq), 
       			     .regWEN(rfif.wen),
       			     .brEn(brEn),	
			     .halt(halt)
			     );
   
   scalar_alu alu(alif);

   always_comb
     begin
	instr = lsif.iload;
	immExt = (immExt_sel) ? {{16{iinstr.imm[15]}},iinstr.imm} : {16'b0,iinstr.imm} ;
	alif.porta = (porta_sel) ? immExt : rfif.rdata1;
	case(portb_sel)
	  2'b00: alif.portb = rfif.rdata2;
	  2'b01: alif.portb = rinstr.shamt;
	  2'b10: alif.portb = immExt;
	  2'b11: alif.portb = 32'd16;
	endcase // case (portb_sel)
	case(regW_sel)
	  2'b00, 2'b11: rfif.wsel = rinstr.rd;
	  2'b01: rfif.wsel = rinstr.rt;
	  2'b10: rfif.wsel = 5'd31;
	endcase // case (regW_sel)
	rfif.rsel1 = rinstr.rs;
	rfif.rsel2 = rinstr.rt;
	case(wMemReg_sel)
	  2'b00,2'b11 : rfif.wdata = alif.out;
	  2'b01: rfif.wdata = lsif.sdload;
	  2'b10: rfif.wdata = pc+4;
	endcase
	lsif.sdaddr = alif.out;
	lsif.sdstore = rfif.rdata2;
	lsif.iaddr = pc;
	case(pc_sel)
	  2'b00, 2'b11: pc_next = pc + 4 + ((brEn) ? immExt<<2 : 32'd0);
	  2'b01: pc_next = rfif.rdata1;
	  2'b10: pc_next = {pc[31:28],jinstr.addr,2'b00};
	endcase
	pcEn = lsif.iHit | lsif.dHit;
     end
   
   //PC  
   assign lsif.isVector = 1'b0;
   
   always_ff @(posedge CLK, negedge nRST)
     begin
	if(!nRST)
	  pc <= PC_INIT;
	else if(pcEn & !lsif.dhalt)
	  pc <= pc_next;
     end

   always_ff @(posedge CLK, negedge nRST)
     begin
	if(!nRST)
	  lsif.dhalt <= 1'b0;
	else
	  lsif.dhalt <= halt;
     end
   
endmodule // datapath



