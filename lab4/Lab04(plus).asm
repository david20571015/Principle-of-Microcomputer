	ORG 00H
	AJMP MAIN
	ORG 50H
MAIN:
    MOV DPTR,#TABLE
	MOV A,P0
	CPL A
	ANL A,#11000000B
	MOV R0,A
	XRL A,#01000000B
	JZ SETPW
	MOV A,R0
	XRL A,#10000000B
	JZ INPUTPW
	MOV A,R0
	XRL A,#11000000B
	JZ PWCORRECT
SETPW:
	MOV R1,#0
	MOV R2,#0
	MOV R3,#0
	MOV R4,#0
IN1:
	MOV A,P3
	ANL A,#00001111B
	MOV R4,A
	ACALL SHOW
	MOV A,P0
	CPL A
	ANL A,#00010000B
	JZ IN1
	MOV A,R4
	MOV R3,A
IN2:
	MOV A,P3
	ANL A,#00001111B
	MOV R4,A
	ACALL SHOW
	MOV A,P0
	CPL A
	ANL A,#00010000B
	JZ IN2
	MOV A,R3
	MOV R2,A
	MOV A,R4
	MOV R3,A
IN3:
	MOV A,P3
	ANL A,#00001111B
	MOV R4,A
	ACALL SHOW
	MOV A,P0
	CPL A
	ANL A,#00010000B
	JZ IN3
	MOV A,R2
	MOV R1,A
	MOV A,R3
	MOV R2,A
	MOV A,R4
	MOV R3,A
IN4:
	MOV A,P3
	ANL A,#00001111B
	MOV R4,A
	ACALL SHOW
	MOV A,P0
	CPL A
	ANL A,#00010000B
	JZ IN4

INPUTPW:

PWCORRECT:


SHOW:
    MOV P0,#0FEH
    MOV A,R4
    MOVC A,@A+DPTR
    MOV P1,A
	ACALL DELAY
    MOV P0,#0FDH
    MOV A,R3
    MOVC A,@A+DPTR
    MOV P1,A
	ACALL DELAY
    MOV P0,#0FBH
    MOV A,R2
    MOVC A,@A+DPTR
    MOV P1,A
	ACALL DELAY
    MOV P0,#0F7H
    MOV A,R1
    MOVC A,@A+DPTR
    MOV P1,A
	ACALL DELAY
    RET
DELAY:
    MOV R5,#007H
DELAY1:
    MOV R6,#007H
DELAY2:
    MOV R7,#07EH
DELAY3:
    DJNZ R7,DELAY3
    DJNZ R6,DELAY2
    DJNZ R5,DELAY1
    RET	
TABLE:
    DB 0C0H             ;0
    DB 0F9H             ;1
    DB 0A4H             ;2
    DB 0B0H             ;3
    DB 099H             ;4
    DB 092H             ;5
    DB 082H             ;6
    DB 0F8H             ;7
    DB 080H             ;8
    DB 090H             ;9
	END