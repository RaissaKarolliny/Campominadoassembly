.include "macros.asm"

.globl checkVictory

checkVictory:

save_context  # Salvando o contexto
	move $s0, $a0  # Recebe o endere�o base da matriz
	move $t0, $zero  # Inicializa o contador para a contagem de c�lulas reveladas
	li $t5, SIZE  # Carrega o tamanho da matriz (assumindo que SIZE � uma constante definida em 'macros.asm')
	li $t1, -1  # Inicializa o �ndice i como 0

# Loop for para a contagem de i
	for_i:
		addi $t1, $t1, 1  # Incrementa i
 		bge $t1, $t5, final  # Se i for maior ou igual a SIZE, termina o loop
 		li $t2, 0  # Inicializa o �ndice j como 0

# Loop for para a contagem de j
 	for_j:
 		bge $t2, $t5, for_i  # Se j for maior ou igual a SIZE, continua com o pr�ximo i
 		mul $t6, $t1, $t5  # Calcula o �ndice da c�lula (i * SIZE)
 		add $t6, $t6, $t2  # Adiciona a posi��o de j ao �ndice
 		sll $t6, $t6, 2  # Multiplica o �ndice por 4 para acessar a posi��o na mem�ria
 		add $s6, $t6, $s0  # Calcula o endere�o da c�lula na matriz
 		lw $t9, 0($s6)  # Carrega o valor da c�lula
 	 
 		addi $t2, $t2, 1  # Incrementa j
 		blt $t9, $zero, for_j  # Se o valor da c�lula for menor que zero (n�o revelada), continua com o pr�ximo j
 		addi $t0, $t0, 1  # Se o valor da c�lula for maior ou igual a zero (revelada), incrementa o contador
 		j for_j

	final:
		mul $t5, $t5, $t5  # Calcula o total de c�lulas na matriz
		li $t8, BOMB_COUNT  # Carrega a quantidade de bombas (assumindo que BOMB_COUNT � uma constante definida em 'macros.asm')
		sub $t5, $t5, $t8  # Subtrai a quantidade de bombas do total de c�lulas
		beq $t0, $t5, vitoria  # Se o contador for igual ao n�mero de c�lulas n�o bomba, vai para 'vitoria'
		li $v0, 0  # Define 0 (derrota)
		restore_context  # Restaura o contexto
		jr $ra  # Retorna

	vitoria:
		li $v0, 1  # Define 1 (vit�ria)
		restore_context  # Restaura o contexto
		jr $ra  # Retorna
