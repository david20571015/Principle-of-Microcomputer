    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    JB P3.2,START1      ; 當水銀開關導通時跳至START1
    JMP MAIN            ; 否則跳回MAIN重新檢查
    MOV DPTR,#TABLE
START1:
    JNB P3.2,START2     ; 當水銀開關未導通時跳至START2
    JMP MAIN            ; 否則跳回MAIN重新檢查
START2:
    ACALL LED_SHOW      ; 在搖搖棒顯示文字
    JMP MAIN            ; 跳回MAIN重複執行
LED_SHOW:
    MOV R1,#24          ; 字的寬度為24列的data
    MOV R0,#72          ; R0每次傳8bit的data,但全部有24*24筆data
                        ; 所以要傳24*24/8=72次

NEXT_COLUMN:
    CALL READ_BYTE      ; 取得data
    MOV P0,A            ; 傳給P0(上面8個LED)
    CALL READ_BYTE      ; 取得data
    MOV P2,A            ; 傳給P2(中間8個LED)
    CALL READ_BYTE      ; 取得data
    MOV P1,A            ; 傳給P1(下面8個LED)
    CALL DELAY          ; 暫停,以免顯示太快
    DJNZ R1,NEXT_COLUMN ; 共有24個column的data要傳
    RET
READ_BYTE:
    DEC R0              ; 先將R0減1以讀取下一筆資料
    MOV A,R0
    MOVC A,@A+DPTR      ; 取得的資料存在A
    CPL A               ; 反轉A,輸出0則LED亮,輸出1則LED不亮
    RET
DELAY:
    MOV R5,#1
DELAY1:
    MOV R6,#255
DELAY2:
    MOV R7,#50
DELAY3:
    DJNZ R7,DELAY3
    DJNZ R6,DELAY2
    DJNZ R5,DELAY1
    RET
TABLE:
    DB 00000000B,00000000B,00000000B
    DB 00000000B,00000000B,00000000B
    DB 00000000B,00000000B,00000000B
    DB 00000000B,01111111B,10000000B
    DB 00000001B,11111111B,10000000B
    DB 00000000B,11000001B,10000000B
    DB 00000000B,01000001B,10000000B
    DB 00000111B,11111111B,11111110B
    DB 11111111B,11111111B,11111110B
    DB 11111111B,11111111B,11111110B
    DB 00000000B,00000011B,00000000B
    DB 00000000B,01111111B,00000000B
    DB 00000000B,11111111B,00000000B
    DB 00000000B,00000000B,00000000B
    DB 00000010B,11110001B,11000000B
    DB 00000011B,11110111B,11000000B
    DB 00000011B,00110110B,11001100B
    DB 00000011B,00101100B,11111100B
    DB 00000011B,00101100B,11111000B
    DB 00000111B,11111111B,11000000B
    DB 00000111B,11111111B,11000000B
    DB 00000000B,00000000B,00000000B
    DB 00000000B,00000000B,00000000B
    DB 00000000B,00000000B,00000000B
END