.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    # Saving a0-a3 to s0-s3
    addi s0, a0, 0
    addi s1, a1, 0
    addi s2, a2, 0
    addi s3, a3, 0
    # Opening the file
    addi a1, s0, 0
    addi a2, x0, 1
    jal fopen
    addi s4, a0, 0
    # Allocating memory for rows and cols
    addi a0, x0, 8
    jal malloc
    addi s5, a0, 0
    # Loading rows and cols in buffer
    sw s2, 0(s5)
    sw s3, 4(s5)
    # Writing rows and cols in file
    addi a1, s4, 0
    addi a2, s5, 0
    addi a3, x0, 2
    addi a4, x0, 4
    jal fwrite
    # Writing elements of matrix
    addi a1, s4, 0
    addi a2, s1, 0
    mul a3, s2, s3
    addi a4, x0, 4
    jal fwrite
    # Closing the file
    addi a1, s4, 0
    jal fclose
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    ret