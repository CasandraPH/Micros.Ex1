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
    MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
    MOVWF TRISB
    BCF STATUS, RP0 ;Regresar al banco 0
    NOP
    
inicio: 
    BSF PORTB, 0
    BTFSS PORTB,1   ;salta si esta encendido
    ;BTFSC PORTB,1   ;salta si esta apagado
    ;call on1
    call on2	;Push botton apagado
    call on1	;Push botton encendido
    goto inicio  ;regresar y repetir
    
on1:
    BSF PORTB,0	;enciendo RB0
    movlw d'12'
    movwf i
    movlw d'70'
    movwf j
    movlw d'4'
    movwf k
    call Tiempo
    
on2:    
    BSF PORTB,0	;enciendo RB0
    MOVLW d'168'
    MOVWF m
    MOVLW d'69'
    MOVWF p
    MOVLW d'2'
    MOVWF q
    CALL Tiempo2
    
;rutinas de tiempo
Tiempo: 
    decfsz	i, f
    goto	$+2
    decfsz	j, f
    goto	$+2
    decfsz	k, f
    goto	Tiempo
    goto	$+1
    nop	;1.5 s
    BCF PORTB,0	;apago RB0
    goto inicio
    ;return
    
Tiempo2:
    DECFSZ m, 1
    GOTO Tiempo2
    DECFSZ p, 1
    GOTO Tiempo2
    DECFSZ q, 1
    GOTO Tiempo2
    NOP ;250 ms
    BCF PORTB,0	;apago RB0
    goto inicio
    ;RETURN

    END