SpriteDescriptions:

	; Stickman ID 0
	dc.w $0000		; Y coordinate (+128)
	dc.b StickmanDimensions		; Width (bits 0-1) and height (bits 2-3)
	dc.b $01		; Index of next sprite (linked list)
	dc.b $00		; H/V flipping (bits 3/4), palette index (bits 5-6), priority (bit 7)
	dc.b StickmanTileID		; Index of first tile
	dc.w $0000		; X coordinate (+128)