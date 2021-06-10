    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV A,#00010001B    ;將A的初值設為00010001
    MOV R0,#0           ;R0及R1為計數器,初值設為0
CLKWISE:
    MOV R1,#0
CLKWISE1:
    MOV P0,A            ;將A的值輸出到P0,使馬達轉動
    RL A                ;將A左旋(馬達順時針轉動)
    ACALL DELAY
    INC R1              
    CJNE R1,#64,CLKWISE1
    INC R0
    CJNE R0,#1,CLKWISE  ;重複64次,馬達順時針轉45度
    MOV R0,#0           ;將R0及R1歸0
COUNTCLKWISE:
    MOV R1,#0           
COUNTCLKWISE1:
    MOV P0,A            ;將A的值輸出到P0,使馬達轉動
    RR A                ;將A右旋(馬達逆時針轉動)
    ACALL DELAY
    INC R1
    CJNE R1,#64,COUNTCLKWISE1
    INC R0
    CJNE R0,#2,COUNTCLKWISE;重複128次,馬達逆時針轉90度
DELAY:
    MOV R6,#200
DELAY1:
    MOV R7,#200
DELAY2:
    DJNZ R7,DELAY2
    DJNZ R6,DELAY1
    RET
    END