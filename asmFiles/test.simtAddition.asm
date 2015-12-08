
		#--------------------------------------------------
		# Increment a vector certain number of times, but
		# don't exceed a certain value. To demo simt divergence.
		#--------------------------------------------------
		
		org 0x0000
		# Init stack	
		s.ori $29, $0, 0xFFFC
		# Counter
		s.ori $2, $0, 0
		# Load data
		s.ori $1, $0, 0x0A00
		v.lwo $1, 4($1)
		# Load target
		s.ori $1, $0, 0x0B00
		v.lwo $2, 0($1)
		v.ori $3, $0, 0
		setSync exit
incr:
		v.sltiu $4, $1, 0x50
		v.beq $4, $0, exit
		v.addiu $1, $1, 0x10
		v.addiu $3, $3, 0x01
		s.addiu $2, $2, 1
jump:	
		j incr
exit:	
		s.ori $1, $0, 0x0A00
		s.ori $2, $0, 0x0C00
		v.swo $1, 4($1)
		v.swo $3, 4($2)
		halt
		
		org 0x0A00
		# Data
		cfw 0x10
		cfw 0x20
		cfw 0x30
		cfw 0x40
		# Target
		org 0x0B00
		cfw 0x50
