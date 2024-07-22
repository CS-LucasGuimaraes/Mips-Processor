jal main

.data 
  values: .word 0, 40, 0

.text

wait: 
   addi $t1, $0, 0
   
   while_wait_begin: 
      addi $t1, $t1, 1
   bne $t1, $a0, while_wait_begin
     
   jr $ra

main:

   lw $s0, 0($0)
   lw $s1, 4($0)
        
   addi $t0, $0, 0

   while_main_begin: 
   
      if_main_begin:
      bne $s0, $0, else_main_begin

      addi $a0, $0, 10
      jal wait

      jal if_else_main_end

      else_main_begin: 

      addi $a0, $0, 20
      jal wait

      if_else_main_end:

      addi $t0, $t1, 1

      sw $t0, 8($0)

   bne $t0, $s1, while_wait_begin