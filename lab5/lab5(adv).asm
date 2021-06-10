    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV R0,#01H         ;R0控制顯示第幾行,初值設為1
    MOV R1,#01H         ;R1控制顯示第幾列,初值設為1
LOOP:
    ACALL DISPLAY       ;跳到DISPLAY
    MOV A,R1            
    RL A
    MOV R1,A            ;將R1的1左移一格
    CJNZ R1,#80H,LOOP   ;當R1的1還沒跑到第七格時就重複迴圈
LOOP1:
    MOV R1,#01H         ;將R1的值重設為1
    MOV A,R0
    RL A
    MOV R0,A            ;將R0的1左移一格
    CJNZ R0,#20H,LOOP   ;當R0的1還沒跑到第五格時就重複迴圈
    MOV R0,#01H         ;將R0的值重設為1
    AJMP LOOP           ;跳回LOOP重複顯示
DISPLAY:
    MOV R6,#200
DISPLAY1:
    MOV R7,#200
DISPLAY2:
    ACALL SHOW          ;跳到SHOW
    DJNZ R7,DISPLAY2
    DJNZ R6,DISPLAY1    ;每個燈顯示40000次
    RET
SHOW:
    MOV P0,R0           ;將R0輸出到P0
    MOV P1,R1           ;將R1輸出到P1
    RET
    END