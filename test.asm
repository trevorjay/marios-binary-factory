;simple ROM that should flash all (non-bs) segments
SBTBL   equ     $0
START   equ     $0DC0

;Indirect Index Table:
org     SBTBL
        .word   $0 ; $100 for TM, SETHIGH

SETHIGH equ     $0
org     $100
R_LOOP  LAX     $F
        EXCI    $0
        T       R_LOOP
        RTN0

org     START
        LB      $2 ; page R
        TM      SETHIGH
        LB      $3 ; page S 
        TM      SETHIGH

; toggle backplane between $0 and $F
        LB      $0
        LAX     $F
        EXC     $0
        LAX     $0
FLASH   ATBP
        TIS
        EXC
        T       FLASH
