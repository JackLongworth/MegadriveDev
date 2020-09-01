LoadPalette:
	; a0 --- Address in ROM of the palette set
	; d0 (l) --- ID of the specific palette in the set
	
	mulu.w #SizePalette,d0		; the index of the palette multiplied by the size of the palette to get the offset from the palette address
	swap d0		; move the offset to the upper word
	add.l #vdp_write_palettes,d0		; Add CRAM write command to the offset
	move.l d0,vdp_control_port		; Write to the CRAM at the address + offset calculated
	
	move.l #(SizePalette/SizeLong),d0		; Size of palette
	.PaletteCopy:
	move.l (a0)+,vdp_data_port		; Move longword to CRAM
	dbra d0,.PaletteCopy

	rts