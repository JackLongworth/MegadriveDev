UserRAM equ $00FF0000

; Start of Main RAM to store these counters
hblank_counter equ UserRAM
vblank_counter equ hblank_counter+SizeLong

x_position equ vblank_counter+SizeLong
y_position equ x_position+SizeWord

