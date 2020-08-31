; Start of Main RAM to store these counters
hblank_counter equ $00FF0000
vblank_counter equ $00FF0004

; Get a word from the VDP control port to get the VDP status
; 0: Region mode: OFF=NTSC, ON=PAL
; 1: ON during a DMA operation
; 2: ON during horizontal blanking
; 3: ON during vertical blanking 
; 4: ON during odd frame in interlaced mode
; 5: ON whilst two sprites have non-transparent pixels colliding
; 6: ON whilst too many sprites are on a single scanline
; 7: ON during a vertical interrupt
; 8: ON if FIFO is full
; 9: ON if FIFO is empty
; 10 - 15: Unused

WaitVBlankStart:
	move.w vdp_control_port,d0		; Move VDP status word to d0
	andi.w #%00001000,d0		; AND with bit 4 (vblank), result in status register
	bne WaitVBlankStart		; Branch if not equal (to zero) 
	rts
	
WaitVBlankEnd:
	move.w vdp_control_port,d0 		; Move VDP status word to d0
	andi.w #%00001000,d0		; AND with bit 4 (vblank), result in status
	beq WaitVBlankEnd
	rts
	
WaitFrames:
	; d0 - Number of frames to wait
	
	move.l vblank_counter,d1		; Get start vblank count (at this point in time)
	
	.Wait:
	move.l vblank_counter,d2		; Get the vblank count (at this point in time)
	subx.l d1,d2		; Calculate the delta, result stored in d2
	cmp.l d0,d2			; is the delta (frames past) equal to or greater than the number of frames I want to wait
	bge .End			; Branch to end if above condition met
	jmp .Wait		; continue to wait if there number of frames to wait haven't passed yet
	
	.End:
	rts