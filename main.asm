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

loop
    bsf LED
    goto $-1

    END


