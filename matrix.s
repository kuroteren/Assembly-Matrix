###########################################################
#		Program Description

###########################################################
#		Register Usage
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
col_matrix_one_address:	.word	0
col_matrix_one_height:	.word	0
col_matrix_one_width:	.word	0
col_matrix_two_address:	.word	0
col_matrix_two_height:	.word	0
col_matrix_two_width:	.word	0
###########################################################
		.text
main:
	li		$t9, 0

	addi	$sp, $sp, -4
	sw		$ra, 0($sp)			#ra backup
	
	addi	$sp, $sp, -12		#set stack for create_col_matrix call
	
	sw		$t9, 4($sp)
	sw		$t9, 8($sp)			#set (IN) height/width to 0
	
	jal		create_col_matrix
	
	la		$t0, col_matrix_one_address
	la		$t1, col_matrix_one_height
	la		$t2, col_matrix_one_width	#load addresses of matrix 1
	
	lw		$t9, 0($sp)
	sw		$t9, 0($t0)			#store base address
	
	lw		$t9, 4($sp)
	sw		$t9, 0($t1)			#store height
	
	lw		$t9, 8($sp)
	sw		$t9, 0($t2)			#store width
	
	addi	$sp, $sp, 12		#remove stack partition (not really needed)
	
	sw		$ra, 0($sp)			#backup ra again
	
	addi	$sp, $sp, -12		#create second create_col_matrix call stack
	
	li		$t9, 0
	
	sw		$t9, 4($sp)
	sw		$t9, 8($sp)			#height/width = 0
	
	jal		create_col_matrix

	la		$t0, col_matrix_two_address
	la		$t1, col_matrix_two_height
	la		$t2, col_matrix_two_width
	
	lw		$t9, 0($sp)
	sw		$t9, 0($t0)
	
	lw		$t9, 4($sp)
	sw		$t9, 0($t1)
	
	lw		$t9, 8($sp)
	sw		$t9, 0($t2)			#repeat storage process
	
	addi	$sp, $sp, 12
	addi	$sp, $sp, 4			#delete stack
	
	addi	$sp, $sp, -4
	
	sw		$ra, 0($sp)
	
	addi	$sp, $sp, -12
	
	la		$t9, col_matrix_one_address
	lw		$t8, 0($t9)
	sw		$t8, 0($sp)
	
	la		$t9, col_matrix_one_height
	lw		$t8, 0($t9)
	sw		$t8, 4($sp)
	
	la		$t9, col_matrix_one_width
	lw		$t8, 0($t9)
	sw		$t8, 8($sp)

	jal		print_col_matrix
	
	addi	$sp, $sp, 12
	
	sw		$ra, 0($sp)
	
	addi	$sp, $sp, -12
	
	la		$t9, col_matrix_two_address
	lw		$t8, 0($t9)
	sw		$t8, 0($sp)
	
	la		$t9, col_matrix_two_height
	lw		$t8, 0($t9)
	sw		$t8, 4($sp)
	
	la		$t9, col_matrix_two_width
	lw		$t8, 0($t9)
	sw		$t8, 8($sp)

	jal		print_col_matrix
	
	addi	$sp, $sp, 12
	
	addi	$sp, $sp, -24
	
	la		$t9, col_matrix_two_address
	lw		$t8, 0($t9)
	sw		$t8, 0($sp)
	
	la		$t9, col_matrix_two_height
	lw		$t8, 0($t9)
	sw		$t8, 4($sp)
	
	la		$t9, col_matrix_two_width
	lw		$t8, 0($t9)
	sw		$t8, 8($sp)

	jal		transpose_col_matrix
	
	la		$t9, col_matrix_two_address
	lw		$t8, 12($sp)
	sw		$t8, 0($t9)
	
	la		$t9, col_matrix_two_height
	lw		$t8, 16($sp)
	sw		$t8, 0($t9)
	
	la		$t9, col_matrix_two_width
	lw		$t8, 20($sp)
	sw		$t8, 0($t9)
	
	addi	$sp, $sp, 24
	
	addi	$sp, $sp, -32
	
	la		$t9, col_matrix_one_address
	lw		$t8, 0($t9)
	sw		$t8, 0($sp)
	
	la		$t9, col_matrix_one_height
	lw		$t8, 0($t9)
	sw		$t8, 4($sp)
	
	la		$t9, col_matrix_one_width
	lw		$t8, 0($t9)
	sw		$t8, 8($sp)
	
	la		$t9, col_matrix_two_address
	lw		$t8, 0($t9)
	sw		$t8, 12($sp)
	
	la		$t9, col_matrix_two_height
	lw		$t8, 0($t9)
	sw		$t8, 16($sp)
	
	la		$t9, col_matrix_two_width
	lw		$t8, 0($t9)
	sw		$t8, 20($sp)
	
	jal		add_col_matrix
	
	lw		$t9, 28($sp)
	
	bltz	$t9, main_end
	
	lw		$t0, 24($sp)
	lw		$t1, 4($sp)
	lw		$t2, 8($sp)
	
	addi	$sp, $sp, 32
	
	addi	$sp, $sp, -12
	
	sw		$t0, 0($sp)
	sw		$t1, 4($sp)
	sw		$t2, 8($sp)
	
	jal		print_col_matrix
	
	addi	$sp, $sp, 12
	
main_end:
	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		Subprogram Description
# Create_col_Matrix
#makes the matrix
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp		base address (OUT)
#	$sp+4	height	(IN/OUT)
#	$sp+8	width	(IN/OUT)
#	$sp+12
###########################################################
#		Register Usage
#	$t0	address
#	$t1	height
#	$t2	width
#	$t3	size
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8 flag
#	$t9	temp
###########################################################
		.data
create_col_matrix_height_p:	.asciiz	"Input height of matrix: "
create_col_matrix_width_p:	.asciiz	"input width of matrix: "
###########################################################
		.text
create_col_matrix:
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	li	$t8, 0
	
	blez	$t1, create_col_matrix_prompt_height
create_col_matrix_safe_height:
	blez	$t2, create_col_matrix_prompt_width
create_col_matrix_safe_width:

	mult	$t1, $t2	#get size of intended matrix
	mflo	$t3
	sll		$t3, $t3, 2		#double for double precision values
	
	li	$v0, 9
	sll	$a0, $t3, 2			#double for capacity insurance
	syscall
	
	move	$t0, $v0
	
	sw		$t0, 0($sp)
	sw		$t1, 4($sp)
	sw		$t2, 8($sp)
	
	addi	$sp, $sp, -4	#ra backup
	sw		$ra, 0($sp)
	
	addi	$sp, $sp, -12
	
	sw		$t0, 0($sp)
	sw		$t1, 4($sp)
	sw		$t2, 8($sp)
	
	blez	$t8, create_col_matrix_skip
	
	jal		read_col_matrix
	
create_col_matrix_skip:
	addi	$sp, $sp, 12
	
	lw		$ra, 0($sp)
	
	addi	$sp, $sp, 4

	jr $ra	#return to calling location
	
create_col_matrix_prompt_height:
	li	$t8, 1

	li	$v0, 4
	la	$a0, create_col_matrix_height_p
	syscall
	
	li	$v0, 5
	syscall
	
	move	$t1, $v0
	
	blez	$t1, create_col_matrix_prompt_height	#ensure good value
	b	create_col_matrix_safe_height
	
create_col_matrix_prompt_width:
	li	$v0, 4
	la	$a0, create_col_matrix_width_p
	syscall
	
	li	$v0, 5
	syscall
	
	move	$t2, $v0
	
	blez	$t2, create_col_matrix_prompt_width		#ensure good value
	b	create_col_matrix_safe_width
###########################################################
###########################################################
#		Subprogram Description
#Read Matrix
#Reads the matrix
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp		base address (IN)
#	$sp+4	height	(IN)
#	$sp+8	width	(IN)
#	$sp+12
###########################################################
#		Register Usage
#	$t0	address
#	$t1	height
#	$t2	width
#	$t3	address adjust
#	$t4	size counter
#	$t5 counter
#	$t6 8 const
#	$t7
#	$t8
#	$t9
###########################################################
		.data
read_col_matrix_p:	.asciiz	"Enter floating point value: "
###########################################################
		.text
read_col_matrix:
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	li	$t5, 0
	li	$t6, 8
	
	mult	$t1, $t2	#gets size of array for counter
	mflo	$t4
	
read_col_matrix_loop:
	b	read_col_matrix_math
read_col_matrix_loop_cont:
	add	$t0, $t0, $t3

	li	$v0, 4
	la	$a0, read_col_matrix_p
	syscall
	
	li	$v0, 7
	syscall
	
	s.d	$f0, 0($t0)
	
	sub		$t0, $t0, $t3
	
	addi	$t5, $t5, 1
	addi	$t4, $t4, -1
	
	bgtz	$t4, read_col_matrix_loop
	
	jr $ra	#return to calling location
	
read_col_matrix_math:
	div	$t5, $t2
	mflo	$t9		#k
	
	mult	$t1, $t9	#e*k
	mflo	$t8
	sub		$t7, $t5, $t8	#n
	
	add		$t9, $t8, $t7	#(e*k)+n
	
	mult	$t9, $t6	#s*(e*k+n)
	mflo	$t3
	
	b	read_col_matrix_loop_cont
###########################################################

###########################################################
#		Subprogram Description
#Print Column Matrix
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp		base address (IN)
#	$sp+4	height	(IN)
#	$sp+8	width	(IN)
#	$sp+12
###########################################################
#		Register Usage
#	$t0	address
#	$t1	height
#	$t2	width
#	$t3 address adjust
#	$t4 size counter
#	$t5 counter
#	$t6 new row counter
#	$t7
#	$t8
#	$t9
###########################################################
		.data
print_col_matrix_p:	.asciiz	"Matrix:\n"
print_col_matrix_tab_p:	.asciiz	"  "
print_col_matrix_nwln_p:	.asciiz	"\n"
###########################################################
		.text
print_col_matrix:
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	
	li	$t5, 0
	li	$t6, 0
	mult	$t1, $t2
	mflo	$t4
	
	li	$v0, 4
	la	$a0, print_col_matrix_p
	syscall
	
print_col_matrix_loop:
	b	print_col_matrix_math
print_col_matrix_loop_cont:
	add	$t0, $t0, $t3
	
	l.d	$f12, 0($t0)
	
	li	$v0, 3
	syscall
	
	li	$v0, 4
	la	$a0, print_col_matrix_tab_p
	syscall
	
	sub	$t0, $t0, $t3
	
	addi	$t5, $t5, 1
	addi	$t6, $t6, 1
	addi	$t4, $t4, -1
	
	beq	$t6, $t2, print_col_matrix_new_row
print_col_matrix_loop_cont_b:

	bgtz	$t4, print_col_matrix_loop

	jr $ra	#return to calling location
	
print_col_matrix_math:
	div	$t5, $t1
	mflo	$t9		#k
	
	mult	$t1, $t9	#e*k
	mflo	$t8
	sub		$t7, $t5, $t8	#n
	
	add		$t9, $t8, $t7	#(e*k)+n
	
	li		$t7, 8
	mult	$t9, $t7	#s*(e*k+n)
	mflo	$t3
	
	b	print_col_matrix_loop_cont
	
print_col_matrix_new_row:
	li	$v0, 4
	la	$a0, print_col_matrix_nwln_p
	syscall
	
	li	$t6, 0
	
	b	print_col_matrix_loop_cont_b
###########################################################

###########################################################
#		Subprogram Description
#transpose matrix
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp		base address (IN)
#	$sp+4	height	(IN)
#	$sp+8	width (IN)
#	$sp+12	transpose address (OUT)
#	$sp+16	transpose height (OUT)
#	$sp+20	transpose width (OUT)
###########################################################
#		Register Usage
#	$t0	base address
#	$t1	height
#	$t2 width
#	$t3 new address
#	$t4 new height(temp)/col_address_offset
#	$t5 new width(temp)/row_address_offset
#	$t6 counter
#	$t7
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text
transpose_col_matrix:
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	
	li	$t6, 0
	
	addi	$sp, $sp, -4
	
	sw	$ra, 0($sp)
	
	addi	$sp, $sp, -12
	
	sw	$t2, 4($sp)
	sw	$t1, 8($sp)
	
	jal	create_col_matrix
	
	lw	$t3, 0($sp)
	
	addi	$sp, $sp, 12
	
	lw	$ra, 0($sp)
	
	addi	$sp, $sp, 4
	
	sw	$t3, 12($sp)
	sw	$t1, 16($sp)
	sw	$t2, 20($sp)
	
	lw	$t0, 0($sp)
	lw	$t3, 12($sp)
	
transpose_col_matrix_loop:
	b	transpose_col_matrix_col_math
	
transpose_col_matrix_cont_a:	
	b	transpose_col_matrix_row_math
	
transpose_col_matrix_loop_cont_b:

	add	$t0, $t0, $t4
	
	add	$t3, $t3, $t5
	
	l.d	$f12, 0($t0)
	
	s.d	$f12, 0($t3)
	
	sub	$t0, $t0, $t4
	sub	$t3, $t3, $t5
	
	addi	$t6, $t6, 1
	
	b	transpose_col_matrix_check
	
transpose_col_matrix_end:
	jr $ra	#return to calling location
	
transpose_col_matrix_row_math:
	div	$t6, $t1
	mflo	$t9		#k
	
	mult	$t1, $t9	#e*k
	mflo	$t8
	sub		$t7, $t6, $t8	#n
	
	add		$t9, $t8, $t7	#(e*k)+n
	
	li		$t7, 8
	mult	$t9, $t7	#s*(e*k+n)
	mflo	$t5
	
	b	transpose_col_matrix_loop_cont_b

transpose_col_matrix_col_math:
	div	$t6, $t2
	mflo	$t9		#k
	
	mult	$t2, $t9	#e*k
	mflo	$t8
	sub		$t7, $t6, $t8	#n
	
	add		$t9, $t8, $t7	#(e*k)+n
	
	li		$t7, 8
	mult	$t9, $t7	#s*(e*k+n)
	mflo	$t4
	
	b	transpose_col_matrix_cont_a
	
transpose_col_matrix_check:
	mult	$t1, $t2
	mflo	$t9
	
	sub		$t9, $t9, $t6
	
	bgtz	$t9, transpose_col_matrix_loop
	blez	$t9, transpose_col_matrix_end
###########################################################

###########################################################
#		Subprogram Description
#Add col matrix
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp		address 1
#	$sp+4	height 1
#	$sp+8	width 1
#	$sp+12 address 2
#	$sp+16 height 2
#	$sp+20 width 2
#	$sp+24 address out
#	$sp+28 flag
###########################################################
#		Register Usage
#	$t0 a1
#	$t1	h1
#	$t2	w1
#	$t3	a2
#	$t4	h2/ a3
#	$t5	w2/ offsett
#	$t6 counter
#	$t7
#	$t8
#	$t9
###########################################################
		.data
add_col_matrix_flag_p:	.asciiz	"Invalid matrix addition.\n"
###########################################################
		.text
add_col_matrix:
	lw	$t0, 0($sp)
	lw	$t1, 4($sp)
	lw	$t2, 8($sp)
	lw	$t3, 12($sp)
	lw	$t4, 16($sp)
	lw	$t5, 20($sp)
	li	$t6, 0
	
	bne	$t1, $t4, add_col_matrix_err
	bne	$t2, $t5, add_col_matrix_err
	
	mult	$t1, $t2
	mflo	$t9
	
	li		$t8, 8
	mult	$t9, $t8
	mflo	$t9
	
	li	$v0, 9
	sll $a0, $t9, 2
	syscall
	
	move	$t4, $v0
	
add_col_matrix_loop:
	b	add_col_matrix_col_math
	
add_col_matrix_cont:
	add	$t0, $t0, $t5
	add	$t3, $t3, $t5
	add	$t4, $t4, $t5
	
	l.d	$f0, 0($t0)
	l.d	$f2, 0($t3)
	
	add.d	$f4, $f0, $f2
	
	s.d	$f4, 0($t4)
	
	sub	$t0, $t0, $t5
	sub	$t3, $t3, $t5
	sub	$t4, $t4, $t5
	
	addi	$t6, $t6, 1
	
	b	add_col_matrix_check
	
add_col_matrix_end:
	jr $ra	#return to calling location
	
add_col_matrix_err:
	li	$t9, -1
	sw	$t9, 28($sp)
	
	li	$v0, 4
	la	$a0, add_col_matrix_flag_p
	syscall
	
	b	add_col_matrix_end
	
add_col_matrix_col_math:
	div	$t6, $t2
	mflo	$t9		#k
	
	mult	$t2, $t9	#e*k
	mflo	$t8
	sub		$t7, $t6, $t8	#n
	
	add		$t9, $t8, $t7	#(e*k)+n
	
	li		$t7, 8
	mult	$t9, $t7	#s*(e*k+n)
	mflo	$t5
	
	b	add_col_matrix_cont
	
add_col_matrix_check:
	mult	$t1, $t2
	mflo	$t9
	
	sub		$t9, $t9, $t6
	
	bgtz	$t9, add_col_matrix_loop
	blez	$t9, add_col_matrix_end
###########################################################

