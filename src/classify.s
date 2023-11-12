.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Prologue
    addi sp, sp, -48
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
    sw ra, 44(sp)
    
    # Saving a0-a2 in s0-s2
    addi s0, a0, 0
    addi s1, a1, 0
    addi s2, a2, 0
	# =====================================
    # LOAD MATRICES
    # =====================================

    # Allocating memory for read matrix operations
    addi a0, x0, 8
    jal malloc 
    addi s3, a0, 0
    addi s4, a0, 4
    
    # Allocating memory for storing dimensions of matrices
    addi a0, x0, 24
    jal malloc
    addi s5, a0, 0

    # Load pretrained m0
    
    # Setting up parameters
    lw a0, 4(s1)
    addi a1, s3, 0
    addi a2, s4, 0

    # Calling read function
    jal read_matrix

    # Loading up parameters of matrix
    lw t0, 0(s3)
    lw t1, 0(s4)

    # Storing parameters of m0
    sw t0, 0(s5)
    sw t1, 4(s5)

    # Storing address of m0
    addi s6, a0, 0

    # Load pretrained m1

    # Setting up parameters
    lw a0, 8(s1)
    addi a1, s3, 0
    addi a2, s4, 0

    # Calling read function
    jal read_matrix

    # Loading up parameters of matrix
    lw t0, 0(s3)
    lw t1, 0(s4)

    # Storing parameters of matrix
    sw t0, 8(s5)
    sw t1, 12(s5)

    # Storing address of m1
    addi s7, a0, 0

    # Load input matrix
    
    # Setting up parameters
    lw a0, 12(s1)
    addi a1, s3, 0
    addi a2, s4, 0

    # Calling read function
    jal read_matrix

    # Loading up parameters of matrix
    lw t0, 0(s3)
    lw t1, 0(s4)

    # Storing parameters of matrix
    sw t0, 16(s5)
    sw t1, 20(s5)

    # Storing address of m1
    addi s8, a0, 0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # 1. Linear Layer

    # Calculating memory required, allocating it and saving address in s9
    lw t0, 0(s5)
    lw t1, 20(s5)
    mul t1, t0, t1
    addi t0, x0, 4
    mul a0, t0, t1
    jal malloc
    addi s9, a0, 0

    # Setting up arguements
    addi a0, s6, 0
    lw a1, 0(s5)
    lw a2, 4(s5)
    addi a3, s8, 0
    lw a4, 16(s5)
    lw a5, 20(s5)
    addi a6, s9, 0

    # Calling matmul
    jal matmul

    # 2. NonLinear Layer

    # Calulating no of elements
    lw t0, 0(s5)
    lw t1, 20(s5)
    mul t1, t0, t1

    # Setting up arguements
    addi a0, s9, 0
    addi a1, t1, 0
    jal relu

    # 3. Linear Layer

    # Calculating memory required, allocating it and saving address in s10
    lw t0, 8(s5)
    lw t1, 20(s5)
    mul t1, t0, t1
    addi t0, x0, 4
    mul a0, t0, t1
    jal malloc
    addi s10, a0, 0

    # Setting up arguements
    addi a0, s7, 0
    lw a1, 8(s5)
    lw a2, 12(s5)
    addi a3, s9, 0
    lw a4, 0(s5)
    lw a5, 20(s5)
    addi a6, s10, 0

    # Calling matmul
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
    # Setting up arguements
    lw a0, 16(s1)
    addi a1, s10, 0
    lw a2, 8(s5)
    lw a3, 20(s5)

    # Calling write matrix
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    
    # Setting up arguements
    addi a0, s10, 0
    lw t0, 8(s5)
    lw t1, 20(s5)
    mul a1, t0, t1

    # Calling argmax function
    jal argmax

    # Print classification
    bne s2, x0, no_print

    addi a1, a0, 0
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

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
    lw ra, 44(sp)
    addi sp, sp, 48

    ret

no_print:
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
    lw ra, 44(sp)
    addi sp, sp, 48
    ret