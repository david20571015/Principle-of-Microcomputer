    ORG 0000H
    JMP MAIN
    ORG 0050H
MAIN:
    MOV TMOD,#00100000B ; 設定TIMER1為mode2
    MOV TL1,#0F4H       ; 鮑率設定2400Hz
    MOV TH1,#0F4H
    SETB TR1            ; TIMER1開始計時
    MOV SCON,#01010000B ; 設定serial port為mode1
RECEIVE:
    CLR RI
    JNB RI,$
    MOV A,SBUF          ; 從電腦接收data,並傳給A
    ADD A,#32           ; 大寫轉小寫(ascii code + 32)
TRANSMIT:
    CLR TI
    MOV SBUF,A
    JNB TI,$            ; 將data回傳給電腦
    JMP RECEIVE
END