; ***********************
; Art asset VRAM mapping
; ***********************

PixelFontVRAM: equ $0000
Sprite1VRAM: equ PixelFontVRAM+PixelFontSizeB
Sprite2VRAM: equ Sprite1VRAM+Sprite1SizeB
SegaLogoVRAM: equ Sprite2VRAM+Sprite2SizeB
	; The next address just needs to be the seag logo address plus one frame
	; There is only one animation frame in VRAM at a time
Level1TilesVRAM equ SegaLogoVRAM+SegaLogoOneFrameB
RunningManVRAM equ Level1TilesVRAM+Level1TilesSizeB

; ********************
; Include all fonts
; ********************
	include assets\fonts\pixelfont.asm
	
	
; *****************************************
; Include all the sprites and the tables	
; *****************************************
	include assets\sprites\sprite1.asm
	include assets\sprites\sprite2.asm
	include assets\sprites\testanim.asm
	include assets\sprites\runningman.asm
	include assets\sprites\spriteTables.asm
	include assets\tiles\level1_tiles.asm
	include assets\maps\level1_map.asm
	
	
; ***********************
; Include all Palettes
; ***********************
	include assets\palettes\paletteset.asm
	include assets\palettes\level1_palette.asm
	include assets\palettes\runningman_palette.asm