# vim:sw=2 syntax=asm
.data

.text
  .globl gen_byte, gen_bit

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Compute the next valid byte (00, 01, 10) and put into $v0
#  If 11 would be returned, produce two new bits until valid
#
gen_byte:
  # TODO
  
  move $t0 $ra 
  jal gen_bit
  
  loop:
  	
  jr $ra

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Look at the field {eca} and use the associated random number generator to generate one bit.
#  Put the computed bit into $v0
#
gen_bit:
  # TODO
  move $t1 $a0
  lw $a0 0($a0)
  li $v0 41
  syscall
  
  andi $v0 $a0 1
  move $a0 $t1 #testing commit 
  
  jr $ra
