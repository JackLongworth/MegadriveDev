	include initMegadrive.asm
	include utils\utils.asm
	include input\controllerInput.asm
	
Main:

	; Set autoincrement to 2 bytes
	SetVDPRegister vdp_register_autoincrement,2
	
	jsr InitialisePalettes
	
	; Set background colour to palette 0, colour 3
	SetVDPRegister vdp_register_backgroud_colour,$05
	
	lea Stickman,a0		; ROM address of the tiles for Stickman
	move.l #StickmanVRAM,d0		; move the address in VRAM to d0
	move.l #StickmanSizeT,d1		; move number of tiles to d1
	jsr LoadTiles
	
	lea SpriteDescriptions,a0		; load the address of the sprite tables into a0
	move.l #$2,d0		; move the number of sprites into d0
	jsr LoadSpriteTables;
	
	move.w #$80,x_position		; the x pos
	move.w #$81,y_position		; the y pos	
	
	move.l #StickmanSpriteID,d0		; set the sprite ID to stickman
	move.w x_position,d1
	jsr SetSpritePosX
	move.w y_position,d1
	jsr SetSpritePosY
	
	; *****************
	; Main Game Loop
	; *****************
GameLoop:

	; ***********************
	; Read controller input
	; ***********************
	jsr ReadController1		; writes the word of controller data to d0
	
	move.l #$1,d1		; set original sprite speed
	
	btst #controller_button_a,d0		; Check if a button pressed
	bne .AButtonNotPressed
	move.l #$2,d1		; Double sprite speed
	.AButtonNotPressed:		; else do nothing
	
	btst #controller_button_up,d0		; Check if up button pressed
	bne	.UpButtonNotPressed
	sub.w d1,y_position		; subtract the speed from the Y position
	.UpButtonNotPressed:

	btst #controller_button_down,d0		; Check if the down button is pressed
	bne .DownButtonNotPressed
	add.w d1,y_position		; add the speed to the Y position
	.DownButtonNotPressed:

	btst #controller_button_left,d0		; Check if the left button is pressed
	bne .LeftButtonNotPressed		
	sub.w d1,x_position		; subtract the speed from the X position
	.LeftButtonNotPressed:

	btst #controller_button_right,d0		; Check if the right button is pressed
	bne .RightButtonNotPressed		
	add.w d1,x_position		; add the speed to the X position
	.RightButtonNotPressed:
	
	; ******************************
	; Update sprites during vblank
	; ******************************
	
	jsr WaitVBlankStart		; Wait for start of vblank
	
	move.l StickmanSpriteID,d0
	
	move.w x_position,d1
	jsr SetSpritePosX
	
	move.w y_position,d1
	jsr SetSpritePosY
	
	jsr WaitVBlankEnd		; Wait for end of vblank
	
	jmp GameLoop
   
   ; ---------------------------------------------------
   ; choose the font here (includes all the address data)
   
   include assets\assetmap.asm
   
   
__end		; Very last line, End of the ROM Address