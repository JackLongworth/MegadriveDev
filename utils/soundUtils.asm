	include assets\sound\soundNotes.asm

SoundTest:
	; move.b #%10001110,psg_control_port ; Latch ON, channel 0, counter data type, lower 4 bits of data
	; move.b #%00001111,psg_control_port ; Latch OFF, upper 6 bits of data
	
	; 2nd byte + 1st byte
	; 001111   + 1110     = 11111110 = FE = 254
	; clock freq / (2 * 16 * register value)
	;  3579545 / (2 x 16 x 254) = 440 hertz
	
	move.b #%10010000,psg_control_port ; Latch ON, channel 0, attenuation value, 4 bits of data
	
	lea chan0_notes,a0		; load the address of the song into a0
	move.l #chan0_notes_count,d1		; move the number of notes into d0
	subi.l #$1,d1		; subtract 1 for the counter
	
.NextNote:
	
	; get the lowest 4 bits of the counter reset value and then package that and send it to the PSG  {
	
	move.w (a0)+,d0		; load the second word of the note into d2 (counter reset value)
	move.w (a0)+,d2		; move the sustain value to d0
	
	move.b d2,d3	; move the lower byte of d2 to d3
	and.b #%00001111,d3		; clear the upper nibble of d3 (leaves lowest nibble in d3)
	or.b #%10000000,d3		; Latch ON (bit 7), chan 0, (6-5), tone data OFF (bit 4)
	move.b d3,psg_control_port		; 
	
	; }
	
	move.w d2,d3		; move the whole word to d3
	ror.w #$4,d3		; shift right 4 bits 
	and.b #%00111111,d3		; then just take the lower 6 bits of data (remaining from the tone data)
	; Already in the right format for writing (Latch OFF)
	move.b d3,psg_control_port		; Write to the PSG port
	
	move.l d1,-(sp)		; Backup counter
	jsr WaitFrames		; Wait for the sustain period
	move.l (sp)+,d1		; Restore the counter
	
	dbra d1,.NextNote	; Branch back to play the next Note
	
	move.b #%10011111,psg_control_port		; Finished - silence channel 0
	
	rts