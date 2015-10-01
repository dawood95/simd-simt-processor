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
	   scalar_alu ALU(
			  .\alu.nf (alu.nf[i]),
			  .\alu.zf (alu.zf[i]),
			  .\alu.of (alu.of[i]),
			  .\alu.porta (alu.porta[i]),
			  .\alu.portb (alu.portb[i]),
			  .\alu.out (alu.out[i]),
			  .\alu.op (alu.op[i])
			  );
	end
   endgenerate
   
endmodule // alu

    
