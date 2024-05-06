.data
    .globl main

# Memory layout of the Configuration
# |   eca  |   tape   |  tape_len  |  rule  |  skip  | column |
# | 1 word |  1 word  |   1 byte   | 1 byte | 1 byte | 1 byte |
automaton:
  .word 1       # eca
  .word 252     # tape
  .byte 8       # tape_len
  .byte 16     # rule
  .byte 1       # skip
  .byte 5       # column

.text

main:
  li $s0 8
loop:
  beqz $s0 end
  subi $s0 $s0 1
  la $a0 automaton
  jal print_tape
  la $a0 automaton
  jal simulate_automaton
  j loop
end:
  li      $v0 10
  syscall
