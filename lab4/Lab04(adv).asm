    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV DPTR,#TABLE     ;將TABLE的地址傳給DPTR
    MOV R0,#6           ;將R0的初值設為6(個)
    MOV R1,#1           ;將R1的初值設為1(十);先將數字都加1,以免DJNZ出問題
COUNT0:     ;個位數倒數
    ACALL DELAY         ;延遲,順便顯示數字(59~0)
    DJNZ R0,COUNT0      ;個位數減1,若不為0則不用借位,跳回COUNT0繼續倒數
    MOV R0,#10          ;若R0為0,則將R0重設為10
COUNT1:     ;十位數倒數
    DJNZ R1,COUNT0	    ;十位數減1,若不為0則不用借位,跳回COUNT0繼續倒數
	ACALL DELAYS        ;若R1為0,則代表倒數完畢,顯示60
    MOV R1,#6	        ;將R1重設為6
    AJMP COUNT0         ;跳回COUNT0繼續倒數
DELAY:      ;重複顯示數字(59~0)
    MOV R5,#007H
DELAY1:
    MOV R6,#007H
DELAY2:
    MOV R7,#005H
DELAY3:
    ACALL SHOW          
    DJNZ R7,DELAY3
    DJNZ R6,DELAY2
    DJNZ R5,DELAY1
    RET
SHOW:       ;顯示59~0
    MOV P0,#0FEH        ;顯示個位數
    MOV A,R0            
    DEC A
    MOVC A,@A+DPTR
    MOV P1,A            ;將R0減1後換成七段顯示器的形式再輸出到P1
	ACALL DELAYD        ;暫停,以免顯示太快
    MOV P0,#0FDH        ;顯示十位數
    MOV A,R1            
    DEC A
    MOVC A,@A+DPTR
    MOV P1,A            ;將R1減1後換成七段顯示器的形式再輸出到P1
	ACALL DELAYD        ;暫停,以免顯示太快
    RET
DELAYS:     ;重複顯示數字(60)
    MOV R5,#007H
DELAYS1:
    MOV R6,#007H
DELAYS2:
    MOV R7,#005H
DELAYS3:
    ACALL SHOWS
    DJNZ R7,DELAYS3
    DJNZ R6,DELAYS2
    DJNZ R5,DELAYS1
    RET
SHOWS:      ;顯示60
	MOV P0,#0FEH        ;顯示個位數
    MOV A,#0
    MOVC A,@A+DPTR
    MOV P1,A            ;將0以七段顯示器的形式輸出到P1
	ACALL DELAYD        ;暫停,以免顯示太快
    MOV P0,#0FDH        ;顯示十位數
    MOV A,#6
    MOVC A,@A+DPTR
    MOV P1,A            ;將6以七段顯示器的形式輸出到P1
	ACALL DELAYD        ;暫停,以免顯示太快
    RET
DELAYD:
    MOV R2,#007H
DELAYD1:
    MOV R3,#007H
DELAYD2:
    MOV R4,#07EH
DELAYD3:
    DJNZ R4,DELAYD3
    DJNZ R3,DELAYD2
    DJNZ R2,DELAYD1
    RET
TABLE:
    DB 0C0H             ;0
    DB 0F9H             ;1
    DB 0A4H             ;2
    DB 0B0H             ;3
    DB 099H             ;4
    DB 092H             ;5
    DB 082H             ;6
    DB 0F8H             ;7
    DB 080H             ;8
    DB 090H             ;9
    END