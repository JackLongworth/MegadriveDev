LoadTiles:
; a0 (l) - Tile address
; d0 (w) - VRAM address
; d1 (l) - Num Tiles
	
	move.l d1,-(sp)		; push number of tiles onto the stack
	
	move.l #vram_write,d1		; move command into d1 
	jsr SendVDPCommandWithAddress 		; VRAM address already in d0
	
	move.l (sp)+,d1		; pop the number of tiles back into d1
	subq.b #$1,d1		; Num tiles - 1
	.TileCopy:
	clr.l d2		; clear d2
	move.b #(SizeTile/SizeLong)-1,d2		; number of longs in a tile minus 1
	.LongCopy:
	move.l (a0)+,vdp_data_port		; Copy one line of tile to VDP data port
	dbra d2,.LongCopy
	dbra d1,.TileCopy
	
	rts
	
	
; LoadMapPlaneA:
	; ; a0 (l) - Map address (ROM)
	; ; d0 (b) - Size in words
	; ; d1 (b) - Y offset
	; ; d2 (w) - First tile ID
	; ; d3 (b) - Palette ID
	
	; mulu.w #$0040,d1		; Multiply the Y offset by the line width (in words)
	; swap d1		; Shift the result to the upper word of d1
	; add.l #vdp_write_plane_a,d1		; Add PlaneA write cmd + address
	; move.l d1,vdp_control_port	; Move dest address to VDP control port
	
	; rol.l #$08,d3		; Shift palette ID to bits 14-15
	; rol.l #$05,d3		; Can only rol 8 bits at a time
	
	; subq.l #$01,d0		; Number of words in d0, minus 1 for the loop
	
	; .Copy:
	; move.w (a0)+,d4		; Move tile ID from map to lower word of d4
	; and.l #%0011111111111111,d4		; Mask out original palette
	; or.l d3,d4		; Replace with our own
	; add.w d2,d4		; Add first tile offset to d4
	; move.w d4,vdp_data_port		; Move to VRAM
	; dbra d0,.Copy		; Loop
	
	; rts
	
	; include utils\textUtils.asm
	include utils\spriteUtils.asm
	include utils\paletteUtils.asm
	include utils\vdpUtils.asm
	;include utils\soundUtils.asm