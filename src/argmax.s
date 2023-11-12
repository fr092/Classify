.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    #initialize the element counter
    addi s0, x0, 0
    #check for zero size
    beq s0, a1, loop_end
    #store address
    addi s2, a0, 0
    #initialize register to keep track of current largest element
    addi s3, x0, -1
    #make it very negative
    slli s3, s3, 31
    #initialize register to keep track of index having largest element
    addi s4, x0, 0
loop_start:
    lw s1, 0(s2)
    addi s0, s0, 1
    bge s3, s1, loop_continue
    addi s3, s1, 0
    addi s4, s0, -1
loop_continue:
    addi s2, s2, 4
    bne s0, a1, loop_start
loop_end:
    # Epilogue
    addi a0, s4, 0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24
    ret