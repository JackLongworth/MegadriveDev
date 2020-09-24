	nop 0,8		; alligned 

Stickman:

	dc.l $00222200
	dc.l $00222200
	dc.l $00022000
	dc.l $22222222
	dc.l $00022000
	dc.l $00022000
	dc.l $00220200
	dc.l $02200020
	
StickmanEnd
StickmanSizeB equ (StickmanEnd-Stickman)
StickmanSizeW equ (StickmanSizeB/SizeWord)
StickmanSizeL equ (StickmanSizeB/SizeLong)
StickmanSizeT equ (StickmanSizeB/SizeTile)
StickmanTileID equ (StickmanVRAM/SizeTile)
StickmanDimensions equ (%00000101)
StickmanSpriteID equ 0