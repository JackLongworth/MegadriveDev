; ***********************
; Art asset VRAM mapping
; ***********************

PixelFontVRAM: equ $0000
Sprite1VRAM: equ PixelFontVRAM+PixelFontSizeB
Sprite2VRAM: equ Sprite1VRAM+Sprite1SizeB
SegaLogoVRAM: equ Sprite2VRAM+Sprite2SizeB


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
	include assets\sprites\spriteTables.asm
	
	
; ***********************
; Include all Palettes
; ***********************
	include assets\palettes\paletteset.asm