/* Sheik Dawood 
 * dawood0@purdue.edu
 *
 * ALU
 */

`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module scalar_alu(
	   scalar_alu_if.alu alu
	   );
   
   import cpu_types_pkg::*;
   
   always_comb
     begin
	casez (alu.op)
	  ALU_SLL: 
	    begin
	       alu.out = alu.porta << alu.portb;
	       alu.of = 0;
	    end
	  ALU_SRL: 
	    begin
	       alu.out = alu.porta >> alu.portb;
	       alu.of = 0;
	    end
	  ALU_ADD: 
	    begin
	       alu.out = $signed(alu.porta) + $signed(alu.portb);
	       alu.of = ~(alu.porta[WORD_W-1] ^ alu.portb[WORD_W-1]) & (alu.porta[WORD_W-1] ^ alu.out[WORD_W-1]);
	    end
	  
	  ALU_SUB:
	    begin
	       alu.out = $signed(alu.porta) - $signed(alu.portb);
	       alu.of = (alu.porta[WORD_W-1] ^ alu.portb[WORD_W-1]) & (alu.porta[WORD_W-1] ^ alu.out[WORD_W-1]);
	    end
	  ALU_AND: 
	    begin
	       alu.out = alu.porta & alu.portb;
	       alu.of = 0;
	    end
	  ALU_OR:  
	    begin
	       alu.out = alu.porta | alu.portb;
	       alu.of = 0;
	    end
	  ALU_XOR:
	    begin
	       alu.out = alu.porta ^ alu.portb;
	       alu.of = 0;
	    end
	  ALU_NOR: 
	    begin
	       alu.out = ~(alu.porta | alu.portb);
	       alu.of = 0;
	    end
	  ALU_SLT: 
	    begin 
	       alu.out = ($signed(alu.porta) < $signed(alu.portb)) ? 1 : 0;
	       alu.of = 0;
	       
	    end
	  ALU_SLTU: 
	    begin
	       alu.out = ($unsigned(alu.porta) < $unsigned(alu.portb)) ? 1 : 0;
	       alu.of = 0;
	    end
	  default: 
	    begin
	       alu.out = 0;
	       alu.of = 0;
	    end
	endcase // case (alu.op)
	alu.zf = (alu.out == 0) ? 1'b1 : 1'b0;
	alu.nf = ($signed(alu.out) < 0) ? 1'b1 : 1'b0;
     end // always_comb
   

endmodule // alu

    
