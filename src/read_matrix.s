.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)
    # Storing a0-a2 in s0-s2
    addi s0, a0, 0
    addi s1, a1, 0
    addi s2, a2, 0
    # Code
    # Putting arguements in app place & using fopen to open file
    addi a1, a0, 0
    addi a2, x0, 0
    jal fopen  # file descriptor returned to a0
    addi s3, a0, 0 #storing file descriptor in s3
    # Reading no of rows from file
    addi a1, s3, 0
    addi a2, s1, 0
    addi a3, x0, 4
    jal fread
    # Reading no of columns from file
    addi a1, s3, 0
    addi a2, s2, 0
    addi a3, x0, 4
    jal fread
    # Finding no of elements
    lw s6, 0(s1)
    lw s7, 0(s2)
    mul s4, s6, s7
    # Allocating memory for storing elements
    addi s6, x0, 4
    mul a0, s4, s6
    jal malloc
    addi s5, a0, 0
    # Reading bytes from memory
    addi a1, s3, 0
    addi a2, s5, 0
    mul a3, s4, s6
    jal fread
    # Closng the file
    addi a1, s3, 0
    jal fclose
    # Epilogue
    addi a0, s5, 0 #storing address pointer in a0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    ret