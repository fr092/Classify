.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    #initialize element counter
    addi s0, x0, 0
    #check for zero size
    beq s0, a0, loop_end
    #store address of first element
    addi s2, a0, 0
loop_start:
    #update counter
    addi s0, s0, 1
    #load the value of current element
    lw s1, 0(s2)
    #check if element if positive
    bge s1, x0, loop_continue
    #store zero if negative element
    sw x0, 0(s2)
loop_continue:
    #update address stored in s2
    addi s2, s2, 4
    #check if we are at end or not
    bne s0, a1, loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
	ret