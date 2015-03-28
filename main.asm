#INCLUDE <P16F628A.INC>

#DEFINE BANK0 bcf STATUS, RP0
#DEFINE BANK1 bsf STATUS, RP0

#DEFINE LED   PORTB, 2

count equ 0x20 ;Counter variable
      org 0x000 ; Start program at address 000
      nop ; Required for debugger

START BANK1
    clrf PORTA

    movlw B'00000000'
    movwf TRISB

    BANK0

    bcf T1CON,TMR1ON ; Turn Timer 1 off.
    bsf T1CON,T1CKPS1 ; Set prescaler for divide
    bsf T1CON,T1CKPS0 ; by 8.
    bcf T1CON,T1OSCEN ; Disable the RC oscillator.
    bcf T1CON,TMR1CS ; Use the Fosc/4 source.
    clrf TMR1L ; Start timer at 0000h
    clrf TMR1H ;
    bsf T1CON,TMR1ON ; Start the timer

    clrf count

loop
    call PISCA
    goto $-1

PISCA bsf LED
    call TEMPO
    bcf LED
    call TEMPO
    return

TEMPO btfss PIR1,0 ; Did timer overflow?
    goto $-1 ; Wait if not.

    bsf LED

    bcf PIR1,0
    incf count,F
    bcf T1CON,0
    movlw 80h
    movwf TMR1H
    clrf TMR1L
    bsf T1CON,0
    return

    END


