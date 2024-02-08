    #include <stdio.h>
    #include <stdlib.h>
    #include <time.h>

    #define SIZE 8
    #define BOMB_COUNT 10

    int row;

    void initializeBoard(int board[][SIZE]) {
        // Inicializa o tabuleiro com zeros
        for (int i = 0; i < SIZE; ++i) {
            for (int j = 0; j < SIZE; ++j) {
                board[i][j] = -2; // Atribuindo -2 a todas as casas; -2 significa sem bombas
            }
        }
    }

    void placeBombs(int board[][SIZE]) {
        srand(time(NULL));
        // Usa a rand para colocar bombas em posições aleatórias do tabuleiro
        for (int i = 0; i < BOMB_COUNT; ++i) {
            int row, column;
            do {
                row = rand() % SIZE;
                column = rand() % SIZE;
            } while (board[row][column] == -1); // garante que uma bomba não será colocada onde já tem uma
            board[row][column] = -1; // -1 significa que tem uma bomba naquela casa
        }
    }

    void printBoard(int board[][SIZE], int showBombs) {
        // Prints the board
        printf("    ");
        for (int j = 0; j < SIZE; ++j)
            printf(" %d ", j);
        printf("\n");
        printf("    ");
        for (int j = 0; j < SIZE; ++j)
            printf("___");
        printf("\n");
        for (int i = 0; i < SIZE; ++i) {
            printf("%d | ", i);
            for (int j = 0; j < SIZE; ++j) {
                if (board[i][j] == -1 && showBombs) {
                    printf(" * "); // Shows bombs
                } else if (board[i][j] >= 0) {
                    printf(" %d ", board[i][j]); // Revealed cell
                } else {
                    printf(" # ");
                }
            }
            printf("\n");
        }
    }

    int countAdjacentBombs(int board[][SIZE], int row, int column) {
        // Counts the number of bombs adjacent to a cell
        int count = 0;
        for (int i = row - 1; i <= row + 1; ++i) {
            for (int j = column - 1; j <= column + 1; ++j) {
                if (i >= 0 ) {
                        if( i < SIZE )
                            if( j >= 0 j < SIZE && board[i][j] == -1)
                    count++;
                }

            }
        }
        return count;
    }

    void revealAdjacentCells(int board[][SIZE], int row, int column) {
        // Reveals the adjacent cells of an empty cell
        for (int i = row - 1; i <= row + 1; ++i) {
            for (int j = colum  n - 1; j <= column + 1; ++j) {
                if (i >= 0 && i < SIZE && j >= 0 && j < SIZE && board[i][j] == -2) {
                    int x = countAdjacentBombs(board, i, j); // Marks as revealed
                    board[i][j] = x;
                    if (!x)
                        revealAdjacentCells(board, i, j); // Continues the revelation recursively
                }
            }
        }
    }

    int play(int board[][SIZE], int row, int column) {
        if (board[row][column] == -1) {
            return 0; // Player hit a bomb, game over
        }
        if (board[row][column] == -2) {
            int x = countAdjacentBombs(board, row, column); // Marks as revealed
            board[row][column] = x;
            if (!x)
                revealAdjacentCells(board, row, column); // Reveals adjacent cells
        }
        return 1;
    }

    int checkVictory(int board[][SIZE]) {
        int count = 0;
        // Checks if the player has won
        for (int i = 0; i < SIZE; ++i) {
            for (int j = 0; j < SIZE; ++j) {
                if (board[i][j] >= 0) {
                    count++;
                }
            }
        }
        if (count < SIZE * SIZE - BOMB_COUNT)
            return 0;
        return 1; // All valid cells have been revealed
    }

    int main() {
        int board[SIZE][SIZE];
        int gameActive = 1;
        int row, column;

        initializeBoard(board);
        placeBombs(board);

        while (gameActive) {
            printBoard(board,0); // Shows the board without bombs

            // Asks the player to enter the move
            printf("Enter the row for the move: ");
            scanf("%d", &row);
            printf("Enter the column for the move: ");
            scanf("%d", &column);

            // Checks the move
            if (row >= 0 && row < SIZE && column >= 0 && column < SIZE) {
                if (!play(board, row, column)) {
                    gameActive = 0;
                    printf("Oh no! You hit a bomb! Game over.\n");
                } else if (checkVictory(board)) {
                    printf("Congratulations! You won!\n");
                    gameActive = 0; // Game ends
                }
            } else {
                printf("Invalid move. Please try again.\n");
            }
        }

        // Shows the final board with bombs
        printBoard(board,1);

        return 0;
    }
