DIST	EQU	R0
ONES	EQU	R1
TENS	EQU	R2
HUNDS	EQU	R3
CLOCK	EQU	P1.0
        ORG 0000H
        AJMP INITIAL
        ORG 000BH
        AJMP GEN_CLOCK               ; Timer0中斷
        ORG 0013H
        AJMP GET_DIST                ; 外部INT1中斷
        ORG 0050H
INITIAL:
        MOV DIST,#00H
        SETB EA                      ; enable interrupt
        SETB ET0                     ; enable Timer0
        SETB EX1                     ; enable INT1
        SETB PX1                     ; INT1 priority:high
        CLR PT0                      ; Timer0 priority:low
        SETB IT1                     ; INT1 falling edge trigger
        CLR TF0
        CLR TF1
        CLR CLOCK
        MOV TMOD,#11010010B          ; Counter1:mode1 Timer0:mode2
        MOV TH0,#227                 ; 256-29=227
        MOV TL0,#227                 ; 256-29=227
        MOV TH1,#0
        MOV TL1,#0
        SETB TR0
        SETB TR1
        MOV DPTR,#TABLE
SHOW:
        MOV 	A,HUNDS                 ; 顯示百位數
        MOVC 	A,@A+DPTR
        MOV 	P0,A
        CLR 	P2.1
        ACALL 	DELAY1MS
        SETB 	P2.1

        MOV 	A,TENS                  ; 顯示十位數
        MOVC 	A,@A+DPTR
        MOV 	P0,A
        CLR 	P2.2
        ACALL 	DELAY1MS
        SETB 	P2.2

        MOV 	A,ONES                  ; 顯示個位數
        MOVC 	A,@A+DPTR
        MOV 	P0,A
        CLR 	P2.3
        ACALL 	DELAY1MS
        SETB 	P2.3

        JMP 	SHOW                    ; 重複顯示
GEN_CLOCK:
        CPL	CLOCK                    ; 將P1.0(=P3.3=INT1)反向,若1->0則觸發COUNTER1
        CLR	TF0
        RETI
GET_DIST:
        MOV	DIST,TL1                 ; 從Counter1取得距離(cm)
        MOV	B,#100
        MOV	A,DIST
        DIV	AB
        MOV	HUNDS,A                  ; 距離/100取得百位數
        MOV	A,B
        MOV	B,#10
        DIV	AB
        MOV	TENS,A                   ; 距離/10取得十位數
        MOV	ONES,B                   ; 距離%10取得個位數
        MOV	TL1,#0                   ; 重製Counter1
        MOV	TH1,#0
        CLR	IE1
        CLR	TF1
        RETI
DELAY1MS:
        MOV	R6,#10
DELAY1:
        MOV	R7,#48
        DJNZ R7,$
        DJNZ R6,DELAY1
        RET
TABLE:
        DB 	0C0H,0F9H,0A4H,0B0H,099H ; 0,1,2,3,4
        DB 	092H,082H,0F8H,080H,090H ; 5,6,7,8,9
        END