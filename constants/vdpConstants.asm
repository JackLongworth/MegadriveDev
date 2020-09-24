; Ports
vdp_control_port equ $00C00004
vdp_data_port equ $00C00000

; Commands
vram_write equ %000001
cram_write equ %000011
vsram_write equ %000101
vram_read equ %000000
cram_read equ %001000
vsram_read equ %000100

; CRAM
palette_cram_destination equ $0000

; VRAM
tiles_vram_destination equ $0000
plane_a_vram_destination equ $C000
sprite_tiles_vram_destination equ $2000
sprite_table_vram_destination equ $E000
hscroll_vram_destination equ $D000

; VSRAM
vscroll_vsram_destination equ $0000

; VDP Registers
vdp_register_backgroud_colour equ 7		; RAM access address background colour
vdp_register_autoincrement equ 15		; RAM access address auto-increment


; Macros
; --------------------------------------------------------------------------------------------

SetVDPRegister macro ; REGISTER,VALUE
	move.w #((($80|\1)<<8)|\2),vdp_control_port
	ENDM

; --------------------------------------------------------------------------------------------