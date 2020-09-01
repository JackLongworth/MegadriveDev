	include initMegadrive.asm
	include utils\utils.asm
	include input\controllerInput.asm
	
Main:

	; Set autoincrement to 2 bytes
	move.w #$8F02,vdp_control_port
	
	; Set background colour to palette 0, colour 8
	move.w #$8708,vdp_control_port
	
	; ******************
	; Load the Palettes
	; ******************
	lea Level1Palette,a0	; Palette source address in ROM to a0
	move.l #$0,d0		; Palette slot ID to d0
	jsr LoadPalette
	
	; *****************
	; Load map tiles
	; *****************
	lea Level1Tiles,a0		; Tileset source address (ROM) to a0
	move.l #Level1TilesVRAM,d0		; VRAM destination address to d0
	move.l #Level1TilesSizeT,d1		; Number of tiles in the tileset
	jsr LoadTiles
	
	; ***********
	; Load map
	; ***********
	lea Level1Map,a0		; Map data to a0
	move.w #Level1MapSizeW,d0		; Size (words) to d0
	move.l #$18,d1		; Y offset to d1
	move.w #Level1TilesTileID,d2		; First tile ID to d2
	move.l #$0,d3		; Palette ID to d0
	jsr LoadMapPlaneA
	
	
	; *****************
	; Main Game Loop
	; *****************
GameLoop:

	; ***********************
	; Read controller input
	; ***********************
	; jsr ReadController1		; Read controller 1 state, result in d0
	
	; move.l #$1,d6		; Default sprite move speed
	
	; btst #controller_button_a,d0		; Check A button
	; bne .NoA		; Branch if button off
	; move.l #$2,d6		; Double sprite move speed
	; .NoA:
	
	; btst #controller_button_right,d0		; Check right button
	; bne .NoRight		; Branch if button off
	; add.w d6,d4		; Increment sprite X position by move speed
	; .NoRight:
	
	; btst #controller_button_left,d0		; Check left button
	; bne .NoLeft		; Branch if button off
	; sub.w d6,d4		; Decrement sprite X position by move speed
	; .NoLeft:
	
	; btst #controller_button_down,d0		; Check down button
	; bne .NoDown		; Branch if button off
	; add.w d6,d5		; Increment sprite Y position by move speed
	; .NoDown:
	
	; btst #controller_button_up,d0		; Check up button
	; bne .NoUp		; Branch if button off
	; sub.w d6,d5		; Decrement sprite Y position by move speed
	; .NoUp:
	
	
	; ******************************
	; Update sprites during vblank
	; ******************************
	
	jsr WaitVBlankStart		; Wait for start of vblank
	
	
	jsr WaitVBlankEnd		; Wait for end of vblank
	
	jmp GameLoop
	
	
	bsr *
   
   ; ---------------------------------------------------
   ; choose the font here (includes all the address data)
   
   include assets\assetmap.asm