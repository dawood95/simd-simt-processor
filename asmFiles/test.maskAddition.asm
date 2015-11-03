
				#--------------------------------------------------
				# Increment a vector certain number of times, but
				# don't exceed a certain value. To demo masks.
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
incr:
				sltiu $3, $2, 5
				beq $3, $0, exit
				mltu $1, $2
				m.v.addiu $1, $1, 0x10
				s.addiu $2, $2, 1
				j incr
exit:
				s.ori $1, $0, 0x0A00 
				v.swo $1, 4($1)
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
