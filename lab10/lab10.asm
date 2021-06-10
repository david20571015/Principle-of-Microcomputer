    ORG 00H
    AJMP INIT
    ORG 0BH         ; 使用TIMER0中斷
    AJMP TIMER0
    ORG 50H
INIT:
    MOV DPTR,#TABLE
    SETB ET0        ; 使用TIMER0中斷
    CLR TF0         ; 將TIMER0的OVERFLOW FLAG歸0
    SETB EA
    SETB PT0        ; 將TIMER0的優先度設為HIGH
    MOV TMOD,#1     ; 將TIMER0設為MODE1
    MOV TL0,#176    ; (65536-50000)%256,一次計時50ms
    MOV TH0,#60     ; (65536-50000)/256,一次計時50ms
    SETB TR0
START:
    MOV R4,#0       ; 記錄第幾個音符
    MOV R5,#20      ; 50ms*20次=1s
MAIN:
    MOV A,R4
    MOVC A,@A+DPTR  ; 取得第R4個音的半周期
    ACALL SOUND     ; 發出聲音
    CJNE R4,#7,MAIN ; 7個音還沒展示完就重複執行
    AJMP START      ; 否則跳回START
SOUND:
    SETB P0.0       ; P0.0設為1
    ACALL DELAY     ; 持續一個半周期
    CLR P0.0        ; P0.0設為0
    ACALL DELAY     ; 持續一個半周期
    RET
DELAY:
    MOV R6,A        ; 1us
DELAY1:
    MOV R7,#6       ; 1us
DELAY2:
    DJNZ R7,DELAY2  ; 2*6=12us
    DJNZ R6,DELAY1  ; 2us
    RET             ; 2us
TIMER0:
    CLR TF0         ; 重設計時器
    MOV TL0,#176
    MOV TH0,#60
    DJNZ R5,RETURN
    MOV R5,#20      ; 當還沒到1s時就繼續計時
    INC R4          ; 下一個音
RETURN:
    RETI
TABLE:              ; ((0.5/Hz*10^6)-1-2)/15
    DB 64           ; Do
    DB 57           ; Re
    DB 51           ; Mi
    DB 48           ; Fa
    DB 43           ; So
    DB 38           ; La
    DB 34           ; Si
    END