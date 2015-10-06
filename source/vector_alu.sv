/* Sheik Dawood 
 * dawood0@purdue.edu
 *
 * Vector ALU
 */

`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module vector_alu #(parameter THREADS = 4)
   (
    vector_alu_if.alu alu
    );
   
   import cpu_types_pkg::*;

   genvar i;
   
   generate
      for(i = 0; i < THREADS; i++)
	begin : v_alu
	   always_comb
	     begin
		casez (alu.op[i])
		  ALU_SLL: 
		    begin
		       alu.out[i] = alu.porta[i] << alu.portb[i];
		       alu.of[i] = 0;
		    end
		  ALU_SRL: 
		    begin
		       alu.out[i] = alu.porta[i] >> alu.portb[i];
		       alu.of[i] = 0;
		    end
		  ALU_ADD: 
		    begin
		       alu.out[i] = $signed(alu.porta[i]) + $signed(alu.portb[i]);
		       alu.of[i] = ~(alu.porta[i][WORD_W-1] ^ alu.portb[i][WORD_W-1]) & (alu.porta[i][WORD_W-1] ^ alu.out[i][WORD_W-1]);
		    end
		  
		  ALU_SUB:
		    begin
		       alu.out[i] = $signed(alu.porta[i]) - $signed(alu.portb[i]);
		       alu.of[i] = (alu.porta[i][WORD_W-1] ^ alu.portb[i][WORD_W-1]) & (alu.porta[i][WORD_W-1] ^ alu.out[i][WORD_W-1]);
		    end
		  ALU_AND: 
		    begin
		       alu.out[i] = alu.porta[i] & alu.portb[i];
		       alu.of[i] = 0;
		    end
		  ALU_OR:  
		    begin
		       alu.out[i] = alu.porta[i] | alu.portb[i];
		       alu.of[i] = 0;
		    end
		  ALU_XOR:
		    begin
		       alu.out[i] = alu.porta[i] ^ alu.portb[i];
		       alu.of[i] = 0;
		    end
		  ALU_NOR: 
		    begin
		       alu.out[i] = ~(alu.porta[i] | alu.portb[i]);
		       alu.of[i] = 0;
		    end
		  ALU_SLT: 
		    begin 
		       alu.out[i] = ($signed(alu.porta[i]) < $signed(alu.portb[i])) ? 1 : 0;
		       alu.of[i] = 0;
		       
		    end
		  ALU_SLTU: 
		    begin
		       alu.out[i] = ($unsigned(alu.porta[i]) < $unsigned(alu.portb[i])) ? 1 : 0;
		       alu.of[i] = 0;
		    end
		  default: 
		    begin
		       alu.out[i] = 0;
		       alu.of[i] = 0;
		    end
		endcase // case (alu.op)
		alu.zf[i] = (alu.out[i] == 0) ? 1'b1 : 1'b0;
		alu.nf[i] = ($signed(alu.out[i]) < 0) ? 1'b1 : 1'b0;
	     end // always_comb
	end // block: v_alu
      
   endgenerate
   
endmodule // alu


