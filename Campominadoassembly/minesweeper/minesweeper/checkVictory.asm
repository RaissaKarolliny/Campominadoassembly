.include "macros.asm"

.globl checkVictory

checkVictory:
	 #$to: contador $t1:row, $t2:col
 li $t0,0 #aqui inicializamos nosso contador
 sw $t5,8 #size
 
  li $t1,-1 # i =0
 for_i:
 	addi $t1,1
 	bge $t1,$t5, final
 	li $t2,0
 	for_j;
 		bge $t2,$t5,for_i
 		mul $t6,$t1,$t5 # t6 receber t1=1 * t5= 8
 		add $t6,$t6,$t2 #t6 recebe o resultado anterior e soma com o j:t2
 		sll $t6,$t6,2 # t6 recebe o res anterior e multipliva por 4. da 28 a 30 fazemos isso ((i*size +j)*4)
 		add $t6,$t6,256 #((i*size +j)*4)+256, comecando do inicio da matriz
 		addi $t2,1
 		blt $t6,$zero,for_j #se boar[1][j] < o, volta pro for j
 		addi $t0,1 # se boar[1][j] < o for falso ou seja boar[1][j] >= o, então incrementa o contador
 		j for_j
final:
	mul $t5,$t5,$t5
	lw $s0, BOMB_COUNT
	sub $t5,$t5,$s0
	bge $t0,$t5,vitoria
	li $s1,0
vitoria:
	li $s1,1
	
