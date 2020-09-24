	include constants\constants.asm		; hold all the constants for all the different hardware (processors, ports etc)
	
; **********************************
; SEGA MEGADRIVE ROM HEADER
; **********************************

	dc.l $00FFE000 		; Initial Stack Pointer Value
	dc.l Initialise 		; The starting point of the program
	dc.l Exception			; Bus Error
	dc.l Exception			; Address Error
	dc.l Exception 			; Illegal Instruction
	dc.l Exception 			; Division by zero
	dc.l Exception 			; CHK exception
	dc.l Exception 			; TRAPV exception
	dc.l Exception 			; Priviledge violation
	dc.l Exception 			; TRACE Exception
	dc.l Exception			; Line-A emulator
	dc.l Exception			; Line-F emulator
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Spurious Exception
	dc.l Exception 			; IRQ level 1
	dc.l Exception 			; IRQ level 2
	dc.l Exception 			; IRQ level 3
	dc.l HBlankInterrupt	; IRQ level 4
	dc.l Exception 			; IRQ level 5
	dc.l VBlankInterrupt	; IRQ level 6
	dc.l Exception			; IRQ level 7
	dc.l Exception			; TRAP #00 exception
	dc.l Exception			; TRAP #01 exception
	dc.l Exception			; TRAP #02 exception
	dc.l Exception			; TRAP #03 exception
	dc.l Exception			; TRAP #04 exception
	dc.l Exception			; TRAP #05 exception
	dc.l Exception			; TRAP #06 exception
	dc.l Exception			; TRAP #07 exception
	dc.l Exception			; TRAP #08 exception
	dc.l Exception			; TRAP #09 exception
	dc.l Exception			; TRAP #10 exception
	dc.l Exception			; TRAP #11 exception
	dc.l Exception			; TRAP #12 exception
	dc.l Exception			; TRAP #13 exception
	dc.l Exception			; TRAP #14 exception
	dc.l Exception			; TRAP #15 exception
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)
	dc.l Exception 			; Unused (reserved)

	dc.b "SEGA GENESIS    "									; Console Name
	dc.b "(C)SEGA 1992.SEP"									; Copyright holder and release date
	dc.b "WHATEVER THE GAMES CALLED                     "	; Domestic Name
	dc.b "WHATEVER THE GAMES CALLED                     "	; International name
	dc.b "GM XXXXXXXX-XX"									; Version number
	dc.w $0000												; Checksum
	dc.b "J               "									; I/O support
	dc.l $00000000											; Start address of ROM
	dc.l __end												; End address of ROM
	dc.l UserRAM										; Start address of RAM
	dc.l $00FFFFFF											; End address of RAM
	dc.l $00000000											; SRAM enabled
	dc.l $00000000											; Unused
	dc.l $00000000											; Unused
	dc.b "                                              "	; Notes (unused)
	dc.b "JUE             "									; Country codes
	
; ********************************************************************************************************
;
;	Initialisation Code
; ****************************************************************************************************
	
Initialise:		; Entry point address set in the ROM header
	
	tst.w mystery_reset	; Test mystery reset (expansion port reset?)
	bne Main 	; Branch if Not Equal to zero - to Main
	tst.w reset_button 	; Test reset button
	bne Main 	; Branch if Not Equal to zero - to Main
	
	
	; Clear the RAM
	move.l #$00000000,d0	; Place 0 into d0, ready to copy to each longword of RAM
	move.l #$00000000,a0	; Starting from address $0, clearing backwards
	move.l #$00003FFF,d1	; Clearing 64k's worth of longwords (minus 1, for the loop)
.ClearRAM: 
	move.l d0,-(a0)		; Decrement the address by 1 longword, before moving the zero from d0 to it 
	dbra d1,.ClearRAM 		; Decrement d0, repeat until d1 = 0
	
	
	; Write TMSS Signiture
	move.b hardware_info,d0 	; Move Megadrive hardware version to d0
	andi.b #%00001111,d0		; The version is stored in last four bits, so mask it
	beq .Skip		; If the version is 0 then we don't need to write the TMSS signiture 
	move.l #'SEGA',tmss_location	; If the version is 1 then we write the TMSS

	.Skip:
	
	
	; Initialise the Z80
	move.w #$0100,z80_busreq_port 	; Request access to the Z80 bus, by writing $0100 into the BUSREQ port
	move.w #$0100,z80_reset_port		; Hold the Z80 in a reset state, by writing $0100 into the RESET port
	
	.Wait:
	btst #$0,z80_bus_grant		; Test bit 0 of A11100 to see if the 68k has been given access to the Z80 bus yet
	bne .Wait		; If we don't yet have control, continue waiting
	
	lea Z80Data,a0		; Load address of data into a0
	move.l #z80_ram_address,a1	; Copying Z80 RAM address to a1
	move.l #$29,d0		; 42 bytes of init data (minus 1 for the loop)
.CopyZ80Data:
	move.b (a0)+,(a1)+		; Copy data, and increment the source/destination addresses
	dbra d0,.CopyZ80Data
	
	move.w #$0000,z80_busreq_port		; Release control of bus
	move.w #$0000,z80_reset_port		; Release reset state

	
	; Initialise the PSG
	lea PSGData,a0		; Load address of PSG data into a0
	move.l #$03,d0			; 4 bytes of data (minus 1 for loop)
.CopyPSGData:
	move.b (a0)+,psg_control_port	; Copy data to PSG RAM
	dbra d0,.CopyPSGData
	
	
	; Initialise the VDP
	lea VDPRegisters,a0		; Load address of register table into a0
	move.l #$17,d0		; 24 registers to write (minus 1 for loop)
	move.l #$00008000,d1		; 'Set register 0' command (and clear the rest of d1 ready)
	
.CopyVDPRegisters:
	move.b (a0)+,d1		; Move a byte of the register value to d1
	move.w d1,vdp_control_port		; Write comand and value to VDP control port
	add.w #$0100,d1		;Increment register #
	dbra d0,.CopyVDPRegisters
	
	
	; Initialise the Controllers
	move.b #$00,controller_1_control_port		; Controller port 1 CTRL
	move.b #$00,controller_2_control_port		; Controller port 2 CTRL
	move.b #$00,exp_port		; EXP port CTRL
	
	move.l #$00FF0000,a0		; Move $0 to a0
	movem.l (a0),d0-d7/a1-a7 	; Multiple move a0 to all registers
	move.l #$00000000,a0		; Clear a0
	
	
	;*****************************
	; bits in the status register 
	;-----------------------------
	; 0 - Trace exception
	; 1 - Unused
	; 2 - Supervisor mode (always enable)
	; 3 - Unused
	; 4 - Unused
	; 5 - Interrupt level (zero for all interrupts enabled)
	; 6 - Interrupt
	; 7 - Interrupt
	; 8 - Unused
	; 9 - Unused
	; 10 - Unused
	; 11 - CCR Extend
	; 12 - CCR Negative
	; 13 - CCR Zero
	; 14 - CCR Overflow
	; 15 - CCR Carry
	;----------------------------------
	move.w #$2000,sr
	
	jmp Main
	
VDPRegisters:
VDPReg0:  dc.b $14   ; 0: Horiz. interrupt on, display on
VDPReg1:   dc.b $74  ; 1: Vert. interrupt on, display on, screen blank off, DMA on, V28 mode (40 cells vertically), Genesis mode on
VDPReg2:   dc.b $30  ; 2: Pattern table for Scroll Plane A at $C000 (bits 3-5 of register becomes bits 13-15 of the vram address)
VDPReg3:   dc.b $40  ; 3: Pattern table for Window Plane at $10000 (bits of register add 10 zero's = $10000)
VDPReg4:   dc.b $05  ; 4: Pattern table for Scroll Plane B at $A000 (bits 0-2 of the register value add 13 zeros)
VDPReg5:   dc.b $70  ; 5: Sprite table at $E000 (bits 0-6 of register value plus 6 zeros)
VDPReg6:   dc.b $00  ; 6: Unused
VDPReg7:   dc.b $00  ; 7: Background colour - bits 0-3 = colour, bits 4-5 = palette
VDPReg8:   dc.b $00  ; 8: Unused
VDPReg9:   dc.b $00  ; 9: Unused
VDPRegA:   dc.b $00  ; 10: Frequency of Horiz. interrupt in Rasters (number of lines travelled by the beam)
VDPRegB:   dc.b $08  ; 11: External interrupts on, V/H scrolling on
VDPRegC:   dc.b $81  ; 12: Shadows and highlights off, interlace off, H40 mode (40 cells horizontally)
VDPRegD:   dc.b $34  ; 13: Horiz. scroll table at $D000 (bits 0-5 of register value plus 9 zeros)
VDPRegE:   dc.b $00  ; 14: Unused
VDPRegF:   dc.b $00  ; 15: Autoincrement off
VDPReg10:   dc.b $01 ; 16: Vert. scroll 32, Horiz. scroll 64
VDPReg11:   dc.b $00 ; 17: Window Plane X pos 0 left (pos in bits 0-4, left/right in bit 7)
VDPReg12:   dc.b $00 ; 18: Window Plane Y pos 0 up (pos in bits 0-4, up/down in bit 7)
VDPReg13:   dc.b $00 ; 19: DMA length lo byte
VDPReg14:   dc.b $00 ; 20: DMA length hi byte
VDPReg15:   dc.b $00 ; 21: DMA source address lo byte
VDPReg16:   dc.b $00 ; 22: DMA source address mid byte
VDPReg17:   dc.b $00 ; 23: DMA source address hi byte, memory-to-VRAM mode (bits 6-7)
	
PSGData:
   dc.w $9fbf,$dfff
	
Z80Data:
   dc.w $af01,$d91f
   dc.w $1127,$0021
   dc.w $2600,$f977
   dc.w $edb0,$dde1
   dc.w $fde1,$ed47
   dc.w $ed4f,$d1e1
   dc.w $f108,$d9c1
   dc.w $d1e1,$f1f9
   dc.w $f3ed,$5636
   dc.w $e9e9,$8104
   dc.w $8f01
	
; ***************************************************
; Interrupts for the horizontal and vertical retrace
; ***************************************************

	include timing.asm
	
HBlankInterrupt:
	addi.l #$1,hblank_counter		; Increment hinterrupt counter
	rte
	
VBlankInterrupt:
	addi.l #$1,vblank_counter		; Increment vinterrupt counter
	rte
	
Exception:
	rte		; return from the Exception
	