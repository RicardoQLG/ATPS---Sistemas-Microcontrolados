#INCLUDE <P16F628A.INC>

#DEFINE BANK0 bcf STATUS, RP0
#DEFINE BANK1 bsf STATUS, RP0

#DEFINE LED   PORTB, 2

CBLOCK 0x20
  tmrflagsa
  tmrflagsb
  tmrflagsc
ENDC

    org 0

    clrf PORTA
    clrf PORTB


    BANK1
    movlw B'00000000'
    movwf TRISB

    BANK0


MAIN
    bsf LED
    CALL t0_reset
    CALL t0_set250
    CALL t0_wait
    bcf LED
    CALL t0_reset
    CALL t0_set250
    CALL t0_wait

    GOTO MAIN

t0_wait
  btfss tmrflagsa, 0
  goto $-1
  return

t0_set250
  movlw 0x06 ; approx 0.25ms to overflow
  movwf TMR0
  bcf tmrflagsa, 0
  return

t0_reset
  clrf TMR0
  bcf tmrflagsa, 0
  return

wait_150ms
    movlw 0x03
    movwf tmrflagsc
    call wait_50ms_while
    return

wait_500ms
    movlw 0x10
    movwf tmrflagsc
    call wait_50ms_while
    return

wait_50ms_while
    call wait_50ms
    movlw 0x01
    SUBWF tmrflagsc, 1
    btfss tmrflagsc, 0
    goto $-1
    return

wait_50ms
    movlw 0xC8
    movwf tmrflagsb
    call wait_250us
    return


wait_250us
    CALL t0_reset
    CALL t0_set250
    CALL t0_wait
    movlw 0x01
    SUBWF tmrflagsb, 0x01
    btfss tmrflagsb, 0
    goto $-1
    return
END


