cseg at 0h
jmp INIT

; Wait for first user input
org 0bh ; adresse v on timer interrupt
call LONG_PRESS_DETECED
reti ; return from interupt

org 1bh
call TIME_OVER
reti


INIT:
	TIMER_START EQU 42d
	BUTTON EQU P0.0

; Display init
	MOV A,#30H ; Use 1 line and 5x7 matrix
	ACALL CMND
	MOV A,#0FH ; LCD ON, cursor ON, cursor blinking ON
	ACALL CMND
	MOV A,#01H ; Clear screen
	ACALL CMND
	MOV A,#06H ; shift cursor right
	ACALL CMND
	MOV A,#80H ; postion cursor
	ACALL CMND
; End display init
 	MOV IE, #10001010b ;enables interupt
 	MOV R0, #1h
 	MOV R3, #190d; Error value
 	MOV R5, #0h
 	MOV TMOD, #00000000b
	JMP BTN_LOOP


BTN_LOOP:; !pressed
 	clr tr0

	CJNE R0, #1h, ANALYZE_PREV
 	;Run timer to detect break
 	CJNE R5, #0h, START_WAIT_TIMER
 	JNB BUTTON, START_TIMER
 	JMP BTN_LOOP


PRESSED:
 	MOV R0, #0
 	CLR TR1
 	JNB BUTTON, PRESSED
 	MOV R5, #1h
 	JB BUTTON, BTN_LOOP
 

START_TIMER:
	mov tl1, #0FCh ; working #0C0h
	mov th1, #0FCh ; working #0C0h
	mov tl0, #0FCh ; working #0C0h
	mov th0, #0FCh ; working #0C0h
 	setb tr0 ; startet timer
	JMP PRESSED


START_WAIT_TIMER:
	MOV R5, #0
	mov tl1, #0FCh ; working #0C0h
	mov th1, #0FCh ; working #0C0h
	mov tl0, #0FCh ; working #0C0h
	mov th0, #0FCh ; working #0C0h
 	setb tr1 ; startet timer
	JMP BTN_LOOP
  

LONG_PRESS_DETECED:
 	mov r1,#1 ;save long press at R1
	clr tr0 ;stop timer
	RET


ANALYZE_PREV:
	MOV A, R2
	CJNE R1, #1h, SHORT_PRESS; if (not longpress)
	CJNE R1, #0h, LONG_PRESS;


ANALYZE_PREV2:
	MOV R2, A
	MOV R0, #1
	MOV R1, #0
	MOV R5, #1h

	MOV A, R6
	SETB A.0
	RL A
	JB A.4, TIME_OVER_2
BACK_AGAIN:
	MOV R6, A
	JMP BTN_LOOP

		
LONG_PRESS:
	RL A
	SETB A.0
	RL A
	JMP ANALYZE_PREV2


SHORT_PRESS:
	RL A
	RL A
	SETB A.0
	JMP ANALYZE_PREV2


TIME_OVER_2:
	CLR tr1
	Call ENCODE_BITMASK
	MOV R0, #1h
	MOV R5, #0h
	JMP BACK_AGAIN
	
TIME_OVER:
	CLR tr1
	Call ENCODE_BITMASK
	MOV R0, #1h
	RET

ENCODE_BITMASK:
	MOV A, R2
	CJNE A, #00000110b, ENCODE_BITMASK + 6; A
	MOV R3, #0d
	CJNE A, #10010101b, ENCODE_BITMASK + 11; B
	MOV R3, #1d
	CJNE A, #10011001b, ENCODE_BITMASK + 16; C 
	MOV R3, #2d
	CJNE A, #00100101b, ENCODE_BITMASK + 21; D 
	MOV R3, #3d
	CJNE A, #00000001b, ENCODE_BITMASK + 26; E 
	MOV R3, #4d
	CJNE A, #01011001b, ENCODE_BITMASK + 31; F 
	MOV R3, #5d
	CJNE A, #00101001b, ENCODE_BITMASK + 36; G
	MOV R3, #6d
	CJNE A, #01010101b, ENCODE_BITMASK + 41; H 
	MOV R3, #7d
	CJNE A, #00000101b, ENCODE_BITMASK + 46; I 
	MOV R3, #8d
	CJNE A, #01101010b, ENCODE_BITMASK + 51; J 
	MOV R3, #9d
	CJNE A, #00100110b, ENCODE_BITMASK + 56; K 
	MOV R3, #10d
	CJNE A, #01100101b, ENCODE_BITMASK + 61; L 
	MOV R3, #11d
	CJNE A, #00001010b, ENCODE_BITMASK + 66; M 
	MOV R3, #12d
	CJNE A, #00001001b, ENCODE_BITMASK + 71; N 
	MOV R3, #13d
	CJNE A, #00101010b, ENCODE_BITMASK + 76; O
	MOV R3, #14d
	CJNE A, #01101001b, ENCODE_BITMASK + 81; P 
	MOV R3, #15d
	CJNE A, #10100110b, ENCODE_BITMASK + 86; Q 
	MOV R3, #16d
	CJNE A, #00011001b, ENCODE_BITMASK + 91; R 
	MOV R3, #17d
	CJNE A, #00010101b, ENCODE_BITMASK + 96; S 
	MOV R3, #18d
	CJNE A, #00000010b, ENCODE_BITMASK + 101; T 
	MOV R3, #19d
	CJNE A, #00010110b, ENCODE_BITMASK + 106; U 
	MOV R3, #20d
	CJNE A, #01010110b, ENCODE_BITMASK + 111; V 
	MOV R3, #21d
	CJNE A, #00011010b, ENCODE_BITMASK + 116; W 
	MOV R3, #22d
	CJNE A, #10010110b, ENCODE_BITMASK + 121; X 
	MOV R3, #23d
	CJNE A, #10011010b, ENCODE_BITMASK + 126; Y 
	MOV R3, #24d
	CJNE A, #10100101b, ENCODE_BITMASK + 131; Z 
	MOV R3, #25d
	MOV A, R3
	ADD A, #65d ; A is asci 65
	MOV R4, A ; save value for led display
	MOV R3, #190d; reset r3 to error: 190 + 65 = 255
	CALL DISPLAY_LETTER
	MOV R2, #0h
	MOV R6, #0h
	RET

CMND:
	ACALL READY
	CLR P0.1
	CLR P0.2
	MOV P1, A
	SETB P0.3
	CLR P0.3
	RET

DISPLAY:
	ACALL READY
	MOV P1, A
	SETB P0.1
	CLR P0.2
	SETB P0.3
	CLR P0.3
	RET

READY:
	SETB P1.7
	CLR P0.1
	SETB P0.2
BACK:
	SETB P0.3
	CLR P0.3
	JB P1.7, BACK
	RET
;Set R/W Pin of the LCD HIGH(read from the LCD)
;Select the instruction register by setting RS pin LOW
;Enable the LCD by Setting the enable pin HIGH
; The most significant bit of the LCD data bus is the state of the busy flag(1=Busy,0=ready to accept instructions/data).The other bits hold the current value of the address counter.

DISPLAY_LETTER:
	MOV A, R4
	ACALL DISPLAY
	RET