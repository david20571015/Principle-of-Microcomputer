    NUM1 EQU R0
    NUM2 EQU R1
    ANS EQU R2
    INPUT EQU R3
    TIME EQU R4
    OPER EQU R5

    ORG 00H
    AJMP INIT
    ORG 0BH
    AJMP TIMER0
    ORG 23H
    AJMP SERIAL
    ORG 50H
INIT:
    ; 設定Timer
    MOV TMOD,#00100001B      ; 設定Timer0 mode1、Timer1 mode2(鮑率)
    MOV TL0,#176             ; Timer0 50ms
    MOV TH0,#60
    MOV R6,#20               ; 20*50ms=1s
    MOV TL1,#0E6H            ; 鮑率2400Hz
    MOV TH1,#0E6H
    CLR TF0
    CLR TF1
    SETB TR1

    ; 設定serial port mode 1
    ORL PCON,#80H
    CLR SM0
    SETB SM1
    CLR SM2
    SETB REN
    CLR RI
    CLR TI

    ; 設定LCM
    MOV A,#00111011B         ; 採用8位元資料存取、雙列字、5x7點矩陣字型
    ACALL COMMAND
    MOV A,#00001100B         ; 顯示器ON、游標顯示不閃爍
    ACALL COMMAND
    MOV A,#00000001B         ; 清除全螢幕
    ACALL COMMAND
    MOV A,#10000000B         ; 設定DD RAM 位址為0
    ACALL COMMAND

    ; 設定中斷
    MOV IE,#10010010B
    MOV IP,#00010000B

    ; 設定題目初值
    MOV NUM1,#0
    MOV NUM2,#0
    MOV OPER,#0
    MOV ANS,#0
    MOV INPUT,#0

START:
    MOV TIME,#10             ; 每題有10秒回答
    MOV R6,#20

    ; 運算符號依+-*/的順序輪流出現
    INC OPER
    MOV A,OPER
    MOV B,#4
    DIV AB
    MOV OPER,B

    ; 產生題目
    ACALL MAKE_QUE

    SETB TR0                 ; 啟動計時

DISPLAY:
    ACALL SHOW_QUE           ; 顯示題目
    ACALL SHOW_TIME          ; 顯示倒數計時
    CJNE TIME,#0,DISPLAY     ; 時間還沒到就重複顯示

    CLR TR0                  ; 停止計時
    AJMP START

MAKE_QUE:                    ; 產生題目
                             ; 判斷產生哪種題目
    CJNE OPER,#0,NOT_PLUS
    JMP PLUS
NOT_PLUS:
    CJNE OPER,#1,NOT_MINUS
    JMP MINUS
NOT_MINUS:
    CJNE OPER,#2,NOT_MULTIPLE
    JMP MULTIPLE
NOT_MULTIPLE:
    JMP DIVIDE

PLUS:                        ; 加法，NUM1<128，NUM2<128
    MOV A,NUM1
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,#128
    DIV AB
    MOV NUM1,B

    MOV A,NUM2
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,#128
    DIV AB
    MOV NUM2,B

    CLR C
    MOV A,NUM1
    ADD A,NUM2
    MOV ANS,A

    RET

MINUS:                       ; 減法，0<NUM1<256，NUM2<NUM1/
    MOV A,NUM1
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,#255
    DIV AB
    MOV NUM1,B
    CJNE NUM1,#0,MINUS1
    JMP MINUS

MINUS1:
    MOV A,NUM2
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,NUM1
    DIV AB
    MOV NUM2,B

    CLR C
    MOV A,NUM1
    SUBB A,NUM2
    MOV ANS,A

    RET

MULTIPLE:                    ; 乘法，NUM1<16，NUM2<16
    MOV A,NUM1
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,#16
    DIV AB
    MOV NUM1,B

    MOV A,NUM2
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,#16
    DIV AB
    MOV NUM2,B

    CLR C
    MOV A,NUM1
    MOV B,NUM2
    MUL AB
    MOV ANS,A

    RET

DIVIDE:                      ; 除法，0<NUM1<256，0<NUM2<NUM1
    MOV A,NUM1
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,#255
    DIV AB
    MOV NUM1,B
    CJNE NUM1,#0,DIVIDE1
    JMP DIVIDE

DIVIDE1:
    MOV A,NUM2
    MOV B,#7
    MUL AB
    ADD A,#97
    MOV B,NUM1
    DIV AB
    MOV NUM2,B
    CJNE NUM2,#0,DIVIDE2
    JMP DIVIDE1

DIVIDE2:
    CLR C
    MOV A,NUM1
    MOV B,NUM2
    DIV AB
    MOV ANS,A

    RET

SHOW_QUE:                    ; 顯示題目
    MOV A,#00000001B         ; 清除全螢幕
    ACALL COMMAND
    MOV A,#10000000B         ; 設定DD RAM 位址為0
    ACALL COMMAND

    ; 顯示NUM1
    MOV DPTR,#QUE_NUM_TABLE
    MOV A,NUM1
    MOV B,#100
    DIV AB
    MOVC A,@A+DPTR
    ACALL SDATA
    MOV A,B
    MOV B,#10
    DIV AB
    MOVC A,@A+DPTR
    ACALL SDATA
    MOV A,B
    MOVC A,@A+DPTR
    ACALL SDATA

    ; 顯示運算符號
    MOV DPTR,#OPER_TABLE
    MOV A,OPER
    MOVC A,@A+DPTR
    ACALL SDATA

    ; 顯示NUM2
    MOV DPTR,#QUE_NUM_TABLE
    MOV A,NUM2
    MOV B,#100
    DIV AB
    MOVC A,@A+DPTR
    ACALL SDATA
    MOV A,B
    MOV B,#10
    DIV AB
    MOVC A,@A+DPTR
    ACALL SDATA
    MOV A,B
    MOVC A,@A+DPTR
    ACALL SDATA

    ; 顯示=
    MOV A,#3DH
    ACALL SDATA

    RET

QUE_NUM_TABLE:
    DB "0123456789"
OPER_TABLE:
    DB "+-*/"

COMMAND:                     ; 傳送指令給LCD單板
    MOV P1,A
    MOV P2,#00000100B
    CALL DELAY60MS
    MOV P2,#00000000B
    CALL DELAY60MS
    RET
SDATA:                       ; 傳送資料給LCD單板
    MOV P1,A
    MOV P2,#00000101B
    CALL DELAY60MS
    MOV P2,#00000001B
    CALL DELAY60MS
    RET
DELAY60MS:
    MOV R7,#200
    DJNZ R7,$
    RET

TIMER0:                      ; Timer0中斷
    CLR TF0
    MOV TL0,#176
    MOV TH0,#60
    DJNZ R6,RETURN
    MOV R6,#20               ; 20*50ms=1s
    DJNZ TIME,RETURN
    ACALL CHECKANS           ; 如果時間到就直接判斷答案是否正確
RETURN:
    RETI

SHOW_TIME:                   ; 在七段顯示器上顯示秒數
    MOV DPTR,#NUM_TABLE
    MOV A,TIME
    MOVC A,@A+DPTR
    MOV P0,A
    RET
NUM_TABLE:
    DB 0C0H                  ; 0
    DB 0F9H                  ; 1
    DB 0A4H                  ; 2
    DB 0B0H                  ; 3
    DB 099H                  ; 4
    DB 092H                  ; 5
    DB 082H                  ; 6
    DB 0F8H                  ; 7
    DB 080H                  ; 8
    DB 090H                  ; 9

SERIAL:                      ; 串列傳輸中斷
    CLR TR0
    JB TI,RETURN2
    JNB RI,$                 ; 接收資料
    CLR RI
    MOV A,SBUF
    CJNE A,#23H,RECEIVE      ; 若接收到'#'就停止
    ACALL CHECKANS
RETURN2:
    CLR TI
    RETI
RECEIVE:                     ; 依序接收每位數
    CLR C
    SUBB A,#48
    MOV 22H,A
    MOV A,INPUT
    MOV B,#10
    MUL AB
    ADD A,22H
    MOV INPUT,A
    JMP SERIAL

CHECKANS:                    ; 檢查答案是否正確
    CLR TR0
    MOV TIME,#0

    ; 判斷ANS是否等於INPUT,並將結果存到ANS
    CLR C
    MOV A,INPUT
    SUBB A,ANS
    MOV ANS,A
    MOV INPUT,#0

    CJNE ANS,#0,WRONG
    JMP CORRECT
CORRECT:                     ; 正確則回傳'O'
    CLR TI
    MOV A,#4FH
    MOV SBUF,A
    JNB TI,$
    JMP RETURN1
WRONG:                       ; 正確則回傳'X'
    CLR TI
    MOV A,#58H
    MOV SBUF,A
    JNB TI,$
    JMP RETURN1
RETURN1:
    RET
    END