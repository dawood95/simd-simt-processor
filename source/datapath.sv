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

   // pc init & threads
   parameter PC_INIT = 0;
   parameter THREADS = 4;
   
   // Local variables
   word_t instr;
   i_t iinstr;
   j_t jinstr;
   r_t rinstr;

   scalar_alu_if alif();
   vector_alu_if vlif();
   
   scalar_register_file_if rfif();
   vector_register_file_if vfif();
   
   scalar_alu sca_alu(alif);
   vector_alu vec_alu(vlif);
   
   scalar_register_file sca_file( CLK, nRST, rfif);
   vector_register_file vec_file( CLK, nRST, vfif);

   aluop_t                   op;
   word_t                    immExt, pc, pc_next;
   logic 										 r_req, w_req, porta_sel, immExt_sel, brEn, pcEn, halt;
   logic [1:0] 							 vporta_sel, portb_sel, pc_sel, wMemReg_sel, regW_sel;
   logic [2:0] 							 mask_sel;
   word_t                    vporta[THREADS], vportb[THREADS];

   logic 										 mask[THREADS], nextMask[THREADS];
   
   control_unit control_unit(.instr(instr),
														 .szf(alif.zf),
		       									 .sof(alif.of),
														 .isVectorLS(lsif.isVector),
	       										 .sOp(alif.op),
														 .vOp(vlif.op),
       											 .portb_sel(portb_sel),
       											 .porta_sel(porta_sel),
														 .vporta_sel(vporta_sel),
       											 .immExt_sel(immExt_sel), 
       											 .pc_sel(pc_sel), 
       											 .regW_sel(regW_sel),
       											 .wMemReg_sel(wMemReg_sel), 
       											 .memREN(lsif.readReq), 
       											 .memWEN(lsif.writeReq), 
       											 .sregWEN(rfif.wen),
														 .vregWEN(vfif.wen),
														 .mask(mask),
														 .mask_sel(mask_sel),
       											 .brEn(brEn),	
														 .halt(halt)
														 );
   
   
   always_comb
     begin

				instr = lsif.iload;
				
				iinstr = i_t'(instr);
				jinstr = j_t'(instr);
				rinstr = r_t'(instr);
				
				immExt = (immExt_sel) ? {{16{iinstr.imm[15]}},iinstr.imm} : {16'b0,iinstr.imm} ;

				lsif.iaddr = pc;

				case(pc_sel)
					2'b00, 2'b11: pc_next = pc + 4 + ((brEn) ? immExt<<2 : 32'd0);
					2'b01: pc_next = rfif.rdata1;
					2'b10: pc_next = {pc[31:28],jinstr.addr,2'b00};
				endcase
				
				pcEn = lsif.iHit;
				
     end // always_comb
   
   // Scalar
   always_comb
     begin

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
				lsif.instReq = 1'b1;

				case(regW_sel)
					2'b00, 2'b11: vfif.wsel = rinstr.rd;
					2'b01: vfif.wsel = rinstr.rt;
					2'b10: vfif.wsel = 5'd31;
				endcase // case (regW_sel)
				
				vfif.rsel1 = rinstr.rs;
				vfif.rsel2 = rinstr.rt;
				
     end

   genvar i;

   generate
      for(i = 0; i < THREADS; i++) 
				begin : vector
					 
					 assign vlif.porta[i] = vporta[i];
					 assign vlif.portb[i] = vportb[i];
					 
					 always_comb
						 begin

								case(vporta_sel)
									2'b00: vporta[i] = immExt;
									2'b01: vporta[i] = vfif.rdata1[i];
									2'b10: vporta[i] = rfif.rdata1;
									default : vporta[i] = vfif.rdata1[i];
								endcase // case (vporta_sel)
								
								case(portb_sel)
									2'b00: vportb[i] = vfif.rdata2[i];
									2'b01: vportb[i] = rinstr.shamt;
									2'b10:
										begin
											 if(iinstr.opcode == VLWO || iinstr.opcode == VSWO)
												 if(i == 0)
													 vportb[i] = 0;
												 else if(i%2 == 0)
													 vportb[i] = immExt << (i-1);
												 else
													 vportb[i] = vportb[i-1]+immExt;
											 else
												 vportb[i] = immExt;
										end
									2'b11: vportb[i] = 32'd16;
								endcase // case (portb_sel)

								case(mask_sel)
									// Invert
									3'd0: 
										nextMask[i] = ~mask[i];
									// LT
									3'd1: 
										nextMask[i] = ($signed(vporta[i]) < $signed(vportb[i])) ? 1'b1 : 1'b0;
									// LTU
									3'd2: 
										nextMask[i] = (vporta[i] < vportb[i]) ? 1'b1 : 1'b0;
									// EQ
									3'd3: 
										nextMask[i] = (vporta[i] == vportb[i]) ? 1'b1 : 1'b0;
									default:
										nextMask[i] = mask[i];
								endcase // case (mask_sel)
								
								case(wMemReg_sel)
									2'b00,2'b11 : vfif.wdata[i] = vlif.out[i];
									2'b01: vfif.wdata[i] = lsif.vdload[i];
									2'b10: vfif.wdata[i] = pc+4;
								endcase

								lsif.vdaddr[i] = vlif.out[i];
								lsif.vdstore[i] = vfif.rdata2[i];
						 end
				end
   endgenerate
   
   always_ff @(posedge CLK, negedge nRST)
		 begin
				for (int j = 0; j < THREADS; j++)
					begin
						 if (!nRST)
							 mask[j] <= 1'b1;
						 else
							 mask[j] <= nextMask[j];
					end
		 end
   
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



