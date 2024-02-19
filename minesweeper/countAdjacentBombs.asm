.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context

# Recebendo dados e definindo valores de controle
	
	move $s0, $a2  # Recebe a posi��o inicial da matriz
	move $s1, $a0  # Recebe o valor de i (linha)
	move $s2, $a1  # Recebe o valor de j (coluna)
	move $t0, $zero  # Inicializa o contador de bombas adjacentes como zero

	addi $s3, $s1, 1  # Incrementa i para iterar sobre as c�lulas acima
	addi $s4, $s2, 1  # Incrementa j para iterar sobre as c�lulas � direita
 
	addi $s1, $s1, -2  # Decrementa i para iterar sobre as c�lulas abaixo
	addi $s2, $s2, -1  # Decrementa j para iterar sobre as c�lulas � esquerda
 
	li $s7, -1   # Define -1 para uso posterior (valor de c�lula de bomba)
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
		bne $t9, $s7, else  # Se n�o for uma bomba, v� para 'else'
		addi $t0, $t0, 1  # Incrementa o contador de bombas adjacentes
   
	else:
		addi $s2, $s2, 1  # Incrementa j
		j for_contadj_j  # Volta para o loop de j
  
	final:
		restore_context  # Restaura o contexto
		move $v0, $t0  # Move o n�mero de bombas adjacentes para o retorno da fun��o
		jr $ra  # Retorna
