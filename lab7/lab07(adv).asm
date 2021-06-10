    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
ROW1:   ;掃描第1列
    MOV P1,#07FH
    ACALL DELAY
    MOV A,P1
    ANL A,#0FH
    MOV R2,#1           ;將R2設為1
    CJNE A,#0FH,COL1
ROW2:   ;掃描第2列
    MOV P1,#0BFH
    ACALL DELAY
    MOV A,P1
    ANL A,#0FH
    MOV R2,#2           ;將R2設為2
    CJNE A,#0FH,COL1
    AJMP ROW1           ;當沒有按鍵被按下時重新掃描
COL1:   ;掃描第1行
    CJNE A,#0EH,COL2
    MOV R3,#1           ;將R3設為1
    AJMP SHOW
COL2:   ;掃描第2行
    CJNE A,#0DH,COL3
    MOV R3,#2           ;將R3設為2
    AJMP SHOW
COL3:   ;掃描第3行
    CJNE A,#0BH,COL4
    MOV R3,#3			;將R3設為3
    AJMP SHOW
COL4:	;掃描第4行
    CJNE A,#07H,ROW1
    MOV R3,#4			;將R3設為4
    AJMP SHOW
SHOW:	
    CJNE R2,#2,CLKWISE	;當R2為1則順時針轉動90度
    AJMP COUNTCLKWISE	;當R2為2則逆時針轉動90度
SHOW1:
    DJNZ R3,SHOW		;重複R3次
    AJMP MAIN
CLKWISE:	;順時針轉動90度
    MOV A,#00010001B
    MOV R0,#0    
CLKWISE1:
    MOV R1,#0
CLKWISE2:
    MOV P0,A            ;將A的值輸出到P0,使馬達轉動
    RL A                ;將A左旋(馬達順時針轉動)
    ACALL DELAY
    INC R1
    CJNE R1,#64,CLKWISE2    
    INC R0
    CJNE R0,#2,CLKWISE1 ;重複128次,馬達順時針轉90度
    AJMP SHOW1
COUNTCLKWISE:	;逆時針轉動90度
    MOV A,#00010001B
    MOV R0,#0
COUNTCLKWISE1:
    MOV R1,#0
COUNTCLKWISE2:
    MOV P0,A            ;將A的值輸出到P0,使馬達轉動
    RR A                ;將A右旋(馬達逆時針轉動)
    ACALL DELAY
    INC R1
    CJNE R1,#64,COUNTCLKWISE2
    INC R0
    CJNE R0,#2,COUNTCLKWISE1;重複128次,馬達逆時針轉90度
    AJMP SHOW1
DELAY:
    MOV R6,#200
DELAY1:
    MOV R7,#200
DELAY2:
    DJNZ R7,DELAY2
    DJNZ R6,DELAY1
    RET
    END