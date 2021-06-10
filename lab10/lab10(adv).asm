    ORG 00H
    AJMP INIT
    ORG 0BH        ; 使用TIMER0中斷
    AJMP TIMER0
    ORG 50H
INIT:
    MOV R5,#20     ; 50ms*20次=1s
    MOV DPTR,#TABLE
    SETB ET0       ; 使用TIMER0中斷
    CLR TF0        ; 將TIMER0的OVERFLOW FLAG歸0
    SETB EA
    SETB PT0       ; 將TIMER0的優先度設為HIGH
    MOV TMOD,#1    ; 將TIMER0設為MODE1
    MOV TL0,#176   ; (65536-50000)%256,一次計時50ms
    MOV TH0,#60    ; (65536-50000)/256,一次計時50ms
ROW1:              ; 掃描第一列
    MOV P1,#01111111B
    ACALL DL
    MOV A,P1
    ANL A,#00001111B
    MOV R1,#0
    CJNE A,#00001111B,COL1
ROW2:              ; 掃描第二列
    MOV P1,#10111111B
    ACALL DL
    MOV A,P1
    ANL A, #00001111B
    MOV R1,#1
    CJNE A,#00001111B,COL1
ROW3:              ; 掃描第三列
    MOV P1,#11011111B
    ACALL DL
    MOV A,P1
    ANL A,#00001111B
    MOV R1,#2
    CJNE A,#00001111B,COL1
ROW4:              ; 掃描第四列
    MOV P1,#11101111B
    ACALL DL
    MOV A,P1
    ANL A,#00001111B
    MOV R1,#3
    CJNE A,#00001111B,COL1
    JMP ROW1
COL1:              ; 掃描第一行
    CJNE A,#00001110B, COL2
    MOV R0,#0
    JMP KEYVALUE
COL2:              ; 掃描第二行
    CJNE A,#00001101B, COL3
    MOV R0,#4
    JMP KEYVALUE
COL3:              ; 掃描第三行
    CJNE A,#00001011B, COL4
    MOV R0,#8
    JMP KEYVALUE
COL4:              ; 掃描第四行
    CJNE A,#00000111B,ROW1
    MOV R0,#12
KEYVALUE:          ; 計算鍵值
    MOV A,R0
    ADD A,R1
    MOV R2,A       ; 將鍵值存在R2
MAIN:
    MOV A,R2
    MOVC A,@A+DPTR ; 取得第R2個音的半周期
    SETB TR0       ; 開始計時
    MOV R5,#20
S:
    ACALL SOUND    ; 發出聲音
    CJNE R5,#0,S   ; 當還沒到1s時就重複執行
    CLR TR0        ; 停止計時
    AJMP ROW1      ; 再次掃描鍵盤
SOUND:
    SETB P0.0      ; P0.0設為1
    ACALL DELAY    ; 持續一個半周期
    CLR P0.0       ; P0.0設為0
    ACALL DELAY    ; 持續一個半周期
    RET
DL:
    MOV R6,#5
DL1:
    MOV R7,#5
DL2:
    DJNZ R7,DL2
    DJNZ R6,DL1ㄤ
    RET
DELAY:
    MOV R6,A       ; 1us
DELAY1:
    MOV R7,#6      ; 1us
DELAY2:
    DJNZ R7,DELAY2 ; 2*6=12us
    DJNZ R6,DELAY1 ; 2us
    RET            ; 2us
TIMER0:
    CLR TF0        ; 重設計時器
    MOV TL0,#176
    MOV TH0,#60
    DEC R5         ; R5-1
    RETI
TABLE:             ; ((0.5/Hz*10^6)-1-2)/15
    DB 64          ; Do
    DB 60          ; Do*
    DB 57          ; Re
    DB 54          ; Re*
    DB 51          ; Mi
    DB 48          ; Fa
    DB 45          ; Fa*
    DB 43          ; So
    DB 40          ; So*
    DB 38          ; La
    DB 36          ; La*
    DB 34          ; Si
END