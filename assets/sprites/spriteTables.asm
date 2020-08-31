SpriteDescriptions:

	; Sprite 1
	dc.w $0000		; Y coordinate (+128)
	dc.b %00001111		; Width (bits 0-1) and height (bits 2-3)
	dc.b $01		; Index of next sprite (linked list)
	dc.b $00		; H/V flipping (bits 3/4), palette index (bits 5-6), priority (bit 7)
	dc.b Sprite1TileID		; Index of first tile
	dc.w $0000		; X coordinate (+128)
	
	; Sprite 2
	dc.w $0000
	dc.b %00001111
	dc.b $02
	dc.b $20
	dc.b Sprite2TileID
	dc.w $0000
	
	; Sega Logo
	dc.w $0000
	dc.b SegaLogoDimensions
	dc.b $00
	dc.b $40
	dc.b SegaLogoTileID
	dc.w $0000