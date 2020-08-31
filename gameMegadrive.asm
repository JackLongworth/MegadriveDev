	include initMegadrive.asm
	include utils\utils.asm
	include input\controllerInput.asm
	
Main:

	; Set autoincrement to 2 bytes
	move.w #$8F02,vdp_control_port
	
	
	; ******************
	; Load the Palettes
	; ******************
	move.l #vdp_write_palettes,vdp_control_port		; Set up VDP to write to CRAM
	
	lea Palettes,a0		; Load address of the Palette into a0
	move.l #$18,d0		; 2 palettes, 16 longwords minus 1 for counter
	
	.PaletteToVDPLoop:
	move.l (a0)+,vdp_data_port		; Move data to VDP data port and increment source address
	dbra d0,.PaletteToVDPLoop
	
	
	; Set background colour to palette 0, colour 1
	move.w #$8701,vdp_control_port
	
	
	; Load the font into VRAM
	; lea PixelFont,a0		; Move font address to a0
	; move.l #PixelFontVRAM,d0		; Move VRAM destination address to d0
	; move.l #PixelFontSizeT,d1		; Move number of characters in font to d1
	; jsr LoadTiles
	
	
	; Load the sprites into VRAM
	lea Sprite1,a0		; Load the sprite address into a0
	move.l #Sprite1VRAM,d0		; Move the VRAM address for the sprite into d0
	move.l #Sprite1SizeT,d1		; Move the number of tiles to load into d1 
	jsr LoadTiles
	
	lea Sprite2,a0
	move.l #Sprite2VRAM,d0
	move.l #Sprite2SizeT,d1
	jsr LoadTiles
	
	lea SegaLogo,a0
	move.l #SegaLogoVRAM,d0
	move.l #SegaLogoOneFrameT,d1
	jsr LoadTiles
	
	; Draw the sprite (write the sprite tables to VRAM)
	lea SpriteDescriptions,a0		; Sprite table data
	move.w #$3,d0		; 3	sprites
	jsr LoadSpriteTables
	
	move.w #$0,d0	; Sprite ID
	move.w #$C0,d1	; X coordinate
	jsr SetSpritePosX	; Set X position
	move.w #$A0,d1	; Y coordinate
	jsr SetSpritePosY	; Set Y position
	
	move.w #$1,d0 	; Sprite ID
	move.w #$A0,d1	; X coordinate
	jsr SetSpritePosX	; Set X position
	move.w #$90,d1	; Y coordinate
	jsr SetSpritePosY	; Set Y position
	
	move.w #$2,d0	; Sprite ID
	move.w #$C0,d1	; X coordinate
	jsr SetSpritePosX	; Set X position
	move.w #$C0,d1	; Y coordinate
	jsr SetSpritePosY	; Set Y position
	
	; move.l #$80,d4		; Store X position in d4
	; move.l #$80,d5		; Store Y position in d5
	
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
	
	; move.w #$0,d0		; Sprite ID 0
	; move.w d4,d1		; X coordinate
	; jsr SetSpritePosX		; Set X coordinate
	; move.w d5,d1		; Y coordinate
	; jsr SetSpritePosY		; Set Y coordinate
	
	move.l #SegaLogoVRAM,d0		; Move sprite VRAM address to d0
	move.l #SegaLogoOneFrameB,d1		; Move sprite size (num tiles in one animation frame) to d1
	move.l #SegaLogoAnimNumFrames,d2		; Move number of animation frames to (size of animation data in bytes) d2
	lea SegaLogo,a0		; Move address of sprite data (ROM) to a0
	lea SegaLogoAnimData,a1		; Move address of animation data (ROM) to a1
	lea segalogo_anim_frame,a2		; Move address of current frame (RAM) in animation to a2
	jsr AnimateSpriteFwd		; Advance sprite animation
	
	jsr WaitVBlankEnd		; Wait for end of vblank
	
	jmp GameLoop
	
	
	bsr *
   
   ; ---------------------------------------------------
   ; choose the font here (includes all the address data)
   
   include assets\assetmap.asm