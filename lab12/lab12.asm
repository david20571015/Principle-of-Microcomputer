    ORG 00H
    JMP MAIN
    ORG 50H
MAIN:
    MOV DPTR,#TABLE
    MOV TMOD,#00100000B ; 設定TIMER1為mode2
    MOV TL1,#0F4H       ; 鮑率設定2400Hz
    MOV TH1,#0F4H
    SETB TR1            ; TIMER1開始計時
    MOV SCON,#01010000B ; 設定serial port為mode1
RECEIVE:
    CLR RI
    JNB RI,$
    MOV A,SBUF          ; 從電腦接收data,並傳給A
    SUBB A,#48          ; 數字字元轉數值(ascii code - 48)
SHOW:
    MOVC A,@A+DPTR      ; 從TABLE取值
    MOV P0,A            ; 顯示在七段顯示器上
    JMP RECEIVE         ; 跳回RECEIVE繼續接收
DELAY:
    MOV R6,#50
DELAY1:
    MOV R7,#10
DELAY2:
    DJNZ R7,DELAY2
    DJNZ R6,DELAY1
    RET
TABLE:
    DB	0C0H,0F9H,0A4H,0B0H,099H
    DB	092H,082H,0F8H,080H,090H
END