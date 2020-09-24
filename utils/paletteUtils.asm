InitialisePalettes:
	lea Palettes,a0		; move the address of the palette to a0
	move.l #$0,d0		; move the palette ID to d0
	jsr LoadPalette		; Load the palette

LoadPalette:
	; a0 --- Address in ROM of the palette set
	; d0 (l) --- ID of the specific palette in the set
	
	mulu.w #SizePalette,d0		; the index of the palette multiplied by the size of the palette to get the offset from the palette address
	add.l #palette_cram_destination,d0		; Add the palette writing address to the offset (palette index * palette size)
	move.l #cram_write,d1
	
	jsr SendVDPCommandWithAddress;
	
	move.l #(SizePalette/SizeLong),d0		; Size of palette  (in longs)
	.PaletteCopy:
	move.l (a0)+,vdp_data_port		; Move longword to CRAM
	dbra d0,.PaletteCopy

	rts