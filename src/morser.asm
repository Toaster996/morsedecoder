TIMER_START EQU 42d
BUTTON EQU P0.0

cseg at 0h
jmp INIT

; Wait for first user input
org 10h
INIT:
	JB BUTTON, INIT
	JMP START_TIMER

MAIN:
	MOV R0, A
	CJNE A, #00010000b, FINISH_CHAR
LOOP_POINT: ;Endless loop. Place refresh logic here
	JNB R0.1, LOOP_POINT
	MOV R0, A
	RL A
	MOV A, R0
	JMP MAIN

FINISH_CHAR:
	MOV A, A

START_TIMER:
	mov tl0, #0c0h ; working #0C0h
	mov th0, #0c0h ; working #0C0h
	setb tr0 ; startet timer
	jmp loop_point

TIMER_INTERRUPT:
	JNB BUTTON, LONG_PRESS
	MOV R0, A
	ORL A, R7
	MOV R7, A
	SETB R0.1
	RET

LONG_PRESS:
	MOV R0, A
	RL A
	ORL A, R7
	ORL A, R7
	MOV R7, A
	SETB R0.1
	RET


org 0bh ; adresse von timer interrupt
call timer_interrupt
reti ; return from interup