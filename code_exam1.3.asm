#include "p16F628a.inc"    ;incluir librerias relacionadas con el dispositivo
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF    
;configuración del dispositivotodo en OFF y la frecuencia de oscilador
;es la del "reloj del oscilador interno" (INTOSCCLK)     
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
; TODO ADD INTERRUPTS HERE IF USED
MAIN_PROG CODE                      ; let linker place main program
;variables para el contador:
i equ 0x30
j equ 0x31
k equ 0x32
 
m equ 0x33
p equ 0x34
q equ 0x35
;inicio del programa: 
START
    MOVLW 0x07 ;Apagar comparadores
    MOVWF CMCON
    BCF STATUS, RP1 ;Cambiar al banco 1
    BSF STATUS, RP0 
    MOVLW b'11111110' ;Establecer puerto B como salida (los 8 bits del puerto)
    MOVWF TRISB
    BCF STATUS, RP0 ;Regresar al banco 0
    NOP
    
inicio: 
    BSF PORTB,0	    ;Enciende LED
    call Alto
    BSF PORTB,0
    call Bajo
    BCF PORTB,0	    ;Apaga LED
    
Alto: ;483 ms
    movlw d'135'
    movwf i
    movlw d'14'
    movwf j
    movlw d'2'
    movwf k
    call Tiempo
    
Bajo:	;517 ms
    MOVLW d'104'
    MOVWF m
    MOVLW d'160'
    MOVWF p
    MOVLW d'3'
    MOVWF q
    CALL Tiempo2
    
Tiempo: 
    DECFSZ i,f
    GOTO $+2
    DECFSZ j,f
    GOTO $+2
    DECFSZ k,f
    GOTO Tiempo
    GOTO $+1
    BCF PORTB,0
    RETURN
    
Tiempo2:
    DECFSZ m, 1
    GOTO Tiempo2
    DECFSZ p, 1
    GOTO Tiempo2
    DECFSZ q, 1
    GOTO Tiempo2
    NOP 
    BCF PORTB,0
    GOTO inicio

    END