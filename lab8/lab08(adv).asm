    ORG 00H
    AJMP MAIN
    ORG 50H
    ACALL DELAY                     ; 等待LCD單板的電源供應穩定
MAIN:
    ACALL DELAY
    MOV A,#00111011B                ; 使用8位元資料存取/雙列字/5*7點矩陣
    ACALL COMMAND                   ; 執行指令
    MOV A,#00001100B                ; 顯示器ON/游標OFF/游標閃爍OFF
    ACALL COMMAND                   ; 執行指令
    MOV A,#1                        ; 清除螢幕
    ACALL COMMAND                   ; 執行指令
    ACALL DELAY
    MOV A,#01000000B                ; 指定CG RAM位置為0
    ACALL COMMAND                   ; 執行指令
    MOV DPTR,#MES                   ; DPTR指向#MES以取得要傳送的byte
    MOV R0,#0                       ; R0紀錄將第幾個字寫入CG RAM
LOOP_WRITE:                         ; 將資料寫入CG RAM
    MOV A,R0
    MOVC A,@A+DPTR                  ; 將DPTR指的第R0個byte傳給A
    ACALL SDATA                     ; 傳送資料
    INC R0                          ; R0+1以指向下一個byte
    CJNE R0,#32,LOOP_WRITE          ; 共有4個字元,所以傳送32個bytes
LOOP_SHOW:                          ; 將字元顯示在LCD螢幕上
    MOV R0,#0                       ; R0紀錄顯示第幾個字元
LOOP_SHOW1:
    MOV A,#10000000B                ; 指定DD RAM位置為0
                                    ; 在同一個位置顯示字元,才能呈現動畫效果
    ACALL COMMAND                   ; 執行指令
    MOV A,R0
    ACALL SDATA                     ; 將CG RAM的第R0個字元顯示在螢幕上
    INC R0                          ; R0+1以指向下一個字元
    ACALL DELAY10
    ACALL DELAY10
    CJNE R0,#4,LOOP_SHOW1           ; 共4個字元,若還沒顯示完繼續顯示
    AJMP LOOP_SHOW                  ; 若已經全部顯示完就跳回LOOP_SOHW,重複顯示
COMMAND:                            ; 傳送指令給LCD單板
    MOV P1A
    MOV P0,#00000100B
    ACALL DELAY60
    MOV P0,#00000000B
    ACALL DELAY60
    RET
SDATA:                              ; 傳送資料給LCD單板
    MOV P1,A
    MOV P0,#00000101B
    ACALL DELAY60
    MOV P0,#00000001B
    ACALL DELAY60
    RET
DELAY10:
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    ACALL DELAY
    RET
DELAY:
    MOV R5,#5
DELAY1:
    MOV R6,#50
DELAY2:
    MOV R7,#128
DELAY3:
    DJNZ R7,DELAY3
    DJNZ R6,DELAY2
    DJNZ R5,DELAY1
    RET
DELAY60:
    MOV R5,#200
DELAY601:
    DJNZ R5,DELAY601
    RET
MES:
    ; '/'
    DB 00000001B
    DB 00000001B
    DB 00000010B
    DB 00000100B
    DB 00001000B
    DB 00010000B
    DB 00010000B
    DB 00000000B
    ; '|'
    DB 00000100B
    DB 00000100B
    DB 00000100B
    DB 00000100B
    DB 00000100B
    DB 00000100B
    DB 00000100B
    DB 00000000B
    ; '\'
    DB 00010000B
    DB 00010000B
    DB 00001000B
    DB 00000100B
    DB 00000010B
    DB 00000001B
    DB 00000001B
    DB 00000000B
    ; '-'
    DB 00000000B
    DB 00000000B
    DB 00000000B
    DB 00011111B
    DB 00000000B
    DB 00000000B
    DB 00000000B
    DB 00000000B
    END