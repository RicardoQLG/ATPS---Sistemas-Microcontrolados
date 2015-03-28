#INCLUDE <P16F628A.INC>

#DEFINE BANK0 bcf STATUS, RP0
#DEFINE BANK1 bsf STATUS, RP0

#DEFINE LED   PORTB, 2

count equ 0x20
      org 0x000
      nop

START BANK1
    clrf PORTA
    clrf PORTB

    movlw B'00000000'
    movwf TRISB

    BANK0

    bcf T1CON,TMR1ON
    bsf T1CON,T1CKPS1
    bsf T1CON,T1CKPS0
    bcf T1CON,T1OSCEN
    bcf T1CON,TMR1CS
    clrf TMR1L
    clrf TMR1H
    bsf T1CON,TMR1ON

    clrf count

loop
    call PISCA
    goto $-1

PISCA bsf LED
    call TEMPO
    bcf LED
    call TEMPO
    return

TEMPO btfss PIR1,0
    goto $-1

    bcf PIR1,0
    incf count,F
    bcf T1CON,0
    movlw 80h
    movwf TMR1H
    movlw 0h
    movwf TMR1L
    bsf T1CON,0
    return

    END


