.include "macros.asm"

.globl play

play:
#$t1:row, $t2:col
sw $t5,8 #size
	mul $t6,$t1,$t5 # t6 receber t1=1 * t5= 8
	add $t6,$t6,$t2 #t6 recebe o resultado anterior e soma com o j:t2
	sll $t6,$t6,2 # t6 recebe o res anterior e multipliva por 4. da 28 a 30 fazemos isso ((i*size +j)*4)
	add $t6,$t6,256 #((i*size +j)*4)+256, comecando do inicio da matriz
	li  $t7,-1   #salvando o -1 para usar posteriormente
	beq $t6,$t7, perdeu
	li $t8,-2
	bne $t6,$t8, revelado
	jal contAdjacentBombs
	move $t6,$t0
	bne $t0,$zero,revelado
	jal revealAdjacentCells
	revelado:
	
