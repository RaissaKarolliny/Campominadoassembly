.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
save_context
move $s0,$a2 #recebendo a pos ini da matriz
move $s1,$a0 # passanso i para s1
move $s2,$a1 # passando j para s2

 li $t5,SIZE #size
 
 addi $t3,$s1,1
 addi $t4,$s2,1
 
 addi $s1,$s1,-2
 addi $s2,$s2,-1
 li $t7,-2
 
 for_contadj_i:
   addi $s1,$s1,1
   bgt $s1,$t3, final
   addi $s2,$t4,-2
   for_contadj_j:
 	bgt $s2,$t4, for_contadj_i
	blt $s1,$zero, else
	bge $s1,$t5, else
	blt $s2,$zero, else	
	bge $s2,$t5, else
	mul $t6,$s1,$t5 # t6 receber t1=1 * t5= 8
	add $t6,$t6,$s2 #t6 recebe o resultado anterior e soma com o j:t2
	sll $t6,$t6,2 # t6 recebe res anterior e mul por 4. da 28 a 30 fazemos((i*size +j)*4)
	add $t6,$t6,$s0 #somando com a pos ini 
	lw $t9, 0 ($t6) #acessando valor que está no indice t6 e colocando em t9
	bne $t9,$t7,else
	move $a0, $s0
	move $a1, $t1
	move $a2, $t2
	
	jal countAdjacentBombs
	
	move $t0, $v0 # passando o numero de bombas
	sw $t0, 0($t6)
	bne $t0,$zero,else
	jal revealNeighboringCells
	
	else:
	addi $s2,$s2,1
	j for_contadj_j
	
	final:
	restore_context
	jr $ra
	
