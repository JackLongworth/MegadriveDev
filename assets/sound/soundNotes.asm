; first word of each note is the sustain time in vsync frames
; the second word of each note is the square wave counter reset value

chan0_notes:
  dc.w $0010, $02f8, $0010, $02cd, $0010, $02a5, $0010, $01aa, $0008, $0000 ; D3 D#3 E3 C4 .
  dc.w $0010, $02a5, $0010, $01aa, $0008, $0000 ; E3 C4 .
  dc.w $0010, $02a5, $0010, $01aa, $0010, $0000 ; E3 C4 .
  dc.w $0010, $01aa, $0010, $0193, $0010, $017c, $0010, $0152, $0010, $01aa, $0010, $017c, $0010, $0152, $0008, $0000 ; C4 C#4 D4 E4 C4 D4 E4 .
  dc.w $0010, $01c4, $0010, $017c, $0008, $0000 ; B3 D4 .
  dc.w $0010, $01aa ; C4
chan0_notes_end
chan0_notes_len equ chan0_notes_end-chan0_notes
chan0_notes_count equ chan0_notes_len/4