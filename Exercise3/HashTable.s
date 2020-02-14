.text
.globl main

main:
	li $t1,0						#t1=telos=0
loop:
	la $a0,ans						#print Menu
	li $v0,4
	syscall

	la $a0,ans1						#Print Insert Key
	li $v0,4
	syscall

	la $a0,ans2						#Print Find Key
	li $v0,4
	syscall

	la $a0,ans3						#Print Display Hash Table
	li $v0,4
	syscall

	la $a0,ans4						#Print Exit
	li $v0,4
	syscall

	la $a0,ans5						#Print Choice?
	li $v0,4
	syscall

	li $v0,5						#take an integer from user
	syscall

	move $t0,$v0					#t0 = v0 = user choice

	bne $t0,1,choice2				#if choice != 1 go to second if(choice2)

	la $a0,ans13					#Print "Give new key (greater than zero): "
	li $v0,4
	syscall

	li $v0,5						#take an integer from user
	syscall

	move $a1,$v0					#key = user input

	blez $a1,choice1else			#if key <= 0 go to choice1else
	jal insertkey					#jump to insertkey function
	j choice2						#jump to choice2


choice1else:
	la $a0,ans14					#Print "key must be greater than zero
	li $v0,4
	syscall

	la $a0,ans8						#Print \n
	li $v0,4
	syscall

choice2:
	bne $t0,2,choice3				#if choice != 2 go to third if(choice3)
	
	la $a0,ans9						#Print "Give key to search for: "
	li $v0,4
	syscall

	li $v0,5						#take an integer from user
	syscall

	move $a1,$v0					#move user input (key) to $a1
	jal findkey						#call find key function

	move $t2,$v0					#move result to $t2 = pos

	bne $t2,-1,choice2else			#if pos = -1
	
	la $a0,ans10					#Print "Key not in hash table."
	li $v0,4
	syscall

	la $a0,ans8						#Print \n
	li $v0,4
	syscall

	j choice3						#go to choice3 

choice2else:
	la $a0,ans11					#Print "Key value = "
	li $v0,4
	syscall

	mul $t2,$t2,4					#mul t2 with 4 because hash array has integer type elements
	lw $a0,hash($t2)				#take the key from array[$t2]
	li $v0,1						#print value of key
	syscall

	la $a0,ans8						#Print \n
	li $v0,4
	syscall

	la $a0,ans12					#Print "Table position = "
	li $v0,4
	syscall

	div $t2,$t2,4					#Div again with 4 and take index position
	move $a0,$t2					#$a0=$t2
	li $v0,1						#print pos
	syscall

	la $a0,ans8						#Print \n
	li $v0,4
	syscall

choice3:
	bne $t0,3,choice4				#if choice != 3 go to forth if
	la $a0,hash						#a0 = first pos of hash array
	jal displayTable				#call displayTable fynction

choice4:
	bne $t0,4,ifLoop				#if choice != 4 go to check while
	li $t1,1						#telos == 1
ifLoop:
	la $a0,ans8						#Print \n
	li $v0,4
	syscall

	beqz $t1,loop					#if telos == 0 go to loop

	li $v0,10						#else exit from while
	syscall









insertkey:
	addi $sp,$sp,-4
	sw $ra,0($sp) 					# save $ra so we can return to main program
	jal findkey						#call findkey function

	move $t5,$v0					#$t5(position) = result from findkey function

	beq $t5,-1,insertkeyelse		#if $t5(position) == -1 go to insertkeyelse

	la $a0,ans15					#Print "Key is already in hash table.\n"
	li $v0,4
	syscall

	lw $ra,0($sp) 					#take the return address to main from stack
	addi $sp,$sp,4
	jr $ra							#return to main

insertkeyelse:
	lw $t6,keys						#$t6 = keys
	lw $t4,N						#$t4 = N

	bge $t6,$t4,insertkeyelse1		#if keys >= N go to insertkeyelse1
	jal hashfuction					#call hashfuction fuction
	move $t5,$v0					#$t5(position) = result from hashfuction

	mul $t5,$t5,4					#mul $t5 with 4 because hash has integers
	sw $a1,hash($t5)				#store key to hash[position]
	div $t5,$t5,4					#div to make it 0-9

	addi $t6,$t6,1					#keys++
	sw $t6,keys						#store the value of $t6 to keys

	lw $ra,0($sp) 					#take the return address to main from stack
	addi $sp,$sp,4
	jr $ra							#return to main

insertkeyelse1:
	la $a0,ans16					#Print	"hash table is full\n"
	li $v0,4
	syscall

	lw $ra,0($sp) 					#take the return address to main from stack
	addi $sp,$sp,4
	jr $ra							#return to main










hashfuction:
	lw $t4,N						#$t4 = N
	rem $t5,$a1,$t4					#$t5(position) = key % N

hashfuctionLoop:

	mul $t5,$t5,4					#mul $t5 with 4 because hash array has integers
	lw $t7,hash($t5)				#$t7 = hash[position]

	beqz $t7,hashfuctionexit		#if t7 == 0 go to hashfuctionexit
	div $t5,$t5,4					#div $t5 with 4 to make it 0-9
	addi $t5,$t5,1					#position++
	rem $t5,$t5,$t4					#position %= N 
	j hashfuctionLoop				#jump to hashfuctionLoop

hashfuctionexit:
	div $t5,$t5,4					#div $t5 with 4 because at last loop we dont div with 4 so we make it 0-9
	move $v0,$t5					#$v0 = $t5
	jr $ra							#return result










findkey:
	lw $t4,N						#$t4 = N
	li $t6,0						#i = 0
	li $t7,0						#found = 0
	rem $t5,$a1,$t4					#position = key % N

findkeyLoop:
	bge $t6,$t4,findkeyexit			#if i >= N exit from while
	bnez $t7,findkeyexit			#if found != 0 exit from while

	add $t6,$t6,1					#i++
	mul $t5,$t5,4					#position take values 0-9 so we should mul with 4 because we have integer type elements

	lw $a0,hash($t5)				#$a0 = hash[position]
	bne $a0,$a1,findkeyelse			#if hash[position] != k go to else
	li $t7,1						#if hash[position] == k  -> found = 1
	j findkeyLoop					#check while if and exit from while
findkeyelse:
	div $t5,$t5,4					#div position with 4 because we had mul with 4
	add $t5,$t5,1					#position++
	rem $t5,$t5,$t4					#position %= N
	j findkeyLoop					#check while if and continue to search

findkeyexit:
	bne $t7,1,findkeyelse1			#if found != 1 go to else1
	div $t5,$t5,4					#div position with 4 because we had mul with 4 and it didnt go inside findkeyelse label
	move $v0,$t5					#return result with v0
	jr $ra

findkeyelse1:
	li $v0,-1
	div $t5,$t5,4					#div position with 4 because we had mul with 4 and it didnt go inside findkeyelse label
	jr $ra							#return -1











displayTable:
	li $t5,0						#$t5 = 0 i = 0
	lw $t6,N						#$t6 = N

	move $t4,$a0					#t4 has the address of first element of hash array

	la $a0,ans6						#print npos key
	li $v0,4
	syscall
displayLoop:
	bge $t5,$t6,exitdisplay			#if i>=N go to exitdisplay

	la $a0,ans7						#print " "
	li $v0,4
	syscall

	move $a0,$t5					#print i
	li $v0,1
	syscall

	la $a0,ans7						#print " "
	li $v0,4
	syscall

	la $a0,ans7						#print " "
	li $v0,4
	syscall

	la $a0,ans7						#print " "
	li $v0,4
	syscall

	lw $a0,($t4)					#print key
	li $v0,1
	syscall	

	add $t5,$t5,1					#i++
	add $t4,$t4,4					#address of next key

	la $a0,ans8						#Print \n
	li $v0,4
	syscall

	j displayLoop					#jump to displayLoop
	
exitdisplay:
	jr $ra
	
	

.data
ans:	.asciiz " Menu\n"
ans1:	.asciiz "1.Insert Key\n"
ans2:	.asciiz "2.Find Key\n"
ans3:	.asciiz "3.Display Hash Table\n"
ans4:	.asciiz "4.Exit"
ans5:	.asciiz "\nChoice?"
ans6:	.asciiz "\npos key\n"
ans7:	.asciiz " "
ans8:	.asciiz	"\n"
ans9:	.asciiz "Give key to search for: "
ans10:	.asciiz	"Key not in hash table."
ans11:	.asciiz "Key value = "
ans12:	.asciiz "Table position = "
ans13:	.asciiz "Give new key (greater than zero): "
ans14:	.asciiz "key must be greater than zero"
ans15:	.asciiz "Key is already in hash table.\n"
ans16:	.asciiz "hash table is full\n"
N:		.word 10
keys:	.word 0
hash:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0