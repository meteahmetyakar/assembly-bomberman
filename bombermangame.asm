			.data
			
defaultMap:		.space 2048
gameMap:		.space 2048
tempMap:		.space 2048

inputRowStr:		.asciiz "Enter row size: "
inputColStr:		.asciiz "Enter col size: "

inputProcessStr:	.asciiz "Enter process count: "

inputTargetRowStr:	.asciiz "Enter target rowIdx: "
inputTargetColStr:	.asciiz "Enter target colIdx: "

inputBombSize:		.asciiz "Enter bomb size: "
bombStr:		.asciiz "Bomb "

			
			

			
wall:			.asciiz "O"
bomb:			.asciiz "."
							
	.text
	
###################### Main #########################
main:	
	
	# print inputRowStr to console
	li $v0, 4
	la $a0, inputRowStr
	syscall
	
	# take row size from user
	li $v0, 5
    	syscall
    	move $s0, $v0  		# s0 = rowSize | s0 does not change throughout the program
    			
    	# print inputColStr to console
	li $v0, 4
	la $a0, inputColStr
	syscall
	
    	# take col size from user
    	li $v0, 5
    	syscall
    	move $s1, $v0  		# s1 = colSize | s1 does not change throughout the program
    	
    	
    	# print inputProcessStr to console
	li $v0, 4
	la $a0, inputProcessStr
	syscall
	
	#take process count from user
    	li $v0, 5
    	syscall
    	move $t8, $v0  		# t8 = processCount, t8 does not change throughout the program (only decrement)
		
		
	Outer_For_Decleration_dm: # dm means define map
		li $t0, 0 				# rowIdx = 0

	Outer_For_Body_dm:
		beq $t0, $s0, Outer_For_End_dm		# if(rowIdx == rowSize) then go to Outer_For_End_dm
		
		Inner_For_Decleration_dm:
			li $t1, 0 			# colIdx = 0	
				
		Inner_For_Body_dm:
			beq $t1, $s1, Inner_For_End_dm 	# if(colIdx == colSize) then go to Inner_For_End_dm
				
						
    			la $s2, wall
    			lb $s2, 0($s2) 			# s2 = wall[0] ( O character )
			la $s3, defaultMap		# s3 = defaultMap
			move $t6, $t0			# copy of current rowIdx to t6
			move $t7, $t1			# copy of current colIdx to t7
			jal set_char_to_index		# set_char_to_index(wall, defaultMap, rowIdx, colIdx) | defaultMap[rowIdx][colIdx] = wall
			
    			la $s2, wall			
    			lb $s2, 0($s2) 			# s2 = wall[0] ( O character )
			la $s3, gameMap			# s3 = gameMap
			move $t6, $t0			# copy of current rowIdx to t6
			move $t7, $t1			# copy of current colIdx to t7
			jal set_char_to_index		# set_char_to_index(wall, gameMap, rowIdx, colIdx) | gameMap[rowIdx][colIdx] = wall
			
			la $s2, wall
    			lb $s2, 0($s2) 			# s2 = wall[0] ( O character )
			la $s3, tempMap			# s3 = tempMap
			move $t6, $t0			# copy of current rowIdx to t6
			move $t7, $t1			# copy of current colIdx to t7
			jal set_char_to_index		# set_char_to_index(wall, tempMap, rowIdx, colIdx) | tempMap[rowIdx][colIdx] = wall

			add $t1, $t1, 1			# colIdx++
			j Inner_For_Body_dm
			
		Inner_For_End_dm:
			add $t0, $t0, 1			# rowIdx++
			j Outer_For_Body_dm
			
	Outer_For_End_dm:

    	# print inputBombSize to console
	li $v0, 4
	la $a0, inputBombSize
	syscall
	
	#take bomb count from user
	li $v0, 5
    	syscall
    	move $t0, $v0  # t0 = bombCount
    	
	Outer_For_Decleration_tb: # tb means take bombs

		li $t1, 0 				# count = 0
	Outer_For_Body_tb:
		beq $t0, $t1, Outer_End_For_tb 		# if(bombCount == count) then go to Outer_EndFor

		# print bomb to console | result is Bomb 
		li $v0, 4
		la $a0, bombStr
		syscall
	
		#print count id to console | result is Bomb count
		li $v0, 1
		move $a0, $t1
		add $a0, $a0, 1
		syscall
	
		#print newline | result is Bomb count\n
		li $v0, 11
		li $a0, 10
		syscall

		# print inputTargetRowStr to console
		li $v0, 4
		la $a0, inputTargetRowStr
		syscall
	
		li $v0, 5
    		syscall
    		move $t6, $v0  # t6 = targetRow
    	
    		# print inputTargetColStr to console
		li $v0, 4
		la $a0, inputTargetColStr
		syscall
    	
    		li $v0, 5
    		syscall
    		move $t7, $v0  # t7 targetCol


		la $s2, bomb
    		lb $s2, 0($s2) 			# s2 = bomb[0]
		la $s3, gameMap			# s3 = gameMap
		jal set_char_to_index		# set_char_to_index(bomb, gameMap, targetRow, targetCol) | gameMap[targetRow][targetCol] = bomb

	
		add $t1, $t1, 1			# count++
		j Outer_For_Body_tb
	
	Outer_End_For_tb:
		# print gameMap to console
		la $s3, gameMap
		jal print_matrix
		
		# wait 1 second (1000ms)
		li $a0, 1000
		li $v0, 32
		syscall

	do_while:
		

		Outer_For_Decleration_exp: #exp means is explode_bombs
			li $t0, 0 				# rowIdx = 0

		Outer_For_Body_exp:
			beq $t0, $s0, Outer_For_End_exp		# if(rowIdx == rowSize) then go to Outer_For_End_exp
		
			Inner_For_Decleration_exp:
				li $t1, 0 			# colIdx = 0	
				
			Inner_For_Body_exp:
				beq $t1, $s1, Inner_For_End_exp 	# if(colIdx == colSize) then go to Inner_For_End_exp
				
			
				if_exp:
					move $t6, $t0			# copy current rowIdx to t6
					move $t7, $t1			# copy current colIdx to t7
					la $s3, gameMap			# s3 = gameMap
					jal get_char_from_index		# it loads result to s4 | s4 = get_char_from_index(rowIdx, colIdx, gameMap) | s4 = gameMap[rowIdx][colIdx]
				
					la $s2, bomb
    					lb $s2, 0($s2) 			# s2 = bomb
				
    					bne $s4, $s2, end_if_exp	# if(gameMap[rowIdx][colIdx] != bomb) then go to end_if_exp
		
						move $t6, $t0			# copy current rowIdx to t6
						move $t7, $t1			# copy current colIdx to t7  				
    						la $s2, bomb			
    						lb $s2, 0($s2) 			# s2 = bomb
						la $s3, tempMap			# s3 = tempMap
						jal set_char_to_index		# set_char_to_index(bomb, tempMap, rowIdx, colIdx) | gameMap[rowIdx][colIdx] = bomb
					
						#checks up
						move $t6, $t0			# t6 = rowIdx
						move $t7, $t1			# t7 = colIdx
						sub $t6, $t6, 1			# t6 = rowIdx - 1
					
						bltz $t6, down			# if(rowIdx - 1 < 0) then go to down
							#operation of if
							jal set_char_to_index	# set_char_to_index(bomb, tempMap, rowIdx - 1, colIdx) | gameMap[rowIdx - 1][colIdx] = bomb						
					
						down:
						move $t6, $t0			# t6 = rowIdx
						move $t7, $t1			# t7 = colIdx
						add $t6, $t6, 1			# t6 = rowIdx + 1
						bge $t6, $s0, left		# if( rowIdx + 1 > rowSize ) then go to the left
							#operation of if
							jal set_char_to_index	# set_char_to_index(bomb, tempMap, rowIdx + 1 , colIdx) | gameMap[rowIdx + 1][colIdx] = bomb								
					
						left:
						move $t6, $t0			# t6 = rowIdx
						move $t7, $t1			# t7 = colIdx				
						sub $t7, $t7, 1			# t7 = colIdx - 1
						bltz $t7, right			# if( colIdx - 1 < 0 ) then go to the right
							#operation of if
							jal set_char_to_index	# set_char_to_index(bomb, tempMap, rowIdx, colIdx - 1) | gameMap[rowIdx][colIdx - 1] = bomb							
						
						right:
						move $t6, $t0			# t6 = rowIdx
						move $t7, $t1			# t7 = colIdx					
						add $t7, $t7, 1			# t7 = colIdx + 1
						bge $t7, $s1, end_if_exp	# if( colIdx + 1 > colSize ) then go to the end_if_exp
							#operation of if
							jal set_char_to_index	# set_char_to_index(bomb, tempMap, rowIdx, colIdx + 1) | gameMap[rowIdx][colIdx + 1] = bomb																			
						
					end_if_exp:
			
				add $t1, $t1, 1		# colIdx++
				j Inner_For_Body_exp
			
			Inner_For_End_exp:
				add $t0, $t0, 1		#rowIdx++
				j Outer_For_Body_exp
			
		Outer_For_End_exp:
		
		# print gameMap	
		la $s3, gameMap
		jal print_matrix
		
		# copy tempMap to gameMap
		la $s7 gameMap
		la $s5 tempMap
		jal copy_to_matrix # tempMap = gameMap | deepcopy
		
		# wait 1 second (1000ms)
		li $a0, 1000
		li $v0, 32
		syscall
		
		sub $t8, $t8, 1 # count--
		blez $t8, Exit # if(count <= 0) then go to Exit
		
		# print defaultMap to console
		la $s3, defaultMap
		jal print_matrix
		
		# wait 1 second (1000ms)
		li $a0, 1000
		li $v0, 32
		syscall
		
		
		sub $t8, $t8, 1 # count--
		bgtz $t8, do_while # if(count > 0) then go to do_while
	
	j Exit
	
###################### End Main #########################


					
###################### Subroutine #######################

copy_to_matrix: #it copies elements of two matrices | Arguments -> s5 = source-matrix-addres, s7 = target-matrix-address
	#store the jumped address
	move $t9, $ra
	
	Outer_For_Decleration_cp: 		# cp means is copy_matrix
		li $t0, 0 			# rowIdx = 0
	Outer_For_Body_cp:
		beq $t0, $s0, Outer_End_For_cp 		# if(rowIdx == rowSize) then go to Outer_End_For_cp 

		Inner_For_Decleration_cp:
			li $t1, 0 			# colIdx = 0
		Inner_For_Body_cp:
			beq $t1, $s1, Inner_End_For_cp 	# if(colIdx == colSize) then go to Inner_EndFor
			
			move $t6, $t0			# t6 = rowIdx
			move $t7, $t1			# t7 = colIdx
			move $s3, $s5			# s3 is argument of get_char_from_index subroutine | s3 = source-matrix-addres
			#move $t9, $ra			# store before jump address to temp
			jal get_char_from_index		# s4 = source-matrix-addres[rowIdx][colIdx]
			#move $ra, $t9			# get before jump address
			
			
			move $t6, $t0			# t6 = rowIdx
			move $t7, $t1			# t7 = colIdx
			move $s2, $s4			# s2 = result of get_char_from_index
			move $s3, $s7			# s3 = target-matrix-address
			#move $t9, $ra
			jal set_char_to_index		# target-matrix-address[rowIdx][colIdx] = s2
			#move $ra, $t9
	
	
			add $t1, $t1, 1			# colIdx++
			j Inner_For_Body_cp
	
		Inner_End_For_cp:

		add $t0, $t0, 1			# rowIdx++
		j Outer_For_Body_cp
	
	Outer_End_For_cp:
	
		jr $t9

######################### END ###########################

																										

###################### Subroutine #######################
																																																																													
set_char_to_index:  # it writes given char to matrix | Arguments -> t6 = rowIdx, t7 = colIdx, s2 = character, s3 = target-matrix-address
	
	move $t5, $s3 		# targetAddress = target-matrix-address
		
	mul $t4, $t6, $s1	# targetIdx = rowIdx * colSize
	add $t4, $t4, $t7	# targetIdx = targetIdx + colIdx
	add $t5, $t5, $t4	# targetAddress += targetIdx
	
	sb $s2, 0($t5)		# value of targetAddress = character
	jr $ra


######################### END ###########################



###################### Subroutine #######################

get_char_from_index:  # it read element from given matrix | Arguments -> t6 = rowIdx, t7 = colIdx, s3 = target-matrix-address | Result -> s4
	
	move $t5, $s3		# targetAddress = target-matrix-address
		
	mul $t4, $t6, $s1	# targetIdx = rowIdx * colSize
	add $t4, $t4, $t7	# targetIdx = targetIdx + colIdx
	add $t5, $t5, $t4	# targetAddress += targetIdx
	
	lb  $s4, 0($t5)		# result = value of target-matrix-address
	jr $ra

######################### END ###########################



###################### Subroutine #######################

print_matrix:	#it prints the matrix to console | Arguments -> s3 = target-matrix-address
	
	move $t2, $s3		# printMap = target-matrix-address
	
	Outer_For_Decleration_pm:
		li $t0, 0 				# rowIdx = 0
	Outer_For_Body_pm:
		beq $t0, $s0, Outer_For_End_pm 		# if(rowIdx == rowSize) then go to Outer_For_End_pm 
	
		Inner_For_Decleration_pm:
			li $t1, 0 			# colIdx = 0
		Inner_For_Body_pm:
			beq $t1, $s1, Inner_For_End_pm 	# if(colIdx == colSize) then go to Inner_For_End_pm
			
			# print printMap[baseAddress]
			li $v0, 11
		    	lb $a0, 0($t2)
		    	syscall
	    	
	    		addi $t2, $t2, 1 		# baseAddress++
		
			add $t1, $t1, 1			# colIdx++
			j Inner_For_Body_pm
		
		Inner_For_End_pm:
	
		#print newline
		li $v0, 11	
		li $a0, 10
		syscall
	
		add $t0, $t0, 1				#rowIdx++
		j Outer_For_Body_pm
		
	Outer_For_End_pm:
		
		#print newline
		li $v0, 11
		li $a0, 10
		syscall
		
		jr $ra
	    
######################### END ###########################
    
    
    
Exit:
	
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
