.model small
.data    
arkanoid db 'Arkanoid','$'
arkaX db 3 
arkay db 38

score db 'Score:','$'
initialScore db 0
scoreX db 3
scoreY db 5

speed db 'Speed:','$'
initialSpeed db 1
speedX db 3
speedY db 25

sound db 'Sound:','$'
soundOn db 'on','$'
soundOff db 'off','$'
soundX db 3
soundY db 45

lives db 'Lives:','$'
live db 03,'$'
livesX db 3
livesY db 65

invader dw '%%%%% ','$'
invaderX db 5
invaderY db 1

player db '********','$'
playerX db 23
playerY db 35

ball db 'o','$'
ballX db 22
ballY db 38

continue dw 'Press any key to start','$'
continueX db 1
continueY db 30
.code
main proc
    mov AX,@data
    mov DS,AX
    
    ;call welcome
    ;call pressKey
    ;call clearScreen 
    
    call printEncabezado
    call printInvaders
    call printPlayer
    call printBall
    call pressKey
    call start
    
    ;mov BL,0
    ;label1:
    ;mov AH,2H
    ;mov BH,0            ;goto-XY
    ;mov DH,BL
    ;mov DL,BL
    ;INT 10H

    ;mov AH,9H
    ;mov DX,offset st1      ;print
    ;INT 21H

    ;mov AH, 6H 
    ;mov AL, 0    
    ;mov BH, 7         ;clear screen 
    ;mov CX, 0
    ;mov DL, 79
    ;mov DH, 24
    ;int 10H

    ;ADD BL,1

    ;cmp BL,23         ;?¦¦¦ COMPARE BL, NOT DH, BECAUSE
    ;jz label2         ;     YOU LOST DH WHEN CLEARED SCREEN.
    ;loop label1 

    ;label2:

    ;mov AH,2H           ;?¦¦¦ UNCOMMENT THIS BLOCK !!!
    ;mov BH,0            ;goto-XY
    ;mov DH,BL
    ;mov DL,BL
    ;INT 10H

    ;mov AH,9H
    ;mov DX,offset st1      ;print
    ;INT 21H

    ;mov AH, 6H 
    ;mov AL, 0    
    ;mov BH, 7         ;clear screen 
    ;mov CX, 0
    ;mov DL, 79
    ;mov DH, 24
    ;int 10H

    ;SUB BL,1
    ;cmp BL,1         ;?¦¦¦ PERSONAL CHANGE : DETECT WHEN
    ;jz label1        ;     CURSOR REACHES THE TOP ?
    ;loop label2

    mov AH,4CH
    INT 21H

;-------------------------------------;
;    Imprime el mensaje de empezar    ;
;-------------------------------------;
    pressKey:
        mov ah, 2h
        mov dh, continueX
        mov dl, continueY
        int 10h
        
        mov ah, 9h
        mov dx, offset continue
        int 21h
        
        mov ah, 1h
        int 21h
    ret      
    
;-------------------------------------;
;         Imprime la pelota           ;
;-------------------------------------;
    printBall:
        mov ah, 2h
        mov dh, ballX
        mov dl, ballY
        int 10h
        
        mov ah, 9h
        mov dx, offset ball
        int 21h
    ret
;-------------------------------------;
;    Imprime al jugador (la barra)    ;
;-------------------------------------;
    printPlayer:
        mov ah, 2h                    ;
        mov dh, playerX                ; coordenada en x para score
        mov dl, playerY                ; coordenada en y para score
        int 10h                       ;
                                      ;
        mov ah, 9h                    ;
        mov dx, offset player          ; imprimir string score
        int 21h
    ret

;-------------------------------------;
; Imprime a los invasores del espacio ;
;-------------------------------------;
    printInvaders:
        mov dh, invaderX                    ; 
        mov dl, invaderY
        call printLinea 
        
        mov dh, invaderX
        add dh, 1                    ; 
        mov dl, invaderY
        call printLinea
        
        mov dh, invaderX
        add dh, 2                    ; 
        mov dl, invaderY
        call printLinea
    ret
    
    printLinea:
        mov ah, 2h                        ;                    ; 
        int 10h 
          
        mov cx, 13                         ;
        loop1:                            ; 
            mov ah, 9h                    ;
            mov dx, offset invader           ;
            int 21h                       ;
            loop loop1
    ret
;-------------------------------------;
; Imprime el encabezado del juego     ;
;-------------------------------------;        
    printEncabezado:                  ;
        call printScore               ;
        call printSpeed               ;
        call printSound               ;
        call printLives               ;
                                      ;
    ret                               ;
;-------------------------------------;     

;-------------------------------------;
;    Imprime el score del jugador     ;
;-------------------------------------;
    printScore:                       ;
        mov ah, 2h
        mov dh, scoreX                ; coordenada en x para score
        mov dl, scoreY                ; coordenada en y para score
        int 10h                       ;
                                      ;
        mov ah, 9h                    ;
        mov dx, offset score          ; imprimir string score
        int 21h                       ;
                           ;          ;
        mov ah, 2h                    ;
        mov dh, scoreX                ; aumentar coordenada en y para
        mov dl, scoreY                ; mostrar el valor (valor inicial = 0)
        add dl, 6                     ;
        int 10h                       ;
                                      ;
        mov al, initialScore          ;
        aam                           ;
        mov bx, ax                    ; imprimir valor
        mov ah, 02h                   ; de
        mov dl, bh                    ; initialScore
        add dl, 30h                   ;
        int 21h                       ;
                                      ;
        mov ah, 02h                   ;
        mov dl, bl                    ;
        add dl, 30h                   ;
        int 21h                       ;
    ret                               ;
;-------------------------------------;
       
;-------------------------------------;
; Imprime el label Speed y su valor   ;
;-------------------------------------;
    printSpeed:                       ;
        mov ah, 2h                    ;
        mov dh, speedX                ; coordenada en x para label speed
        mov dl, speedY                ; coordenada en y para label speed
        int 10h                       ;
                                      ;
        mov ah, 9h                    ; imprime el label
        mov dx, offset speed          ; speed
        int 21h                       ;
                                      ;
        mov ah, 2h                    ;
        mov dh, speedX                ; coordenada en x para valor speed
        mov dl, speedY                ; coordenada en y para valor speed
        add dl, 6                     ; se suma 6 chars mas al label para
        int 10h                       ; obtener la coordenada final del valor en y
                                      ;
        mov al, initialSpeed          ;
        aam                           ;
        mov bx, ax                    ;
        mov ah, 02h                   ; imprimir el valor inicial de speed
        mov dl, bh                    ;
        mov dl, 30h                   ;
        int 21h                       ;
                                      ;
        mov ah, 02h                   ;
        mov dl, bl                    ;
        add dl, 30h                   ;
        int 21h                       ;
                                      ;
    ret                               ;
;-------------------------------------;


;-----------------------------------------;
; Imprime el label Sound y on por defecto ;
;-----------------------------------------;
    printSound:                           ;
        mov ah, 2h                        ;
        mov dh, soundX                    ; coordenada en x para sound
        mov dl, soundY                    ; coordenada en y para sound
        int 10h                           ;
                                          ;
        mov ah, 9h                        ;
        mov dx, offset sound              ; imprimir label sound
        int 21h                           ;
                                          ;
        mov ah, 2h                        ;
        mov dh, soundX                    ; coordenada en x para on
        mov dl, soundY                    ; coordenada en y para on
        add dl, 6                         ; se suman 6 chars mas al label para
        int 10h                           ; obtener su valor final
                                          ;
        mov ah, 9h                        ;
        mov dx, offset soundOn            ; imprimir on
        int 21h                           ;
    ret                                   ;
;-----------------------------------------;

;-----------------------------------------;
;   Imprime las vidas del jugagor         ;
;   tres por defecto                      ;
;-----------------------------------------;
    printLives:                           ;
        mov ah, 2h                        ;
        mov dh, livesX                    ; coordenada en x para el primer corazon
        mov dl, livesY                    ; coordenada en y para el primer corazon
        int 10h                           ;
        
        mov ah, 9h
        mov dx, offset lives
        int 21h
                                          ;
        mov cx, 3                         ;
        loopN:                            ; loop que imprime 3 corazones
            mov ah, 9h                    ;
            mov dx, offset live          ;
            int 21h                       ;
            loop loopN                    ;
    ret                                   ;
;-----------------------------------------;
    welcome:
        mov ah, 2h
        mov dh, arkaX
        mov dl, arkaY
        int 10h
        
        mov ah, 9h
        mov dx, offset arkanoid
        int 21h
    ret
    
    clearScreen:
        mov AH, 6H 
        mov AL, 0    
        mov BH, 7         ;clear screen 
        mov CX, 0
        mov DL, 79
        mov DH, 24
        int 10H
    ret
    
end main 