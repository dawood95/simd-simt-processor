/*
 Sheik Dawood
 dawood0@purdue.edu
 
 Control unit for single Cycle Processor
 */

`include "cpu_types_pkg.vh"

module control_unit 
  import cpu_types_pkg::*;
   #(parameter THREADS = 4)   
   (
    input 			   word_t instr,
    input logic 	   szf, sof, vzf[THREADS],
	input logic 	   mask[THREADS],
    output logic 	   isVectorLS, pushEn, writeSync,
    output 			   aluop_t sOp, vOp[THREADS], 
    output logic [1:0] vporta_sel, portb_sel, pc_sel, regW_sel, wMemReg_sel, 
	//	output logic [2:0] mask_sel,
    output logic 	   porta_sel, immExt_sel, memREN, memWEN, sregWEN, vregWEN[THREADS], brEn, vbrEn[THREADS], halt
    );

   logic 			   isVector, isMask;
   logic 			   t_vbrEn[THREADS];
   i_t iinstr;
   j_t jinstr;
   r_t rinstr;
   
   genvar 			   i;
   
   // is the instruction a vector load store
   assign isVectorLS = (iinstr.opcode == VLW || iinstr.opcode == VSW || iinstr.opcode == VLWO || iinstr.opcode == VSWO);

   /*
	always_comb
	begin
	isMask = 1'b1;
	case(iinstr.opcode)
	MLT:
	mask_sel = 3'd1;
	MLTU:
	mask_sel = 3'd2;
	MEQ:
	mask_sel = 3'd3;
	MINV:
	mask_sel = 3'd0;
	default:
	begin
	isMask = 1'b0;
	mask_sel = 3'd7;
						end
				endcase // case (iinstr.opcode)
		 end
	*/
   
   always_comb
	 begin
		case(iinstr.opcode)
		  VTYPE, VBEQ, VBNE, VADDI, VADDIU, VSLTI, VSLTIU, VANDI, VORI, VXORI, VLUI, VLW, VSW, VLWO, VSWO:
			begin
			   isVector = 1'b1;
			   //isMasked = 1'b0;
			end
		  //MVTYPE, MVADDI, MVADDIU, MVANDI, MVORI, MVXORI, MVLUI:
		  //begin
		  //isVector = 1'b1;
		  //isMasked = 1'b1;
		  //end
		  default :
			begin
			   isVector = 1'b0;
			   //isMasked = 1'b0;
			end
		endcase
	 end

   always_comb
     begin
		// Instruction type cast
		iinstr = i_t'(instr);
		jinstr = j_t'(instr);
		rinstr = r_t'(instr);
     end

   always_comb
     begin
		//Halt
		if(iinstr.opcode == HALT ||
		   (rinstr.opcode == RTYPE && 
			(rinstr.funct == ADD || 
			 rinstr.funct == SUB) && 
			sof) ||
		   (iinstr.opcode == ADDI && sof))
		  halt = 1'b1;
		else
		  halt = 1'b0;

		if(iinstr.opcode == VBNE || iinstr.opcode == VBEQ)
		  pushEn = 1'b1;
		else
		  pushEn = 1'b0;

		if(iinstr.opcode == SYNC)
		  writeSync = 1'b1;
		else
		  writeSync = 1'b0;
		  
		//Immediate Extension Select
		// 0 -> zero
		// 1 -> sign
		case(iinstr.opcode)
		  ADDIU, ADDI, LW, SLTI, SLTIU, SW, BNE, BEQ, VADDIU, VADDI, VLW, VLWO, VSLTI, VSLTIU, VSW, VSWO, VBNE, VBEQ, SYNC : immExt_sel = 1'b1;
		  default: immExt_sel = 1'b0;
		endcase // case (iinstr.opcode)
		
		//PortB Select
		// 00 -> Rt
		// 01 -> shamt
		// 10 -> immExt
		// 11 -> 32'd16
		if (iinstr.opcode == RTYPE || iinstr.opcode == VTYPE)
		  begin
			 case(rinstr.funct)
			   SLL, SRL: portb_sel = 2'b01;
			   default: portb_sel = 2'b00;
			 endcase // case (rinstr.funct)
		  end
		else
		  begin
			 case(iinstr.opcode)
			   VBEQ, VBNE, BNE, BEQ, MLT, MEQ, MLTU: portb_sel = 2'b00;
			   VLUI, LUI: portb_sel = 2'b11;
			   default: portb_sel = 2'b10;
			 endcase // case (iinstr.opcode)
		  end // else: !if(iinstr.opcode == RTYPE)

		//PortA Select
		// 0 -> rs
		// 1 -> imm
		porta_sel = (iinstr.opcode == LUI || iinstr.opcode == VLUI) ? 1 : 0;

		//PortA Select
		// 00 -> imm
		// 01 -> V[rs]
		// 10 -> S[rs]
		vporta_sel = (iinstr.opcode == LUI || iinstr.opcode == VLUI) ? 2'b00 : (iinstr.opcode == VLWO || iinstr.opcode == VSWO) ? 2'b10 : 2'b01;

		//select for reg write
		// 00 -> alu
		// 01 -> Memory
		// 10 -> Pc
		if(iinstr.opcode == LW || iinstr.opcode == VLW || iinstr.opcode == VLWO)
		  wMemReg_sel = 2'b01;
		else if(iinstr.opcode == JAL)
		  wMemReg_sel = 2'b10;
		else
		  wMemReg_sel = 2'b00;
		
		//Reg wsel Select
		//00 -> rd
		//01 -> rt
		//10 -> r[31]
		if(iinstr.opcode == JAL)
		  regW_sel = 2'b10;
		else if(iinstr.opcode == RTYPE || iinstr.opcode == VTYPE)
		  regW_sel = 2'b00;
		else
		  regW_sel = 2'b01;
		
		//PC Select
		// 00 -> PC+4 / PC+4+branch
		// 01 -> Register
		// 10 -> Jump
		if(iinstr.opcode == JAL || iinstr.opcode == J)
		  pc_sel = 2'b10;
		else if(rinstr.opcode == RTYPE && rinstr.funct == JR)
		  pc_sel = 2'b01;
		else if((iinstr.opcode == VBNE || iinstr.opcode == VBEQ) && t_vbrEn == mask)
		  pc_sel = 2'b11;
		else
		  pc_sel = 2'b00;
		
		//Memory Read Enable
		memREN = (iinstr.opcode == LW || iinstr.opcode == VLW || iinstr.opcode == VLWO) ? 1 : 0;
		
		//Memory Write Enable
		memWEN = (iinstr.opcode == SW || iinstr.opcode == VSW || iinstr.opcode == VSWO) ? 1 : 0;
		
		//Register Write Enable
		sregWEN = ((rinstr.opcode == RTYPE && rinstr.funct == JR) || 
				   (isVector) ||
//				   (isMask) ||
				   (iinstr.opcode == SYNC) ||
				   (iinstr.opcode == BEQ) ||
				   (iinstr.opcode == BNE) || 
				   (iinstr.opcode == SW)) ? 0 : 1;
		
		//Branch Enable
		if((iinstr.opcode == BEQ && szf == 1) || (iinstr.opcode == BNE && szf == 0))
		  brEn = 1'b1;
		else
		  brEn = 1'b0;
     end // always_comb
   
   generate
      for(i = 0; i < THREADS; i++)
		begin : regwen
		   always_comb
			 begin
				if ( iinstr.opcode == VSW || iinstr.opcode == VSWO || iinstr.opcode == VBNE || iinstr.opcode == VBEQ || !isVector )
				  vregWEN[i] = 1'b0;
				else
				  vregWEN[i] = mask[i];
				if((iinstr.opcode == VBEQ && vzf[i] == 1) || (iinstr.opcode == VBNE && vzf[i] == 0))
				  t_vbrEn[i] = mask[i];
				else
				  t_vbrEn[i] = 1'b0;
							   
				vbrEn[i] = t_vbrEn[i];
			 end
		end
   endgenerate
   
   always_comb
     begin : vop
		// ALUOP
		if(rinstr.opcode == RTYPE || rinstr.opcode == VTYPE)
		  begin
			 case(rinstr.funct)
			   SLL: 
				 begin
					sOp = ALU_SLL;
				 end
			   SRL: 
				 begin
					sOp = ALU_SRL;
				 end
			   ADD, ADDU: 
				 begin
					sOp = ALU_ADD;
				 end
			   SUB, SUBU:
				 begin
					sOp = ALU_SUB;
				 end
			   AND : 
				 begin 
					sOp = ALU_AND;
				 end
			   OR : 
				 begin
					sOp = ALU_OR;
				 end
			   XOR : 
				 begin
					sOp = ALU_XOR;
				 end
			   NOR : 
				 begin
					sOp = ALU_NOR;
				 end
			   SLT : 
				 begin
					sOp = ALU_SLT;
				 end
			   SLTU : 
				 begin
					sOp = ALU_SLTU;
				 end
			   default : 
				 begin
					sOp = '{default:'x}; //Find out how to make it x
				 end
			 endcase // case (r_instr.funct)
		  end
		else
		  begin
			 case(iinstr.opcode)
			   ADDI, ADDIU, SW, LW: 
				 begin
					sOp = ALU_ADD;
				 end
			   LUI: 
				 begin
					sOp = ALU_SLL;
				 end
			   ANDI :
				 begin
					sOp = ALU_AND;
				 end
			   ORI : 
				 begin
					sOp = ALU_OR;
				 end
			   XORI : 
				 begin
					sOp = ALU_XOR;
				 end
			   BEQ, BNE: 
				 begin
					sOp = ALU_SUB;
				 end
			   SLTI: 
				 begin
					sOp = ALU_SLT;
				 end
			   SLTIU: 
				 begin
					sOp = ALU_SLTU;
				 end
			   default : 
				 begin
					sOp = '{default:'x}; //Find out how to make it x
				 end
			 endcase // case (iinstr.opcode)
		  end // else: !if(rinstr.opcode == RTYPE)
     end // always_comb

   generate
      for ( i = 0; i < THREADS; i++)
		begin : verop
		   always_comb
			 begin
				// ALUOP
				if(rinstr.opcode == RTYPE || rinstr.opcode == VTYPE || rinstr.opcode == MVTYPE)
				  begin
					 case(rinstr.funct)
					   SLL: 
						 begin
							vOp[i] = ALU_SLL;
						 end
					   SRL: 
						 begin
							vOp[i] = ALU_SRL;
						 end
					   ADD, ADDU:
						 begin
							vOp[i] = ALU_ADD;
						 end
					   SUB, SUBU:
						 begin
							vOp[i] = ALU_SUB;
						 end
					   AND : 
						 begin 
							vOp[i] = ALU_AND;
						 end
					   OR : 
						 begin
							vOp[i] = ALU_OR;
						 end
					   XOR : 
						 begin
							vOp[i] = ALU_XOR;
						 end
					   NOR : 
						 begin
							vOp[i] = ALU_NOR;
						 end
					   SLT : 
						 begin
							vOp[i] = ALU_SLT;
						 end
					   SLTU : 
						 begin
							vOp[i] = ALU_SLTU;
						 end
					   default : 
						 begin
							vOp[i] = '{default:'x}; //Find out how to make it x
						 end
					 endcase // case (r_instr.funct)
				  end
				else
				  begin
					 case(iinstr.opcode)
					   VADDI, MVADDI, VADDIU, MVADDIU, VSW, VLW, VLWO, VSWO: 
						 begin
							vOp[i] = ALU_ADD;
						 end
					   VLUI, MVLUI: 
						 begin
							vOp[i] = ALU_SLL;
						 end
					   VANDI, MVANDI:
						 begin
							vOp[i] = ALU_AND;
						 end
					   VORI, MVORI: 
						 begin
							vOp[i] = ALU_OR;
						 end
					   VXORI, MVXORI: 
						 begin
							vOp[i] = ALU_XOR;
						 end
					   VBEQ, VBNE: 
						 begin
							vOp[i] = ALU_SUB;
						 end   
					   VSLTI: 
						 begin
							vOp[i] = ALU_SLT;
						 end
					   VSLTIU: 
						 begin
							vOp[i] = ALU_SLTU;
						 end
					   default : 
						 begin
							vOp[i] = '{default:'x}; //Find out how to make it x
						 end
					 endcase // case (iinstr.opcode)
				  end // else: !if(rinstr.opcode == RTYPE)
			 end // always_comb
		end // for ( i = 0; i < THREADS; i++)
   endgenerate
   
endmodule // control_unit
