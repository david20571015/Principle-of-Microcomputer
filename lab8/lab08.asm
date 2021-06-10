    ORG 00H
    AJMP MAIN
    ORG 50H
    ACALL DELAY      ; 等待LCD單板的電源供應穩定
MAIN:
    ACALL DELAY
    MOV A,#00111011B ; 使用8位元資料存取/雙列字/5*7點矩陣
    ACALL COMMAND    ; 執行指令
    MOV A,#00001100B ; 顯示器ON/游標OFF/游標閃爍OFF
    ACALL COMMAND    ; 執行指令
    MOV A,#1         ; 清除螢幕
    ACALL COMMAND    ; 執行指令
    ACALL DELAY
    MOV A,#10000000B ; 指定DD RAM位置為0
    ACALL COMMAND    ; 執行指令
    MOV DPTR,#MES    ; DPTR指向#MES以取得要顯示的字元
LOOP:
    CLR A
    MOVC A,@A+DPTR   ; 將DPTR指向的字元傳給A
    JZ ENDMES        ; 當DPTR指向0時,跳到ENDMES
    ACALL SDATA      ; 否則跳到SDATA傳資料給LCD單板
    INC DPTR         ; DPTR指向下一個字元
    SJMP LOOP        ; 跳回LOOP重複執行
ENDMES:
    AJMP MAIN        ; 當字元全部顯示完畢,跳回MAIN重新執行
COMMAND:             ; 傳送指令給LCD單板
    MOV P1,A
    MOV P0,#00000100B
    ACALL DELAY60
    MOV P0,#00000000B
    ACALL DELAY60
    RET
SDATA:               ; 傳送資料給LCD單板
    MOV P1,A
    MOV P0,#00000101B
    ACALL DELAY60
    MOV P0,#00000001B
    ACALL DELAY60
    RET
DELAY:
    MOV R5,#5
DELAY1:
    MOV R6,#50
DELAY2:
    MOV R7,#128
DELAY3:
    DJNZ R7,DELAY3
    DJNZ R6,DELAY2
    DJNZ R5,DELAY1
    RET
DELAY60:
    MOV R5,#200
DELAY601:
    DJNZ R5,DELAY601
    RET
MES:
    DB "0710734",0
    END