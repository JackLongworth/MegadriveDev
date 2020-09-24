	nop 0,8		; alligned
	
Coin:
	
	dc.l $00222200
	dc.l $02222220
	dc.l $02222220
	dc.l $02222220
	dc.l $02222220
	dc.l $02222220
	dc.l $00222200
	dc.l $00000000
	
CoinEnd
CoinSizeB equ (CoinEnd-Coin)
CoinSizeW equ (CoinSizeB/SizeWord)
CoinSizeL equ (CoinSizeB/SizeLong)
CoinSizeT equ (CoinSizeB/SizeTile)
CoinSizeTileID equ (CoinVRAM/SizeTile)
CoinDimensions equ (%00000101)