controller_1_control_port equ $00A10009
controller_1_data_port equ $00A10003

controller_2_control_port equ $00A1000B
controller_2_data_port equ $000A10005

exp_port equ $000A1000D

;*****************************************************************
; The controller input has a Up, Down, Left, Right, A, B, C, Start
; In the format: 00SA0000 00CBRLDU

controller_button_up equ $0
controller_button_down equ $1
controller_button_left equ $2
controller_button_right equ $3
controller_button_a equ $C
controller_button_b equ $4
controller_button_c equ $5
controller_button_Start equ $D