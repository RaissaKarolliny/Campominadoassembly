.include "macros.asm"

.globl play

play:
 save_context

# Recebendo dados e definindo valores de controle
 move $s0, $a2  # $s0 recebe a posi��o inicial da matriz
 move $s1, $a0  # $s1 recebe o valor de i (linha)
 move $s2, $a1  # $s2 recebe o valor de j (coluna)
 
 li $t5, SIZE   # Carrega o tamanho da matriz (assumindo que SIZE � uma constante definida em 'macros.asm')
 li $s7, -1     # Define -1 para uso posterior
 li $t8, -2     # Define -2 para uso posterior

# Acessando valor da matriz
 mul $t6, $s1, $t5  # $t6 = i * SIZE
 add $t6, $t6, $s2  # $t6 = (i * SIZE) + j
 sll $t6, $t6, 2    # $t6 = $t6 * 4 (multiplicando por 4 para acessar a posi��o na mem�ria)
 add $s6, $t6, $s0  # $s6 = endere�o base da matriz + (i * SIZE + j) * 4
 
 lw $t9, 0($s6)     # Carrega o valor da matriz no endere�o calculado para $t9
 
# Condi��es
 beq $t9, $s7, perdeu    # Se o valor for -1, o jogador perdeu
 bne $t9, $t8, revelado  # Se o valor n�o for -2, j� foi revelado ou � uma bomba
 
# Salvando dados e chamando a fun��o 'countAdjacentBombs'
 move $a0, $s1  # Passando i para o primeiro argumento
 move $a1, $s2  # Passando j para o segundo argumento
 move $a2, $s0  # Passando a posi��o inicial da matriz para o terceiro argumento
 
 jal countAdjacentBombs  # Chamada de fun��o para contar bombas adjacentes
 
 move $t0, $v0  # $t0 recebe o n�mero de bombas contadas
 sw $t0, 0($s6)  # Salvando o n�mero de bombas na posi��o da matriz
 
 bne $t0, $zero, revelado  # Se h� bombas adjacentes, continuar revelando c�lulas vizinhas
 
# Salvando dados e chamando a fun��o 'revealNeighboringCells'
 move $a0, $s1  # Passando i para o primeiro argumento
 move $a1, $s2  # Passando j para o segundo argumento
 move $a2, $s0  # Passando a posi��o inicial da matriz para o terceiro argumento
 
 jal revealNeighboringCells  # Chamada de fun��o para revelar c�lulas vizinhas
 
 revelado:
 restore_context  # Restaurando o contexto
 li $v0, 1         # Definindo retorno como 1 (c�lula revelada)
 jr $ra            # Retornando

 perdeu:
 restore_context  # Restaurando o contexto
 li $v0, 0         # Definindo retorno como 0 (jogador perdeu)
 jr $ra            # Retornando
