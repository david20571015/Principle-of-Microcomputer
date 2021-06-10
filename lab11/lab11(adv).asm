DIST	EQU	R0
POINT	EQU     R4
ONES	EQU	R1
TENS	EQU	R2
HUNDS	EQU	R3
CLOCK	EQU	P1.0
        ORG 0000H
        AJMP　INITIAL
        ORG　000BH
        AJMP　GEN_CLOCK               ; Timer0中斷
        ORG　0013H
        AJMP　GET_DIST                ; 外部INT1中斷
        ORG　0050H
INITIAL:
        MOV　DIST,#00H
        SETB EA                      ; enable interrupt
        SETB ET0                     ; enable Timer0
        SETB EX1                     ; enable INT1
        SETB PX1                     ; INT1 priority:high
        CLR PT0                      ; Timer0 priority:low
        SETB IT1                     ; INT1 falling edge trigger
        CLR　TF0
        CLR　TF1
        CLR　CLOCK
        MOV　TMOD,#11010010B          ; Counter1:mode1 Timer0:mode2
        MOV　TH0,#253                 ; 256-3=253
        MOV　TL0,#253                 ; 256-3=253
        MOV　TH1,#0
        MOV　TL1,#0
        SETB TR0
        SETB TR1
        MOV DPTR,#TABLE
SHOW:
        MOV 	A,HUNDS                 ; 顯示百位數
        MOVC 	A,@A+DPTR
        MOV 	P0,A
        CLR 	P2.0
        ACALL 	DELAY1MS
        SETB 	P2.0

        MOV 	A,TENS                  ; 顯示十位數
        MOVC 	A,@A+DPTR
        MOV 	P0,A
        CLR 	P2.1
        ACALL 	DELAY1MS
        SETB 	P2.1

        MOV 	A,ONES                  ; 顯示個位數
        MOVC 	A,@A+DPTR
        ANL 	A,#01111111B            ; 顯示小數點
        MOV 	P0,A
        CLR 	P2.2
        ACALL 	DELAY1MS
        SETB 	P2.2

        MOV 	A,POINT                 ; 顯示小數點後一位數
        MOVC 	A,@A+DPTR
        MOV 	P0,A
        CLR 	P2.3
        ACALL 	DELAY1MS
        SETB 	P2.3

        JMP 	SHOW                    ; 重複顯示
GEN_CLOCK:
        CPL	CLOCK                    ; 將P1.0(=P3.3=INT1)反向,若1->0則觸發INT1
        CLR	TF0
        RETI
GET_DIST:                            ; 計算距離(mm)
        MOV     HUNDS,#0             ; TL1最多只能存25.6(cm),因此將百位數歸0
        MOV	B,#100
        MOV	A,TL1
        DIV	AB
        MOV	TENS,A                   ; 距離/100取得十位數
        MOV	A,B
        MOV	B,#10
        DIV	AB
        MOV	ONES,A                   ; 距離/10取得個位數
        MOV	POINT,B                  ; 距離%10取得小數點後一位數
        MOV	TL1,#0
        MOV	R5,TH1
LONG_DIST:                           ; 總距離=TH1*256+TL1
        MOV A,#2
        ADD A,TENS
        MOV TENS,A

        MOV A,#5
        ADD A,ONES
        MOV ONES,A

        MOV A,#6
        ADD A,POINT
        MOV POINT,A
        DJNZ R5,LONG_DIST            ; 將前面算出的距離重複+256(共TH1次)
        MOV TH1,#0

        MOV B,#10
        MOV A,POINT
        DIV AB
        MOV POINT,B
        ADD A,ONES
        MOV ONES,A

        MOV B,#10
        MOV A,ONES
        DIV AB
        MOV ONES,B
        ADD A,TENS
        MOV TENS,A

        MOV B,#10
        MOV A,TENS
        DIV AB
        MOV TENS,B
        ADD A,HUNDS
        MOV HUNDS,A                  ; 處理每個位數的進位

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