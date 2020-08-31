	include assets\charset.asm

	; Allign 8 bytes
	nop 0,8
	
	
DrawTextPlaneA:
; a0 (l) - String address 
; d0 (l) - First tile ID of font
; d1 (w) - XY coordinate in tiles
; d2 (b) - Palette

	clr.l d3		
	move.b d1,d3		; Move the Y coordinate into d3 (lower byte of d1)
	mulu.w #$0040,d3	; Multiply Y by horizontal line width (64 per tile)
	ror.l #$8,d1		; Shift X ccordinate from upper to lower byte
	add.b d1,d3			; Add X coord to offset
	mulu.w #$2,d3		; Convert to words
	swap d3		; Shift address offset to upper word
	add.l #vdp_write_plane_a,d3		; Add PlaneA write cmd + address
	move.l d3,vdp_control_port		; Send to VDP control port
	
	clr.l d3		; Clear d3 ready to work with again
	move.b d2,d3		; Move Palette ID (lower byte) to d3
	rol.l #$8,d3		; Shift palette ID to bits  and 15 of d3
	rol.l #$5,d3		; Can only rol bits up to 8 places
	
	lea ASCIIMap,a1		; Load address of ASCII map into a1
	
	.CharCopy:
	move.b (a0)+,d2		; Move ACSII byte to lower byte of d2
	cmp.b #$0,d2		; Test if the lower byte is 0 (String termination)
	beq.b .End		; If byte zero, branch to return of subroutine
	
	sub.b #ASCIIStart,d2		; Subtract first ASCII code to get table entry index
	; and.w #$00FF,d2
	move.b (a1,d2.w),d3		; Move tile ID from table to d3 (the index for the table is in the lower word of d2)
	add.w d0,d3		; Offset the tile ID by the first ID of the font (in case of multiple fonts loaded)
	move.w d3,vdp_data_port		; Move Palette and Pattern ID to the VDP data port
	jmp .CharCopy
	
	.End:
	rts