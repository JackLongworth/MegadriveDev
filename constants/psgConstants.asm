; First byte:
; Bit 7    : Latch. ON indicates this is the first (or only) byte being written
; Bits 6-5 : Channel ID (0-3)
; Bit 4    : Data type. ON if data bits contain attenuation value, OFF if they contain the square wave counter reset
; Bits 3-0 : The data. Either all 4 bits of the attenuation value, or the lower 4 bits of counter reset value

; Second byte:
; Bit 7    : Latch. OFF indicates this is the second byte, and will only contain the remainder of data
; Bit 6    : Unused
; Bits 5-0 : Upper 6 bits of data

; channel 0, 440.4hz

psg_control_port equ $00C00011