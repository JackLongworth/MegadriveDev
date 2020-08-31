LoadSpriteTables:
	; a0 - Sprite data address
	; d0 - Number of sprites
	
	move.l #vdp_write_sprite_table,vdp_control_port
	
	subq.b #$1,d0		; 2 sprites attributes
	.AttrCopy:
	move.l (a0)+,vdp_data_port
	move.l (a0)+,vdp_data_port
	dbra d0,.AttrCopy
	
	rts
	
SetSpritePos:
	; Set sprite position
	; d0 (b) - Sprite ID
	; d1 (w) - coordinate
	; d2 (b) - the table entry offset (0 bits = Y, 6 bits = X)
	
	clr.l d3
	move.b d0,d3		; Move the sprite ID to d3
	
	mulu.w #$8,d3		; Sprite array offset (each table is 8 bytes)
	add.b d2,d3		; coordinate offset added
	swap d3		; Move to upper word
	add.l #vdp_write_sprite_table,d3		; Add to sprite table address (now points to the corresponding coordinate entry)
	
	move.l d3,vdp_control_port		; Set dest address to write our new coordinate
	move.w d1,vdp_data_port		; Move coordinate into the VRAM, overwrite the old coordinate in the table
	
	rts
	
SetSpritePosX:
	; Set sprite position
	; d0 (b) - Sprite ID
	; d1 (w) - coordinate
	
	move.b #$6,d2
	jsr SetSpritePos
	
	rts

SetSpritePosY:
	; Set sprite Y position
	; d0 (b) - Sprite ID
	; d1 (w) - Y coordinate
	
	move.b #$0,d2
	jsr SetSpritePos
	
	rts
	
AnimateSpriteFwd:
	; Advance sprite to next frame 
	; d0 (w) Sprite Address (VRAM)
	; d1 (w) Size of one sprite frame (in bytes)
	; d2 (w) Number of animation frames
	; a0 --- Address of sprite data (ROM)
	; a1 --- Address of animation data (ROM)
	; a2 --- Address of animation frame counter (RAM, writeable)
	
	clr.l d3
	move.b (a2),d3 		; Read current animation frame number
	addi.b #$1,(a2)		; Advance to next frame
	cmp.b d3,d2		; Check if the number of animation frames has been hit
	bne .NotEndFrame		; Branch if we haven't reached the end of the animation
	move.b #$0,(a2)		; If the end frame has been hit, return to the beginning of the animation
	.NotEndFrame:
	
	move.b (a1,d3.w),d4		; Get original frame index (d4) from animation data array
	move.b (a2),d2		; Read next animation frame number (d2)
	move.b (a1,d3.w),d5		; Get next frame index (d5) from animation data array
	
	cmp.b d3,d4		; Has animation frame index changed?
	beq .NoChange		; If not, nothing to do
	
	; spriteDataAddress = spriteDataAddress + (sizeOfFrame * newTileID)
	move.l a0,d2		; Move sprite data ROM address to d2 (can't do maths with address registers)
	move.w d1,d4		; Move size of one sprite frame to d4
	mulu.w d5,d4		; Multiply with new frame index to get new ROM offset (result in d4)
	add.w d4,d2		; Add to sprite data address to get new one 
	move.l d2,a0		; Move back into the address register
	
	jsr LoadTiles		; New tile address is in a0, VRAM address already in d0, num tiles already in d1 - jump straight to load tiles
	
	.NoChange:
	rts