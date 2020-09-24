
	;	byte 0: CD1 CD0 A13 A12 A11 A10  A9  A8
	;	byte 1:  A7  A6  A5  A4  A3  A2  A1  A0
	;	byte 2:   0   0   0   0   0   0   0   0
	; 	byte 3: CD5 CD4 CD3 CD2   0   0 A15 A14
	; The bit manipulation below is dealing with formatting into above spec
	; CD = COMMAND BITS, A = ADDRESS BITS
	
SendVDPCommandWithAddress:
	; Input:
	; d0 (w) - Destination to set in VRAM
	; d1 (6 bits) - Command
	
	; Ouput:
	; void - will send data to the vdp control port to set up for the command at the specified address
	; e.g. VRAM write at $B000
	
	movem.l d2-d3,-(sp)		; push d2/d3 onto the stack
	
	clr.l d2
	clr.l d3
	
	move.b d1,d2	; copy the command to d1
	and.b #%000011,d2 	; mask out everything apart from bits 0 - 1
	swap d2		; move to the upper word bits now in position 
	lsl.l #$08,d2	; shift left 30 bits so these bits are in position 30 - 31
	lsl.l #$06,d2
	
	
	clr.l d3		; clear d3
	
	move.w d0,d3	; copy address to d3
	and.w #%0011111111111111,d3		; get the lower 14 bits from the address
	swap d3		; move that the upper word of d3
	or.l d3,d2		; combine that with d2
	
	and.b #%111100,d1		; mask the lower 2 bits of the command
	lsl.b #$04,d1		; shift 4 bits left
	or.l d1,d2		; combine with d2
	
	move.w d0,d3	; copy address to d3
	lsr.w #$08,d3	; shift right 14 places so bits 14 - 15 become places 0 - 1
	lsr.w #$06,d3
	or.b d3,d2		; combine with d2
	
	move.l d2,vdp_control_port		; move the data to the control port
	
	movem.l (sp)+,d2-d3		; pop d2/d3 off the stack
	
	rts