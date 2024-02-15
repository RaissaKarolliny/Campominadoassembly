.include "macros.asm"

.globl checkVictory

checkVictory:

save_context
 move $s0, $a0
 move $t0,$zero #aqui inicializamos nosso contador
 li $t5,SIZE
  li $t1,-1 # i =0
 for_i:
 	addi $t1,$t1,1
 	bge $t1,$t5, final
 	li $t2,0
 	for_j:
 	 bge $t2,$t5,for_i
 	 mul $t6,$t1,$t5 # t6 receber t1=1 * t5= 8
 	 add $t6,$t6,$t2 #t6 recebe o resultado anterior e soma com o j:t2
 	 sll $t6,$t6,2 # t6 recebe res anterior e mul por 4. da 28 a 30 fazemos((i*size +j)*4)
 	 add $s6,$t6,$s0
 	 lw $t9, 0($s6) #acessando valor que está no indice t6 e colocando em t9
 	 
 	 addi $t2,$t2,1
 	 blt $t9,$zero,for_j #se boar[1][j] < o, volta pro for j
 	 addi $t0,$t0,1 # se boar[1][j] < o for falso ou seja boar[1][j] >= o, então incrementa o contador
 	 j for_j
final:
	mul $t5,$t5,$t5
	li $t8, BOMB_COUNT
	sub $t5,$t5,$t8
	beq $t0,$t5,vitoria
	li $v0,0
	restore_context
	jr $ra
vitoria:
	li $v0,1
	restore_context
	jr $ra
	
