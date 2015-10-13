# SIMD/SIMT Processor


### ISA

#### reserved registers

$0  --> zero  
$1  --> assembler temporary  
$29 --> stack pointer  
$31 --> return address  

#### R-type Instructions

s.ADDU	$rd,$rs,$rt   	R[rd] <= R[rs] + R[rt] (unchecked overflow)  
s.ADD	$rd,$rs,$rt   	R[rd] <= R[rs] + R[rt]  
s.AND   $rd,$rs,$rt   	R[rd] <= R[rs] AND R[rt]  
JR     	$rs		PC <= R[rs]   
s.NOR   $rd,$rs,$rt   	R[rd] <= ~(R[rs] OR R[rt])  
s.OR    $rd,$rs,$rt   	R[rd] <= R[rs] OR R[rt]  
s.SLT   $rd,$rs,$rt   	R[rd] <= (R[rs] < R[rt]) ? 1 : 0  
s.SLTU  $rd,$rs,$rt   	R[rd] <= (R[rs] < R[rt]) ? 1 : 0  
s.SLL   $rd,$rs,shamt 	R[rd] <= R[rs] << shamt  
s.SRL   $rd,$rs,shamt 	R[rd] <= R[rs] >> shamt  
s.SUBU 	$rd,$rs,$rt   	R[rd] <= R[rs] - R[rt] (unchecked overflow)  
s.SUB  	$rd,$rs,$rt   	R[rd] <= R[rs] - R[rt]  
s.XOR   $rd,$rs,$rt   	R[rd] <= R[rs] XOR R[rt]  

#### I-type Instructions

s.ADDIU  $rt,$rs,imm   	R[rt] <= R[rs] + SignExtImm (unchecked overflow)  
s.ADDI   $rt,$rs,imm   	R[rt] <= R[rs] + SignExtImm  
s.ANDI   $rt,$rs,imm  	R[rt] <= R[rs] & ZeroExtImm  
BEQ    	 $rs,$rt,label 	PC <= (R[rs] == R[rt]) ? npc+BranchAddr : npc  
BNE    	 $rs,$rt,label 	PC <= (R[rs] != R[rt]) ? npc+BranchAddr : npc  
s.LUI    $rt,imm       	R[rt] <= {imm,16b'0}  
s.LW     $rt,imm($rs)  	R[rt] <= M[R[rs] + SignExtImm]  
s.ORI    $rt,$rs,imm   	R[rt] <= R[rs] OR ZeroExtImm  
s.SLTI   $rt,$rs,imm   	R[rt] <= (R[rs] < SignExtImm) ? 1 : 0  
s.SLTIU  $rt,$rs,imm   	R[rt] <= (R[rs] < SignExtImm) ? 1 : 0  
s.SW     $rt,imm($rs)  	M[R[rs] + SignExtImm] <= R[rt]  
s.LL     $rt,imm($rs)  	R[rt] <= M[R[rs] + SignExtImm]; rmwstate <= addr  
s.SC     $rt,imm($rs)  	if (rmw) M[R[rs] + SignExtImm] <= R[rt], 
			   	R[rt] <= 1   
			else 
				R[rt] <= 0  
s.XORI   $rt,$rs,imm   	R[rt] <= R[rs] XOR ZeroExtImm  

#### V-type Instructions

v.ADDU		$rd,$rs,$rt   	V[rd] <= V[rs] + V[rt] (unchecked overflow)  
v.ADD    	$rd,$rs,$rt   	V[rd] <= V[rs] + V[rt]   
v.AND    	$rd,$rs,$rt   	V[rd] <= V[rs] AND V[rt]  
v.NOR    	$rd,$rs,$rt   	V[rd] <= ~(V[rs] OR [rt])  
v.OR     	$rd,$rs,$rt   	V[rd] <= V[rs] OR V[rt]  
v.SLT    	$rd,$rs,$rt   	V[rd] <= (V[rs] < V[rt]) ? 1 : 0   
v.SLTU   	$rd,$rs,$rt   	V[rd] <= (V[rs] < V[rt]) ? 1 : 0  
v.SLL    	$rd,$rs,shamt 	V[rd] <= V[rs] << shamt  
v.SRL    	$rd,$rs,shamt 	V[rd] <= V[rs] >> shamt  
v.SUBU 		$rd,$rs,$rt   	V[rd] <= V[rs] - V[rt] (unchecked overflow)  
v.SUB  		$rd,$rs,$rt   	V[rd] <= V[rs] - V[rt]  
v.XOR    	$rd,$rs,$rt   	V[rd] <= V[rs] XOR V[rt]  

#### VI-type Instructions

v.ADDIU  	$rt,$rs,imm   	V[rt] <= V[rs] + SignExtImm (unchecked overflow)  
v.ADDI   	$rt,$rs,imm   	V[rt] <= V[rs] + SignExtImm  
v.ANDI  	$rt,$rs,imm  	V[rt] <= V[rs] & ZeroExtImm  
v.LUI    	$rt,imm       	V[rt] <= {imm,16b'0}  
v.LW     	$rt,imm($rs)  	V[rt] <= M[V[rs] + SignExtImm]  
V.LWO		$rt,off($rs)    V[rt] <= {M[S[rs]],M[S[rs]+off]...M[S[rs]+(THREADS-1)*off]}
v.ORI    	$rt,$rs,imm   	V[rt] <= V[rs] OR ZeroExtImm  
v.SLTI   	$rt,$rs,imm   	V[rt] <= (V[rs] < SignExtImm) ? 1 : 0  
v.SLTIU 	$rt,$rs,imm   	V[rt] <= (V[rs] < SignExtImm) ? 1 : 0  
v.SW     	$rt,imm($rs)  	M[V[rs] + SignExtImm] <= V[rt]
V.SWO		$rt,off($rs)    {M[S[rs]],M[S[rs]+off]...M[S[rs]+(THREADS-1)*off]} <= V[rt]
v.XORI   	$rt,$rs,imm   	V[rt] <= V[rs] XOR ZeroExtImm  

#### J-type Instructions

J      	label         PC <= JumpAddr  
JAL    	label         R[31] <= npc; PC <= JumpAddr  

#### Other Instructions

HALT  

#### Pseudo Instructions

PUSH  	$rs          $29 <= $29 - 4; Mem[$29+0] <= R[rs] (sub+sw)  
POP   	$rt          R[rt] <= Mem[$29+0]; $29 <= $29 + 4 (add+lw)  
NOP                  Nop  

#### Other 

org  Addr         	Set the base address for the code to follow   
cfw  #            	Assign value to word of memory  
