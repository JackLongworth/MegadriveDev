ReadController1:
	; d0 (w) - Return result
	move.b controller_1_data_port,d0		; Read upper byte from data port
	rol.w #$8,d0		; Move to upper byte of d0
	move.b #$40,controller_1_data_port		; Write bit 7 to data port
	move.b controller_1_data_port,d0		; Read lower byte from data port
	move.b #$00,controller_1_data_port		; Put data port back to normal state
	
	rts