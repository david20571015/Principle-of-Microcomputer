	ORG 00H
	AJMP MAIN		
	ORG 50H
MAIN:
	MOV A,#0FEH	
SWITCH:
	MOV R2,P0		
	CJNE R2,#0H,ON	
	AJMP OFF		
ON:
	MOV P1,A		
	ACALL DELAY	
	MOV P1,#0FFH	
	ACALL DELAY	
	AJMP SWITCH	
OFF:
	RL A			
	MOV P1,A		
	ACALL DELAY	
	AJMP SWITCH	
DELAY:
	MOV R5,#0FFH	
DELAY1:
	MOV R6,#0FFH	
DELAY2:
	MOV R7,#005H 	
DELAY3:
	DJNZ R7,DELAY3
	DJNZ R6,DELAY2
	DJNZ R5,DELAY1
	RET				
	END
