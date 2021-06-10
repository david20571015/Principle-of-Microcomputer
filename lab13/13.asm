    NUM		EQU		R2
    OUTWAVE	EQU		P1.0
    TWOINVE	EQU		R1
    TWOINTE	EQU		R3
    COT50MS	EQU		R0
    OVERFLOW	EQU		R4          ; OVERFLOW
    T2CON	EQU		0C8H
    RCAP2L	EQU		0CAH
    RCAP2H	EQU		0CBH
    TL2		EQU		0CCH
    TH2		EQU		0CDH

    ORG		0000H
    AJMP	INIT
    ORG 	0003H
    AJMP	INTERUPT0
    ORG		000BH
    AJMP 	TIMER0              ; TIMER0的中斷副程式
    ORG		001BH
    AJMP	COUNTER1             ; COUNTER1的中斷副程式
    ORG		0023H
    AJMP	SERIAL
    ORG 	0050H
INIT:
    MOV		NUM,#16

    SETB	EX0                  ; 外部中斷0
    SETB	PX0
    CLR	IT0                   ; INT 0(low level triggered)

    SETB 	ET0                 ; ENABLE TIMER0
    MOV 	TMOD,#01100001B      ; TIMER0(GATE=0 TIMER MODE1)
                              ; COUNTER1(GATE=0 TIMER MODE2)
    MOV 	TH0,#176             ; 設定TIMER0計時50ms
    MOV 	TL0,#60
    CLR 	TF0
    SETB 	TR0
    CLR		PT0

    SETB	ET1                  ; ENABLE COUNTER1
    SETB	PT1
    MOV		A,#255
    CLR		C
    SUBB	A,NUM
    MOV 	TH1,A
    MOV 	TL1,A                ; COUNT1預設計數值為16
    MOV		COT50MS,#10          ; 50ms*10=0.5s=1Hz的半周期
    CLR 	TF1
    SETB 	TR1
    CLR		OUTWAVE
    MOV		OVERFLOW,#0

    MOV		T2CON,#00110100‬B    ; BAUD RATE GENERATOR MODE
    MOV		RCAP2H,#0FFH         ; BAUD RATE = 9600Hz
    MOV		RCAP2L,#0D9H
    MOV		TH2,#0FFH
    MOV		TL2,#0D9H

    SETB	PS
    ORL		PCON,#80H
    CLR		SM0                  ; serial port mode 1
    SETB	SM1
    CLR		SM2
    SETB	REN
    CLR		TI
    CLR		RI
    SETB	ES

    SETB 	EA                  ; ENABLE ALL
    MOV		TWOINVE,#2
    MOV		DPTR,#NUMBER1
MAIN:
    SETB	ET1
    MOV		TH1,NUM
    AJMP	MAIN
INTERUPT0:
    CLR		ET0
    RETI
TIMER0:
    MOV 	TH0,#176             ; 重置TIMER0
    MOV 	TL0,#60
    CLR 	TF0
    DJNZ 	COT50MS,RETURN
    MOV		COT50MS,#10          ; 50ms*10=0.5s
    CPL 	OUTWAVE              ; 每半週期反向一次
    DJNZ	TWOINVE,RETURN
    MOV		TWOINVE,#2

OUTPUT:
    MOV		A,TL1
    ADD		A,NUM

    CLR		C                    ; 回傳COUNTER1的計數次數
    MOV		B,#16
    DIV		AB
    MOVC	A,@A+DPTR
    MOV		SBUF,A
    JNB		TI,$
    CLR 	TI
    MOV		A,B
    MOVC	A,@A+DPTR
    MOV		SBUF,A
    JNB		TI,$
    CLR 	TI

    MOV 	A,#32                ; 空白字元
    MOV		SBUF,A
    JNB		TI,$
    CLR 	TI

    MOV		A,OVERFLOW           ; 回傳OVERFLOW次數
    MOV		B,#16
    DIV		AB
    MOVC	A,@A+DPTR
    MOV		SBUF,A
    JNB		TI,$
    CLR 	TI
    MOV		A,B
    MOVC	A,@A+DPTR
    MOV		SBUF,A
    JNB		TI,$
    CLR 	TI

    MOV 	A,#10                ; 換行字元
    MOV		SBUF,A
    JNB		TI,$
    CLR 	TI
RETURN:
    RETI

COUNTER1:
    INC		OVERFLOW             ; OVERFLOW次數加1
    CLR 	TF1                  ; 重置COUNTER1
    MOV		A,#0
    CLR		C
    SUBB	A,NUM
    MOV 	TH1,A
    MOV 	TL1,A
    RETI

SERIAL:
    JB		TI,TRANS
    JB		RI,RECIV
    AJMP	RETURN1
TRANS:
    CLR		TI
    AJMP	RETURN1
RECIV:
    CLR		RI
    MOV		NUM,SBUF
    MOV		OVERFLOW,#0          ; OVERFLOW歸0
    MOV		A,#255               ; 將接收到的數設為Counter1的計數值
    CLR		C
    SUBB	A,NUM
    MOV 	TH1,A
    MOV 	TL1,A
RETURN1:
    RETI
NUMBER1:                      ; 16進位的字元
    DB '0'
    DB '1'
    DB '2'
    DB '3'
    DB '4'
    DB '5'
    DB '6'
    DB '7'
    DB '8'
    DB '9'
    DB 'A'
    DB 'B'
    DB 'C'
    DB 'D'
    DB 'E'
    DB 'F'
END