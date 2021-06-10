    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV DPTR,#TABLE     ;將TABLE的地址傳給DPTR
    MOV R0,#0           ;將R0的初值設為0(個)
    MOV R1,#9           ;將R1的初值設為9(十)
    MOV R2,#9           ;將R2的初值設為9(百)
    MOV R3,#9           ;將R3的初值設為9(千)
COUNT0:     ;個位數計數器
    ACALL DELAY         ;顯示每個數字前先延遲一段時間
	MOV R4,#00FH        ;每個數字顯示16次
    ACALL DISPLAY       ;顯示數字
    INC R0              ;個位數加1
    CJNE R0,#10,COUNT0  ;當個位數不等於10時(不用進位)跳回COUNT0繼續計數
COUNT1:     ;十位數計數器
    MOV R0,#0           ;個位數歸0
    INC R1              ;十位數加1
    CJNE R1,#10,COUNT0  ;當十位數不等於10時(不用進位)跳回COUNT0繼續計數
COUNT2:     ;百位數計數器
    MOV R1,#0           ;十位數歸0          
    INC R2              ;百位數加1
    CJNE R2,#10,COUNT0  ;當百位數不等於10時(不用進位)跳回COUNT0繼續計數
COUNT3:     ;千位數計數器
    MOV R2,#0           ;百位數歸0
    INC R3              ;千位數加1
    CJNE R3,#10,COUNT0  ;當千位數不等於10時(不用進位)跳回COUNT0繼續計數
    MOV R3,#0           ;千位數歸0
    AJMP COUNT0         ;跳回COUNT0繼續計數
DISPLAY:
	ACALL SHOW          ;顯示數字
	DJNZ R4,DISPLAY     ;當R4不為0時重複動作,共16次(第15行將R4設為15)
	RET
SHOW:
    MOV P0,#0FEH        ;顯示個位數
    MOV A,R0            
    MOVC A,@A+DPTR      
    MOV P1,A            ;將R0的數字換成七段顯示器的形式再輸出到P1
	ACALL DELAY         ;暫停,以免顯示太快
    MOV P0,#0FDH        ;顯示十位數
    MOV A,R1
    MOVC A,@A+DPTR
    MOV P1,A            ;將R1的數字換成七段顯示器的形式再輸出到P1
	ACALL DELAY         ;暫停,以免顯示太快
    MOV P0,#0FBH        ;顯示百位數
    MOV A,R2
    MOVC A,@A+DPTR
    MOV P1,A            ;將R2的數字換成七段顯示器的形式再輸出到P1
	ACALL DELAY         ;暫停,以免顯示太快
    MOV P0,#0F7H        ;顯示千位數
    MOV A,R3
    MOVC A,@A+DPTR
    MOV P1,A            ;將R3的數字換成七段顯示器的形式再輸出到P1
	ACALL DELAY         ;暫停,以免顯示太快
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