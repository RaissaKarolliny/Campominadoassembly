.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
# your code here 
save_context
 #$to: contador $t1:x, $t2:y
 li $t0,0 #aqui inicializamos nosso contador
 
 addi $t3,$t1,1
 addi $t4,$t2,1
 
 addi $t1,$t1,-2
 addi $t2,$t2,-1
 
 for_contadj_i:
   addi $t1,$t1,1
   bgt $t1,$t3, final
   addi $t2,$t4,-2
   for_contadj_j:
 	bgt $t2,$t4, for_contadj_i
	#if
	addi $t2,$t2,1
	j for_contadj_j
 
