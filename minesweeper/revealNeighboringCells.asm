.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
save_context

#Recebendo dados e definindo valores de controle
#<!=========================
 move $s0,$a2 #recebendo a pos ini da matriz
 move $s1,$a0 # passanso i para s1
 move $s2,$a1 # passando j para s2

 addi $t3,$s1,1 #pegamos i somamos 1 e colocamos na variavel de controle
 addi $t4,$s2,1
 
 addi $s1,$s1,-2 #subtraindo para irmos subindo o valor
 addi $s2,$s2,-1 
 
 li $s7,-2 #salvando o -2 para usar posteriormente
 li $t5,SIZE
#=========================!>

#For i para a contagem
#<!=========================
 for_contadj_i:
  addi $s1,$s1,1
  bgt $s1,$t3, final
  addi $s2,$t4,-2
  #For j para a contagem
  #<!=========================
  for_contadj_j:
   bgt $s2,$t4, for_contadj_i
   blt $s1,$zero, else
   bge $s1,$t5, else
   blt $s2,$zero, else
   bge $s2,$t5, else
   
   mul $t6,$s1,$t5 # t6 receber t1=1 * t5= 8
   add $t6,$t6,$s2 #t6 recebe o resultado anterior e soma com o j:t2
   sll $t6,$t6,2 # t6 recebe o res anterior e multipliva por 4. da 28 a 30 fazemos isso ((i*size +j)*4)
   add $s6,$t6,$s0
   
   lw $t9, 0 ($s6) #acessando valor que está no indice t6 e colocando em t9
   
   bne $t9,$s7,else
   
   move $a0, $s1  # movendo o i para a0
   move $a1, $s2  # movendo j para a1
   move $a2, $s0 # movendo a pos ini de $s0 para $a2
   
   jal countAdjacentBombs
   
   move $t0,$v0 # t0 recebe o num de bombas
   sw $t0, 0($s6) # passando o nmero de bombas para a posição
   
   bne $t0,$zero, else
   
   move $a0, $s1  # movendo o i para a0
   move $a1, $s2  # movendo j para a1
   move $a2, $s0 # movendo a pos ini de $s0 para $a2
   
   jal revealNeighboringCells
   
 else:
  addi $s2,$s2,1
  j for_contadj_j
  
 final:
  restore_context
  jr $ra
 

 
