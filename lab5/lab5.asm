    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV DPTR,#BIG       ;將BIG的地址傳給DPTR
    ACALL DISPLAY       ;跳到DISPLAY
    MOV DPTR,#MIDDLE    ;將MIDDLE的地址傳給DPTR   
    ACALL DISPLAY       ;跳到DISPLAY
    MOV DPTR,#LITTLE    ;將LITTLE得地址傳給DPTR
    ACALL DISPLAY       ;跳到DISPLAY
    AJMP MAIN           ;跳到MAIN以重複顯示
DISPLAY:                
    MOV R6,#50
DISPLAY1:
    MOV R7,#50
DISPLAY2:   
    ACALL SHOW          ;跳到SHOW以在點矩陣上顯示字
    DJNZ R7,DISPLAY2    
    DJNZ R6,DISPLAY1    ;一個字重複顯示2500次
    RET
SHOW:
    MOV R0,#01H         ;R0控制顯示第幾行,初值設為1
    MOV R1,#00H         ;R1控制顯示的燈號,初值設為0
SHOW1:
    MOV P0,R0           ;將R0輸出到P0以控制輸出哪一行
    ACALL DELAY         ;稍微延遲,確保訊號已經傳到單板
    MOV A,R1            
    MOVC A,@A+DPTR      ;將TABLE中對應的燈號傳給A	
    MOV P1,A            ;將燈號輸出到單板
    MOV A,R0            
    RL A                
	MOV R0,A            ;將R0的1向左移一格,以控制下一行
    INC R1              ;將R1加1,已取得下一個TABLE的值
    CJNE R0,#20H,SHOW1  ;重複迴圈直到R0顯示完第五行
    RET
DELAY:
	MOV R5,#255
DELAY1:
	DJNZ R5,DELAY1
	RET
BIG:    ;大
    DB 00100100B
    DB 00010100B
    DB 00001111B
    DB 00010100B
    DB 00100100B	
MIDDLE: ;中
    DB 00011100B
    DB 00010100B
    DB 01111111B
    DB 00010100B
    DB 00011100B
LITTLE: ;小
    DB 00001000B
    DB 00100100B
    DB 01111111B
    DB 00000100B
    DB 00001000B
    END