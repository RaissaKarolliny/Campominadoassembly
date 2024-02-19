.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	save_context

# Recebendo dados e definindo valores de controle
	move $s0, $a2  # Recebe a posi��o inicial da matriz
	move $s1, $a0  # Recebe o valor de i (linha)
	move $s2, $a1  # Recebe o valor de j (coluna)

	addi $s3, $s1, 1  # Incrementa i para iterar sobre as c�lulas acima
	addi $s4, $s2, 1  # Incrementa j para iterar sobre as c�lulas � direita
 
	addi $s1, $s1, -2  # Decrementa i para iterar sobre as c�lulas abaixo
	addi $s2, $s2, -1  # Decrementa j para iterar sobre as c�lulas � esquerda
 
	li $s7, -2  # Define -2 para uso posterior (valor de c�lula n�o revelada)
	li $t5, SIZE  # Carrega o tamanho da matriz (assumindo que SIZE � uma constante definida em 'macros.asm')

# Loop for para a contagem de i
	for_contadj_i:
		addi $s1, $s1, 1  # Incrementa i
		bgt $s1, $s3, final  # Se i for maior que s3, termina o loop
		addi $s2, $s4, -2  # Reinicializa j para a posi��o da c�lula � esquerda da linha atual

  # Loop for para a contagem de j
	for_contadj_j:
		bgt $s2, $s4, for_contadj_i  # Se j for maior que s4, termina o loop de j e continua com o pr�ximo i
		blt $s1, $zero, else  # Se i for menor que zero, v� para 'else'
		bge $s1, $t5, else  # Se i for maior ou igual ao tamanho da matriz, v� para 'else'
		blt $s2, $zero, else  # Se j for menor que zero, v� para 'else'
		bge $s2, $t5, else  # Se j for maior ou igual ao tamanho da matriz, v� para 'else'
   
		mul $t6, $s1, $t5  # Calcula o �ndice da c�lula (i * SIZE)
		add $t6, $t6, $s2  # Adiciona a posi��o de j ao �ndice
		sll $t6, $t6, 2  # Multiplica o �ndice por 4 para acessar a posi��o na mem�ria
		add $s6, $t6, $s0  # Calcula o endere�o da c�lula na matriz
   
		lw $t9, 0 ($s6)  # Carrega o valor da c�lula
		bne $t9, $s7, else  # Se a c�lula j� estiver revelada, v� para 'else'
   
		move $a0, $s1  # Movendo i para o primeiro argumento
		move $a1, $s2  # Movendo j para o segundo argumento
		move $a2, $s0  # Movendo a posi��o inicial da matriz para o terceiro argumento
   
		jal countAdjacentBombs  # Chamada de fun��o para contar bombas adjacentes
   
		move $t0, $v0  # $t0 recebe o n�mero de bombas
		sw $t0, 0 ($s6)  # Salvando o n�mero de bombas na posi��o
   
		bne $t0, $zero, else  # Se h� bombas adjacentes, v� para 'else'
   
		move $a0, $s1  # Movendo i para o primeiro argumento
		move $a1, $s2  # Movendo j para o segundo argumento
		move $a2, $s0  # Movendo a posi��o inicial da matriz para o terceiro argumento
   
		jal revealNeighboringCells  # Chamada de fun��o para revelar c�lulas vizinhas
   
	else:
		addi $s2, $s2, 1  # Incrementa j
		j for_contadj_j  # Volta para o loop de j
  
  # Final do loop
 	final:
		restore_context  # Restaurando o contexto
		jr $ra  # Retorna
