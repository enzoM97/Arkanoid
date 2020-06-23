.model small
.stack 128
.data

score db 'Score:',10,13,'$'
initialScore db 0
scoreX db 1
scoreY db 2

speed db 'Speed:','$'
initialSpeed db 1
speedX db 1
speedY db 13

sound db 'Sound:','$'
soundOn db 'on','$'
soundOff db 'off','$'
soundX db 1
soundY db 24

lives db 03,'$'
livesX db 1
livesY db 35

;dimensiones de los bloques
largo dw 35
ancho dw 10

; coordenadas iniciales del primer bloque
x dw 20
y dw 25

;variables para bucles
i dw 0
j dw 0

; colores
azul db 1
verde db 2
rojo db 4
amarillo db 14
cyan db 3   

; contador para bucles
cont dw 0

.code
.startup
main proc
    
    mov ax, @data        ; Cargar al data segment 
    mov ds, ax           ; las variables
    
   mov ax, @data        ; Cargar al data segment 
    mov ds, ax           ; las variables
    
    mov ah, 0
    mov al, 13h          ; Inicializar modo grafico
    int 10h              ;
        
    mov cx, 0000h        ; Coordenadas iniciales
    mov dx, 0000h        ;

    
    call printHeader     ; imprime el encabezado del juego
    
    call printInvaders   ; imprime los invasores
    
    
    ; finalizar el programa
    mov ax, 4c00h
    int 21h

;-------------------------------------;    
;       RUTINAS Y SUBRUTINAS          ;
;-------------------------------------;

;-------------------------------------;
;  Imprime los invasores del espacio  ;    
;-------------------------------------;
    printInvaders:
        mov cont, 000h
        mov cx, x                     ; columna inicial para el primer bloque
        mov dx, y                     ; fila inicial para el primer bloque
        mov ah, 0ch                   ; poner pixel
        mov al, rojo                  ; color de bloques
        call printLinea               ; imprime linea de bloques
        
        mov cx, x
        mov y, 40
        mov dx, y
        mov ah, 0ch
        mov al, verde                 ; color de bloques
        call printLinea               ; imprime linea de bloques  
        
        mov cx, x
        mov y, 55
        mov dx, y
        mov ah, 0ch
        mov al, cyan
        call printLinea
    ret
        
    printLinea:
        add ancho, dx
                   
        call printBloque
                                      
        mov ancho, 10
    ret    
  ; imprime un bloque 
    printBloque:                      ; ubica el pixel en la posicion inicial x
        mov cx, x                      
        inicio:
        mov bx, 000h                  ; iterador
        colcount:
            inc cx                    ; pixel a imprimir
            int 10h
            inc bx
            cmp bx, largo             ; mientras el iterador sea 
            jb colcount               ; menor al largo del bloque imprimir primera fila
            
        mov cx, x                     ; posicion inicial x para nueva fila
        inc dx                        ; siguiente fila
        cmp dx, ancho                 ; mientras y sea menor al ancho del bloque
        jb inicio                     ; seguir imprimiendo
        
        add cx, largo                 ; nueva posicion para siguiente
        add cx, 5                     ; bloque posicion inicial += largo + 5 <--(espacio entre cada bloque) 
        mov x, cx                     ; nueva posicion inicial en x
        mov dx, y                     ; misma posicion en y
        
        inc cont                      ; contador para especificar
        cmp cont, 007h                ; cuantos bloques imprimir
        jb printBloque 
        mov x, 20
        mov cont, 000h      
    ret
;-------------------------------------;
    
;-------------------------------------;
; Imprime el encabezado del juego     ;
;-------------------------------------;        
    printHeader:                      ;
                                      ;
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
        mov ah, 2h                    ;
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
                                          ;
        mov cx, 3                         ;
        loop1:                            ; loop que imprime 3 corazones
            mov ah, 9h                    ;
            mov dx, offset lives          ;
            int 21h                       ;
            loop loop1                    ;
    ret                                   ;
;-----------------------------------------;
       
main endp
end
