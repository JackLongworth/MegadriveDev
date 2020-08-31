LoadTiles:
; a0 (l) - Tile address
; d0 (w) - VRAM address
; d1 (l) - Num Tiles

	swap d0		; Shift VRAM address to the upper word
	add.l #vdp_write_tiles,d0		; VRAM write cmd + VRAM tiles destination address
	move.l d0,vdp_control_port		; Send address to the VDP control port
	
	subq.b #$1,d1		; Num tiles - 1
	.TileCopy:
	move.w #$07,d2		; 8 longwords in title
	.LongCopy:
	move.l (a0)+,vdp_data_port		; Copy one line of tile to VDP data port
	dbra d2,.LongCopy
	dbra d1,.TileCopy
	
	rts
	
	
	
	include utils\textUtils.asm
	include utils\spriteUtils.asm