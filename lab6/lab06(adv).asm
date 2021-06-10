    ORG 00H
    AJMP MAIN
    ORG 50H
MAIN:
    MOV R0,#0
LOOP1:
    MOV P1,#0FEH    ;P1依序掃描每列
    MOV R1,#0       ;R1紀錄掃到哪一列
NEXT:
    ACALL SHOW      ;每次掃描開始前先顯示數字
    MOV A,P3        ;將鍵盤每行被按下的情況傳給A
    ANL A,#0FH      ;將A較大的4個bit設為0
    CJNE A,#0FH,SCAN;當有按鍵被按下就跳到SCAN
    MOV A,P1        
    RL A
    MOV P1,A        ;當沒有按鍵被按下則將P1左移
    INC R1          ;紀錄的列數加1
    CJNE R1,#5,NEXT ;還沒掃描完時跳回NEXT繼續掃描
    AJMP LOOP1      ;掃描完時跳到LOOP1重新掃描
SCAN:
    ACALL DELAY     
    MOV A,P3
    ANL A,#0FH
    CJNE A,#0FH,SCAN1;延遲後再讀取P3的值,確定按鍵有被按下
    AJMP LOOP1      ;否則跳回LOOP1重新掃描
SCAN1:
    MOV DPTR,#IDXCOL
    MOVC A,@A+DPTR  ;當多個按鍵被按下時,只取最右邊的按鍵值
    MOV B,A         ;將行數存到B
    MOV A,R1        ;將列數存到A
    CLR C
    RLC A
    CLR C
    RLC A
    ADD A,B         ;A*4+B,算出鍵值
    MOV R0,A        ;將鍵值存到R0以便輸出
LOOP2:
    ACALL SHOW      ;顯示數字
    MOV A,P3        
    ANL A,#0FH
    CJNE A,#0FH,LOOP2;當沒有按鍵被按下時跳出迴圈
    ACALL DELAY
    MOV A,P3
    ANL A,#0FH
    CJNE A,#0FH,LOOP2;再次確定沒有按鍵被按下
    AJMP LOOP1      ;跳到LOOP1重新掃描鍵盤
IDXCOL:
    DB 0,1,0,2,0,1,0,3,0,1,0,2,0,1,0
DELAY:
    MOV R6,#50
DELAY1:
    MOV R7,#50
DELAY2:
    DJNZ R7,DELAY2
    DJNZ R6,DELAY1
    RET
SHOW:
    MOV DPTR,#TABLE 
    MOV A,R0        ;將鍵值傳給A
    MOV B,#10       
    DIV AB          
    MOV R2,A        ;R2=A的十位數
    MOV A,B         
    CJNE R2,#1,SHOW1;當R2為0時只顯示個位數
    MOV P2,#0DH     ;直接給值顯示十位數的1
    MOV P0,#0F9H
    ACALL DELAY
SHOW1:              
    MOV P2,#0EH     ;顯示A的個位數
    MOVC A,@A+DPTR
    MOV P0,A
    ACALL DELAY   
    RET
TABLE:
    DB 0C0H
    DB 0F9H
    DB 0A4H
    DB 0B0H
    DB 099H
    DB 092H
    DB 082H
    DB 0F8H
    DB 080H
    DB 090H
    END