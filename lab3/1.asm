    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV DPTR,#TABLE     ;將TABLE的地址傳給DPTR
LOOP:
    MOV R2,#0           ;將R2的初值設為0
LOOP1:
    MOV A,R2            ;將R2的值傳給A
    MOVC A,@A+DPTR      ;將A+DPTR位置的值傳給A
    MOV P0,A            ;將A的值輸出到P0
    INC R2              ;R2的值加1
    ACALL DELAY         
    CJNE R2,#10,LOOP1   ;如果R2的值不等於10就跳到LOOP1
    AJMP LOOP           ;跳到LOOP
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