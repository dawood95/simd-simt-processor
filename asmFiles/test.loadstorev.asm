
  #------------------------------------------------------------------
  # Tests lui lw sw
  #------------------------------------------------------------------

  org   0x0000
  s.ori   $1,$zero,0xF0
  s.ori   $2,$zero,0xF80
  lui   $7,0xdead
  ori   $7,$7,0xbeef
  v.lwo  $3,4($1)
  v.swo  $3,4($2)
	
  halt      # that's all

  org   0x00F0
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
  cfw   0x1337
