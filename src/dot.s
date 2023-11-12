.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    addi s0, x0, 0
    addi s1, x0, 0
    beq s0, a2, loop_end
    addi s2, a0, 0
    addi s3, a1, 0
    addi s4, x0, 4
    mul a3, a3, s4
    mul a4, a4, s4
loop_start:
    lw s5, 0(s2)
    lw s6, 0(s3)
    mul s4, s5, s6
    add s1, s1, s4
    addi s0, s0, 1
    add s2, s2, a3
    add s3, s3, a4
    bne s0, a2, loop_start
loop_end:
    # Epilogue
    addi a0, s1, 0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret 