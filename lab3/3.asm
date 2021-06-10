	ORG 00H
	AJMP MAIN
	ORG 50H
MAIN:
 	MOV DPTR,#TABLE	;將TABLE的地址傳給DPTR
	MOV R2,P1		;將輸入的數字存到R2
	MOV R3,P1		;R3作為要檢測的因數,從R2開始,每次減1
	MOV R4,#0		;R4作為儲存因數和的暫存器
ISPRIME:			
	MOV A,R2		
	MOV B,R3
	DIV AB			;將R2及R3的值分別傳給A和B後相除
	MOV R5,A		;將A的值先存在R5
	MOV R7,B		
	MOV A,R7		;將B的值藉由R7傳到A,以便使用JZ指令
	JZ PLUS			;當A=0,代表B是R2的因數,因此跳到PLUS
TAG:
	DJNZ R3,ISPRIME	;將R3減1,若R3!=0就代表尚未檢測完,跳回ISPRIME
	MOV A,R4		;將R4的值傳給A以進行運算
	SUBB A,R2		
	DEC A			;若R2為質數,R4會等於R2+1
	JZ PRIME		;因此,若A-R2-1=0,就跳PRIME,另外處理
	AJMP SUM 		;若不等於0就直接計算各位數和
PLUS:
	MOV A,R5		;將R5的值再傳回A
	MOV B,#9		;B的值設為9
	DIV AB			;將A除9以取得各個位數和
	ADD A,R4		
	MOV R4,A		;將R4的值加到A,再將A回傳給R4,以更新R4的值
	AJMP TAG		;跳回TAG
PRIME:
	MOV A,R2 		
	MOV R4,A		;藉由A,將R4設為R2的值
SUM:	
	MOV A,R4		
	MOV B,#9
	DIV AB			;將R4的值除9
	MOV R4,B
	MOV A,R4		;將餘數藉由R4傳到A
	MOVC A,@A+DPTR	;將A+DPTR位置的值傳給A
	MOV P0,A		;將A輸出到P0
	AJMP MAIN		;跳回MAIN
TABLE:
   	DB 090H			;9
    DB 0F9H			;1
    DB 0A4H			;2
    DB 0B0H			;3
    DB 099H			;4
    DB 092H			;5
    DB 082H			;6
    DB 0F8H			;7
    DB 080H			;8
	END