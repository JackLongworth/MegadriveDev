AddSpriteTableEntry:
	; Args on stack
	; d0 (l) - Sprite Table Index
	; (b) - Dimensions
	; (b) - H/V flipping (bits 3/4), palette index (bits 5-6), priority (bit 7)
	; (b) - First Tile index in VRAM
	
	move.l d0,d1		; copy table index into d1
	
	mulu.w #SizeSpriteTable,d1		; get the offset for the sprite table entry
	move.l d1,d2		; copy into d2
	sub.l #$9,d2		; address of the previous next sprite index
	
	
	move.l #sprite_table_vram_destination,d0
	
	
	; find offset for the sprite table entry destination
	; add.l
	
	
	

LoadSpriteTables:
	; a0 - Sprite data address
	; d0 - Number of sprites
	
	move.l d0,-(sp)		; push the number of sprites onto the stack
	
	move.l #sprite_table_vram_destination,d0	; move the vram location of the sprite table to d0
	move.l #vram_write,d1	; move the command to d1
	jsr SendVDPCommandWithAddress
	
	move.l (sp)+,d0		; pop the number of sprites back into d0
	
	subq.b #$1,d0		; subtract 1 for the loop
	.AttrCopy:
	move.l (a0)+,vdp_data_port		; 2 longwords of data for each table
	move.l (a0)+,vdp_data_port
	dbra d0,.AttrCopy
	
	rts
	
SetSpritePos:
	; Set sprite position
	; d0 (b) - Sprite ID
	; d1 (w) - coordinate
	; d2 (b) - the table entry offset (0 bits = Y, 6 bits = X)
	
	move.l d0,-(sp)		; push sprite ID onto the stack
	
	mulu.w #SizeSpriteTable,d0		; Sprite array offset (each table is 8 bytes)
	add.w d2,d0		; coordinate offset added = sprite table offset
	add.w #sprite_table_vram_destination,d0		; Get the absolute VRAM destination (sprite table vram + sprite table offset)
	
	move.l d1,-(sp)		; push coordinate onto stack
	
	move.b #vram_write,d1		; d1 = command
	jsr SendVDPCommandWithAddress
	
	move.l (sp)+,d1		; pop the coordinate off stack
	
	move.w d1,vdp_data_port		; Move coordinate into the VRAM, overwrite the old coordinate in the table
	
	move.l (sp)+,d0		; pop the sprite ID off the stack
	
	rts
	
SetSpritePosX:
	; Set sprite position
	; d0 (b) - Sprite ID
	; d1 (w) - coordinate
	
	move.l #$6,d2		; set the coordinate offset for the sprite table
	jsr SetSpritePos
	
	rts

SetSpritePosY:
	; Set sprite Y position
	; d0 (b) - Sprite ID
	; d1 (w) - Y coordinate
	
	move.l #$0,d2		; set the coordinate offset for the sprite table
	jsr SetSpritePos
	
	rts
	
; AnimateSpriteFwd:
	; ; Advance sprite to next frame 
	; ; d0 (w) Sprite Address (VRAM)
	; ; d1 (w) Size of one sprite frame (in bytes)
	; ; d2 (w) Number of animation frames
	; ; a0 --- Address of sprite data (ROM)
	; ; a1 --- Address of animation data (ROM)
	; ; a2 --- Address of animation frame counter (RAM, writeable)
	
	; clr.l d3
	; move.b (a2),d3 		; Read current animation frame number
	; addi.b #$1,(a2)		; Advance to next frame
	; cmp.b d3,d2		; Check if the number of animation frames has been hit
	; bne .NotEndFrame		; Branch if we haven't reached the end of the animation
	; move.b #$0,(a2)		; If the end frame has been hit, return to the beginning of the animation
	; .NotEndFrame:
	
	; move.b (a1,d3.w),d4		; Get original frame index (d4) from animation data array
	; move.b (a2),d2		; Read next animation frame number (d2)
	; move.b (a1,d3.w),d5		; Get next frame index (d5) from animation data array
	
	; cmp.b d3,d4		; Has animation frame index changed?
	; beq .NoChange		; If not, nothing to do
	
	; ; spriteDataAddress = spriteDataAddress + (sizeOfFrame * newTileID)
	; move.l a0,d2		; Move sprite data ROM address to d2 (can't do maths with address registers)
	; move.w d1,d4		; Move size of one sprite frame to d4
	; mulu.w d5,d4		; Multiply with new frame index to get new ROM offset (result in d4)
	; add.w d4,d2		; Add to sprite data address to get new one 
	; move.l d2,a0		; Move back into the address register
	
	; jsr LoadTiles		; New tile address is in a0, VRAM address already in d0, num tiles already in d1 - jump straight to load tiles
	
	; .NoChange:
	; rts