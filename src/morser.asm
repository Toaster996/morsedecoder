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

 	MOV IE, #10001010b ;enables interupt
 	MOV R0, #1h
 	MOV R5, #1h
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
	MOV TMOD, #00000010b
	mov tl1, #0C0h ; working #0C0h
	mov th1, #0C0h ; working #0C0h
	mov tl0, #0C0h ; working #0C0h
	mov th0, #0C0h ; working #0C0h
 	setb tr0 ; startet timer
	JMP PRESSED


START_WAIT_TIMER:
	MOV R5, #0
	MOV TMOD, #00000010b
	mov tl1, #0F0h ; working #0C0h
	mov th1, #0F0h ; working #0C0h
	mov tl0, #0F0h ; working #0C0h
	mov th0, #0F0h ; working #0C0h
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
	JB A.4, TIME_OVER
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


TIME_OVER:
	CLR t1
	RL A
	;call Phills stuff
	RET
	
	
