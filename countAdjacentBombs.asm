.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
# your code here 
save_context
 #$to: contador $t1:row, $t2:col
 li $t0,0 #aqui inicializamos nosso contador
 sw $t5,8 #size
 
 
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
	blt $t1,$zero, else
	bge $t1,$t5, else
	blt $t2,$zero, else
	bge $t2,$t5, else
	mul $t6,$t1,$t5 # t6 receber t1=1 * t5= 8
	add $t6,$t6,$t2 #t6 recebe o resultado anterior e soma com o j:t2
	sll $t6,$t6,2 # t6 recebe o res anterior e multipliva por 4. da 28 a 30 fazemos isso ((i*size +j)*4)
	add $t6,$t6,256 #((i*size +j)*4)+256, comecando do inicio da matriz
	li  $t7,-1   #salvando o -1 para usar posteriormente
	bne $t6,$t7,else
	addi $t0,$t0,1
	else:
	addi $t2,$t2,1
	j for_contadj_j
 
