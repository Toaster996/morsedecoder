TIMER_START EQU 42d
BUTTON EQU P0.0

cseg at 0h
jmp INIT

; Wait for first user input
org 10h
INIT:
 	MOV IE, #10000010b
	JMP BTN_LOOP

 BTN_LOOP:;!pressed
 	clr tr0
 	;if(R1==1){
 	; set R7 for long press}
 	;else for shortpress

 	;Run timer to detect break
 	JNB BUTTON, START_TIMER
 	JMP BTN_LOOP

 PRESSED:
 	JNB BUTTON, pressed
 	JB BUTTON, BTN_LOOP
 

START_TIMER:
	mov TMOD, #00000010b
	mov tl1, #000h ; working #0C0h
	mov th1, #000h ; working #0C0h
	mov tl0, #000h ; working #0C0h
	mov th0, #000h ; working #0C0h
 	setb tr0 ; startet timer
	JMP PRESSED
  

LONG_PRESS_DETECED:
 	mov r1,#1 ;save long press at R1
	clr tr0 ;stop timer
	RET

org 0bh ; adresse v on timer interrupt
call LONG_PRESS_DETECED
reti ; return from interupt