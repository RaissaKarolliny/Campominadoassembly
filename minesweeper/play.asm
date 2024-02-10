.include "macros.asm"

.globl play

play:
 save_context

#Recebendo dados e definindo valores de controle
#<!=========================
 move $s0, $a2 #recebendo a pos ini da matriz
 move $s1, $a0 # passanso i para s1
 move $s2, $a1 # passando j para s2
 
 li $t5, SIZE #size
 li $t7, -1   #salvando o -1 para usar posteriormente
 li $t8, -2
#=========================!>

#Acessa valor da matriz
#<!=========================
 mul $t6,$s1,$t5 # t6 receber t1=1 * t5= 8
 add $t6,$t6,$s2 #t6 recebe o resultado anterior e soma com o j:t2
 sll $t6,$t6,2 # t6 recebe o res anterior e multipliva por 4. da 28 a 30 fazemos isso ((i*size +j)*4)
 add $s6,$t6,$s0
 
 lw $t9, 0($s6) #acessando valor que está no indice t6 e colocando em t9
#=========================!>
 
#Condicionais
#<!=========================
 beq $t9,$t7, perdeu
 bne $t9,$t8, revelado
#=========================!>
 
#Salvando dados e chamando a função 'countAdjacentBombs'
#<!=========================
 move $a0, $s1  # movendo o i para a0
 move $a1, $s2  # movendo j para a1
 move $a2, $s0 # movendo a pos ini de $s0 para $a2
 
 jal countAdjacentBombs
#=========================!>
   
 move $t0,$v0 # t0 recebe o num de bombas
 sw $t0, 0($s6) # passando o nmero de bombas para a posição
 
 bne $t0,$zero,revelado
 
#Salvando dados e chamando a função 'revealNeighboringCells'
#<!=========================
 move $a0, $s1  # movendo o i para a0
 move $a1, $s2  # movendo j para a1
 move $a2, $s0 # movendo a pos ini de $s0 para $a2
 
 jal revealNeighboringCells
 
#=========================!>
 
 revelado:
 restore_context
 li $v0, 1
 jr $ra
 
 perdeu:
 restore_context
 li $v0, 0
 jr $ra
 
	
