.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    # Prologue
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
    #storing a0-a6 in s0-s6
    addi s0, a0, 0
    addi s1, a1, 0
    addi s2, a2, 0
    addi s3, a3, 0
    addi s4, a4, 0
    addi s5, a5, 0
    addi s6, a6, 0
    #counter for rows
    addi s7, x0, 0
    #counter for columns
    addi s8, x0, 0
    #initialization of addresses
    addi s9, s0, 0 #row address of m0
    addi s10, s3, 0 #col address of m1
    addi s11, s6, 0 #curr element of d
outer_loop_start:
inner_loop_start:
    #placing app values in arguement registers
    addi a0, s9, 0
    addi a1, s10, 0
    addi a2, s2, 0
    addi a3, x0, 1
    addi a4, s5, 0
    #calling the dot function
    jal dot
    #storing result in d
    sw a0, 0(s11)
inner_loop_end:
    #updating address in col and curr element
    addi s10, s10, 4
    addi s11, s11, 4
    #checking loop
    addi s8, s8, 1
    bne s8, s5, inner_loop_start
outer_loop_end:
    #initialize constants
    addi t0, x0, 4
    mul t1, t0, s2
    #Updates
    addi s8, x0, 0
    addi s10, s3, 0
    addi s7, s7, 1
    add s9, s9, t1
    bne s7, s1, inner_loop_start
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    ret