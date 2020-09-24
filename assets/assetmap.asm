; ***********************
; Art asset VRAM mapping
; ***********************

StickmanVRAM: equ SizeTile		; Leave a TileID 0 empty for the transparent tile
CoinVRAM equ (StickmanVRAM+StickmanSizeB)	


; ********************
; Include all fonts
; ********************
	
	
; *****************************************
; Include all the sprites and the tables	
; *****************************************
	include assets\sprites\stickman.asm
	include assets\sprites\spriteTables.asm
	
	
; ***********************
; Include all Palettes
; ***********************
	include assets\palettes\paletteset.asm