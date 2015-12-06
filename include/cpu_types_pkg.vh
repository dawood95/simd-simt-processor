/*
 Sheik Dawood
 dawood0@purdue.edu

 all types used to make life easier.
 */
`ifndef CPU_TYPES_PKG_VH
 `define CPU_TYPES_PKG_VH
package cpu_types_pkg;

   // word width and size
   parameter WORD_W    = 32;
   parameter WBYTES    = WORD_W/8;

   // instruction format widths
   parameter OP_W      = 6;
   parameter REG_W     = 5;
   parameter SHAM_W    = REG_W;
   parameter FUNC_W    = OP_W;
   parameter IMM_W     = 16;
   parameter ADDR_W    = 26;

   // alu op width
   parameter AOP_W     = 4;

   // icache format widths
   parameter ITAG_W    = 26;
   parameter IIDX_W    = 4;
   parameter IBLK_W    = 0; // <- important
   parameter IBYT_W    = 2;

   // dcache format widths
   parameter DTAG_W    = 26;
   parameter DIDX_W    = 3;
   parameter DBLK_W    = 1;
   parameter DBYT_W    = 2;
   parameter DWAY_ASS  = 2;

   // opcodes
   // opcode type
   typedef enum logic [OP_W-1:0] 
				{
				 // rtype - use funct
				 RTYPE   = 6'b000000, // 0
				 
				 // jtype
				 J       = 6'b000010, // 2
				 JAL     = 6'b000011, // 3
				
				 // itype
				 BEQ     = 6'b000100, // 4
				 BNE     = 6'b000101, // 5
				 ADDI    = 6'b001000, // 8
				 ADDIU   = 6'b001001, // 9
				 SLTI    = 6'b001010, // 10
				 SLTIU   = 6'b001011, // 11
				 ANDI    = 6'b001100, // 12
				 ORI     = 6'b001101, // 13
				 XORI    = 6'b001110, // 14
				 LUI     = 6'b001111, // 15
				 LW      = 6'b010011, // 19
				 SW      = 6'b011011, // 27
				 LL      = 6'b010000, // 16
				 SC      = 6'b011000, // 24
				
				 // vtype - use funct
				 VTYPE   = 6'b100000,
				
				 // vitype
				 VBEQ     = 6'b110110,
				 VBNE     = 6'b110101,
				 VADDI    = 6'b101000,
				 VADDIU   = 6'b101001,
				 VSLTI    = 6'b101010,
				 VSLTIU   = 6'b101011,
				 VANDI    = 6'b101100,
				 VORI     = 6'b101101,
				 VXORI    = 6'b101110,
				 VLUI     = 6'b101111,
				 VLW      = 6'b110011,
				 VSW      = 6'b111011,
				 VLWO     = 6'b110001,
				 VSWO     = 6'b111001,

				 MVTYPE   = 6'b110000,
				
				 // mvitype
				 MVADDI    = 6'b110010,
				 MVADDIU   = 6'b110100,
				 MVANDI    = 6'b110111,
				 MVORI     = 6'b111000,
				 MVXORI    = 6'b111010,
				 MVLUI     = 6'b111100,

				 // mask types
				 MLT     = 6'b100001,
				 MLTU    = 6'b100010,
				 MEQ     = 6'b100011,
				 MINV    = 6'b100101,
				
				 // halt
				 HALT     = 6'b111111
				
				 } opcode_t;
   
   // rtype funct op type
   typedef enum logic [FUNC_W-1:0] 
				{
				 SLL     = 6'b000000,
				 SRL     = 6'b000010,
				 JR      = 6'b001000,
				 ADD     = 6'b100000,
				 ADDU    = 6'b100001,
				 SUB     = 6'b100010,
				 SUBU    = 6'b100011,
				 AND     = 6'b100100,
				 OR      = 6'b100101,
				 XOR     = 6'b100110,
				 NOR     = 6'b100111,
				 SLT     = 6'b101010,
				 SLTU    = 6'b101011
				 } funct_t;

   // alu op type
   typedef enum logic [AOP_W-1:0] 
				{
				 ALU_SLL     = 4'b0000,
				 ALU_SRL     = 4'b0001,
				 ALU_ADD     = 4'b0010,
				 ALU_SUB     = 4'b0011,
				 ALU_AND     = 4'b0100,
				 ALU_OR      = 4'b0101,
				 ALU_XOR     = 4'b0110,
				 ALU_NOR     = 4'b0111,
				 ALU_SLT     = 4'b1010,
				 ALU_SLTU    = 4'b1011
				 } aluop_t;

   // instruction format types
   // register bits types
   typedef logic [REG_W-1:0] regbits_t;

   // j type
   typedef struct 			 packed {
      opcode_t            opcode;
      logic [ADDR_W-1:0] 	 addr;
   } j_t;
   // i type
   typedef struct 			 packed {
      opcode_t            opcode;
      regbits_t           rs;
      regbits_t           rt;
      logic [IMM_W-1:0] 	 imm;
   } i_t;
   // r type
   typedef struct 			 packed {
      opcode_t            opcode;
      regbits_t           rs;
      regbits_t           rt;
      regbits_t           rd;
      logic [SHAM_W-1:0] 	 shamt;
      funct_t             funct;
   } r_t;

   // cache address format types
   // icache format type
   typedef struct 			 packed {
      logic [ITAG_W-1:0] 	 tag;
      logic [IIDX_W-1:0] 	 idx;
      logic [IBYT_W-1:0] 	 bytoff;
   } icachef_t;

   // dcache format type
   typedef struct 			 packed {
      logic [DTAG_W-1:0] 	 tag;
      logic [DIDX_W-1:0] 	 idx;
      logic [DBLK_W-1:0] 	 blkoff;
      logic [DBYT_W-1:0] 	 bytoff;
   } dcachef_t;

   // word_t
   typedef logic [WORD_W-1:0] word_t;

   // memory state
   // ramstate
   typedef enum 			  logic [1:0] {
										   FREE,
										   BUSY,
										   ACCESS,
										   ERROR
										   } ramstate_t;

endpackage // cpu_types_pkg
   
`endif //CPU_TYPES_PKG_VH
   
