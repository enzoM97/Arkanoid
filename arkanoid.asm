.model small
.data    
arkanoid db 'Arkanoid','$'
arkaX db 3 
arkay db 38

score db 'Score:','$'
initialScore db 0
scoreX db 1
scoreY db 5

speed db 'Speed:','$'
initialSpeed db 1
speedX db 1
speedY db 25

sound db 'Sound:','$'
soundOn db 'on','$'
soundOff db 'off','$'
soundX db 1
soundY db 45

lives db 'Lives:','$'
live db 03,'$'
livesX db 1
livesY db 65

invader dw '%%%%% ','$'
invaderX db 3
invaderY db 1

platform db '********','$'
platformX db 23
platformY db 35

ball db 'o','$'
ballX db 7
ballY db 38

continue dw 'Press any key to start','$'
continueX db 15
continueY db 30

topLimit db 5
bottomLimit db 25
leftLimit db 0
rightLimit db 80

direccion db 1    ; abajo = 0, arriba = 1
dirLateral db 1   ; derecha = 1, izquierda = 0
.code
main proc
    mov AX,@data
    mov DS,AX
     
    call welcome
    call pressKey
    
    call start 
    
    
    mov AH,4CH
    INT 21H
    

;-------------------------------------;
;          Empieza el juego           ;
;-------------------------------------;    
    start:
        call clearScreen
    
        mov ah, 2  ;Move cursor 
        mov bh, 0 
        mov dh, 0
        mov dl, 0  
        int 10h
     
        call printEncabezado
        ;add invaderX, 1          ; mover bloques en grupo
        call printInvaders
        call printBall
        call printPlatform
        call moveBall
        ;jmp start
        
        read:
            mov ah, 00h  ;enter the keyboard
            int 16h
        
        cmp ah, 48h  ;Up Arrow key 
        je start
    
        cmp ah, 50h  ;Down Arrow key 
        je start       
               
        cmp ah, 4Dh  ;Right Arrow key 
        je right
    
        cmp ah, 4Bh  ;Left Arrow key 
        je left
    
        right:
            cmp platformY, 72
            je start
            inc platformY
            jmp start
        
        left:
            cmp platformY, 0
            je start
            sub platformY, 1
            jmp start
        
    ret

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
;          Mueve la pelota            ;
;-------------------------------------;
    moveBall:
        mov bh, ballX
        mov bl, ballY
        
        ;cmp direccion, 1    ; si direccion es hacia arriba
        ;je arriba            ; si esta por debajo de 1, bajar bola
        ;jb abajo
        
        iniciar:
            mov AH,2H           ;angulo inicial
            mov DH, ballX
            mov DL, ballY
            INT 10H
            
            mover:
                cmp direccion, 0     ; compara si la direccion de la bola es hacia abajo
                je moverAbajo
                cmp direccion, 1     ; compara si la direccion de la bola es hacia arriba
                je moverArriba            
            
            controlLimites:            
                cmp ballX, 5         ; compara la posicion actual con el limite superior
                je rebotarAbajo      ; rebota hacia abajo
                
                cmp ballY, 0         ; compara la posicion actual con el limite izquierdo (0)
                je rebotarDerecha    ; rebota hacia la derecha
                
                cmp ballY, 80        ; compara la posicion actual con el limite derecho (80)
                je rebotarIzquierda  ; rebota hacia la izquierda
                
                cmp ballX, 23        ; compara la posicion actual con el limite inferior (la posicion de la plataforma)
                je rebotarArriba     ; rebota hacia arriba
            
            ;sub ballX, 1        ; se mueve hacia arriba inicialmente
            ;sub ballY, 1
            
            
            control:            
                jmp start
            
        rebotarDerecha:
            mov dirLateral, 1        ; actualiza su direccion hacia la derecha
            cmp direccion, 1         ; compara si la bola subia o bajaba
            je rebotarDerechaArriba  ; si subia, rebotar en direccion derecha-arriba
            jne rebotarDerechaAbajo  ; si bajaba, rebotar en direccion derecha-abajo
            
            rebotarDerechaArriba:
                mov direccion, 1     ; acutaliza la direccion de rebote: derecha-arriba
                 
            rebotarDerechaAbajo:
                mov direccion, 0     ; actualiza la direccion de rebote: derecha-abajo
                
         rebotarIzquierda:
            mov dirLateral, 0         ; acutaliza su direccion hacia la izquierda
            cmp direccion, 1          ; compara si la bola subia o bajaba
            je rebotarIzquierdaArriba ; si subia, rebotar en direccion izquierda-arriba
            jne rebotarIzquierdaAbajo ; si bajaba, rebotar en direccion izquierda-abajo
            
            rebotarIzquierdaArriba:
                mov direccion, 1      ; acutaliza la direccion de rebote: izquierda-arriba
                jmp control
                
            rebotarIzquierdaAbajo:
                mov direccion, 0      ; actualiza la direccion de rebote: izquierda-abajo
                jmp control
                
         rebotarAbajo:
            mov direccion, 0           ; actualiza direccion a 0 (hacia abajo)
            cmp dirLateral, 1          ; compara si la bola subia desde la derecha
            je rebotarAbajoIzquierda   ; si subia por la derecha, rebotar hacia abajo y a la izquierda
            cmp dirLateral, 0          ; compara si la bola subia desde la izquierda
            je rebotarAbajoDerecha     ; si subia por la izquierda, rebotar hacia abajo y a la derecha
            
            rebotarAbajoIzquierda:
                mov dirLateral, 0      ; actualiza la direccion de rebote: abajo-izquierda
                jmp control
                
            rebotarAbajoDerecha:
                mov dirLateral, 1      ; actualiza la direccion de rebote: abajo-derecha
                jmp control
                                  
         rebotarArriba:
            mov direccion, 1            ; actualiza direccion a 1 (hacia arriba)
            cmp dirLateral, 1           ; compara si la bola bajaba desde la derecha
            je rebotarArribaIzquierda   ; si bajaba por la derecha, rebotar hacia arriba y a la izquierda
            cmp dirLateral, 0           ; compara si la bola bajaba desde la izquierda
            je rebotarArribaDerecha     ; si bajaba por la izquierda, rebotar hacia arriba y a la derecha
            
            rebotarArribaIzquierda:
                mov dirLateral, 0       ; actualiza la direccion de rebote: arriba-izquierda
                jmp control
                
            rebotarArribaDerecha:       ; actualiza la direccion de rebote: arriba-derecha
                mov dirLateral, 1
                jmp control
                
         moverAbajo:
            cmp dirLateral, 1           ; compara si la bola subía desde la derecha
            je moverAbajoDerecha
            cmp dirLateral, 0           ; compara si la bola subía desde la izquierda
            je moverAbajoIzquierda
            
            moverAbajoDerecha:
                inc ballX               ; actualiza las coordenadas
                inc ballY               ; de la bola
                jmp controlLimites
                
            moverAbajoIzquierda:
                inc ballX               ; actualiza las coordenadas
                sub ballY, 1            ; de la bola
                jmp controlLimites
           
         moverArriba:
            cmp dirLateral, 1           ; compara si la bola bajaba por la derecha
            je moverArribaDerecha
            cmp dirLateral, 0           ; compara si la bola bajaba por la izquierda
            je moverArribaIzquierda
            
            moverArribaDerecha:
                sub ballX, 1            ; actualiza las coordenadas
                inc ballY               ; de la bola
                jmp controlLimites
                
            moverArribaIzquierda:
                sub ballX, 1            ; actualiza las coordenadas
                sub ballY, 1            ; de la bola
                jmp controlLimites    
        ;arriba:
        ;    sub direccion, 1     ; cambia direccion hacia abajo
            
        ;    cmp direccion, 0    ; compara direccion hacia abajo
        ;    jne continuar       ; si no saltar esa instruccion y continuar
        
        ;abajo:
        ;    mov ah, 2h
        ;    mov dh, ballX
        ;    mov dl, ballY
        ;    int 10h
            
        ;    inc ballX
        ;    sub ballY, 1
        ;    cmp ballY, 0       ; compara con el limite izquierdo
        ;    ja start
        
        continuar:        ; continuar juego
        ;SUB BL,1
        ;cmp BL,1         ;?¦¦¦ PERSONAL CHANGE : DETECT WHEN
        ;jz label1        ;     CURSOR REACHES THE TOP ?
        ;loop label2

    ret    
    
;-------------------------------------;
;    Imprime al jugador (la barra)    ;
;-------------------------------------;
    printPlatform:
        mov ah, 2h                    ;
        mov dh, platformX                ; coordenada en x para score
        mov dl, platformY                ; coordenada en y para score
        int 10h                       ;
                                      ;
        mov ah, 9h                    ;
        mov dx, offset platform          ; imprimir string score
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