* I have exclusive control over this submission via my password.
* By including this statement in this header, I certify that
* I have read and understood the University policy in academic
* Integrity and I assert that this work is my own. I have
* not used any unapproved external resources including LLM
* models. Furthermore, I certify that is assignment was
* prepared by me specifically for this course.

*---------------------------------------------------------------
* Name                    : Rohit Dalal
* Student ID Number       : 1258479
* Section Number          : 0214
*---------------------------------------------------------------

            ORG    $8000            

START:      
            MOVE.L  #32,D0           ;task 32 which will open the hardware window
            CLR.B   D1               ;clearing the D1 register
            TRAP    #15              ;system call to setup hardware display
            LEA     HARDWARE,A1      ;pointing to base
            LEA     CONVERT,A2       ;pointing to conversion table     

            MOVE.L  #ISR6,$78         ;placing address of ISR6 into the vector table
            MOVE.L  #ISR7,$7C         ;placing address of ISR7 into the vector table
            MOVE.B  #$3F,HARDWARE     ;displaying 0 as the tens digit of HH
            MOVE.B  #$3F,HARDWARE+2   ;displaying 0 as the units digit of HH
            MOVE.B  #$3F,HARDWARE+6   ;displaying 0 as the tens digit of MM
            MOVE.B  #$3F,HARDWARE+8   ;displaying 0 as the units digit of MM
            MOVE.B  #$3F,HARDWARE+12  ;displaying 0 as the tens digit of SS
            MOVE.B  #$3F,HARDWARE+14  ;displaying 0 as the units digit of SS
            MOVE.B  #$40,HARDWARE+4   ;displaying "-" between HH and MM
            MOVE.B  #$40,HARDWARE+10  ;displaying "-" between MM and SS

* LOOP will keep running in an infinite loop
LOOP:       
            CLR.L   D3               ;clearing D3 for every iteration
            CLR.L   D4               ;clearing D4 for every iteration
            CLR.L   D5               ;clearing D5 for every iteration
            MOVE.B  SS,D3            ;loading the value of seconds in D3
            MOVE.B  MM,D4            ;loading the value of minutes in D4
            MOVE.B  HH,D5            ;loading the value of hours in D5
            DIVU    #10,D3           ;dividing by 10 to get both values for seconds
            DIVU    #10,D4           ;dividing by 10 to get both values for minutes
            DIVU    #10,D5           ;dividing by 10 to get both values for hours
            MOVE.B  D3,D6            ;moving units value of SS into D6
            SWAP    D3               ;swapping to fetch tens value of SS
            MOVE.B  D3,D7            ;moving tens value of SS into D7
            MOVE.B  #14,D2           ;to display the tens value of SS
            MOVE.B  (A2,D7),(A1,D2)  ;moving the tens value of SS to HARDWARE
            MOVE.B  #12,D2           ;to display the units value of SS
            MOVE.B  (A2,D6),(A1,D2)  ;moving the units value of SS to HARDWARE

            MOVE.B  D4,D6            ;moving units value of MM into D6
            SWAP    D4               ;swapping to fetch tens value of MM
            MOVE.B  D4,D7            ;moving tens value of MM into D7
            MOVE.B  #8,D2            ;to display the tens value of MM
            MOVE.B  (A2,D7),(A1,D2)  ;moving the tens value of MM to HARDWARE
            MOVE.B  #6,D2            ;to display the units value of MM
            MOVE.B  (A2,D6),(A1,D2)  ;moving the units value of MM to HARDWARE
            
            MOVE.B  D5,D6            ;moving units value of HH into D6
            SWAP    D5               ;swapping to fetch tens value of HH
            MOVE.B  D5,D7            ;moving tens value of HH into D7
            MOVE.B  #2,D2            ;to display the tens value of HH
            MOVE.B  (A2,D7),(A1,D2)  ;moving the tens value of HH to HARDWARE
            MOVE.B  #0, D2           ;to display the units value of HH
            MOVE.B  (A2,D6),(A1,D2)  ;moving the units value of HH to HARDWARE
  
            BRA     LOOP                  

            SIMHALT                       
            
* ISR for level-6 auto vector interrupt
ISR6:       
            ORI.W   #$0600,SR            ;setting priority level to 6
            SUBI.B  #1,COUNTER           ;decreasing the couter
            MOVE.B  COUNTER,D1           ;loading counter to D1
            JSR     CHANGE               ;jumping to reset subroutine
            RTE                          ;returning from interupt
            
* ISR for level-7 auto vector interrupt
ISR7:       
            ORI     #0700,SR             ;setting priority level to 7
            MOVE.B  #0,HH                ;resetting the hours value to 0
            MOVE.B  #0,MM                ;resetting the minutes value to 0
            MOVE.B  #0,SS                ;resetting the seconds value to 0
            RTE                          ;returning from interupt


CHANGE:    
            CMPI.B  #0,COUNTER           ;checking if value of counter is 0
            BEQ     SECOND               ;we start updating time
            RTS                          ;otherwise we will exit
     
SECOND:     
            ADDI.B  #1,SS                ;incrasing value of SS
            MOVE.B  #60,COUNTER          ;resetting the value of counter
            CMPI.B  #60,SS               ;if value of SS is 60
            BEQ     MINUTE               ;increasing value of MM if value of SS is 60
            RTS                          ;otherwise we will exit

MINUTE:     
            ADDI.B  #1,MM                ;increasing value of MM
            MOVE.B  $0,SS                ;resetting the value of SS to 0
            CMPI.B  #60,MM               ;if value of MM is 60
            BEQ     HOUR                 ;increasing value of HH if value of MM is 60
            RTS                          ;otherwise we will exit

HOUR:     
            ADDI.B  #1,HH               ;increasing value of HH
            MOVE.B  #0,MM               ;resetting the value of MM to 0
            CMPI.B  #24,HH              ;if value of HH is 24
            BEQ     NEWHOUR             ;resetting value of HH if value of HH is 24
            RTS                         ;otherwise we will exit

NEWHOUR:       
            MOVE.B  #0,HH               ;resetting the value of HH to 0
            RTS                         ;otherwise we will exit

COUNTER     DC.B     60                   ;counter value
HH          DC.B     0                    ;variable for hours
MM          DC.B     0                    ;variable for minutes
SS          DC.B     0                    ;variable for seconds
HARDWARE    EQU      $E00000              ;base address of hardware devices
*7-Segment LED patterns for digits 0-9
CONVERT     DC.B    $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$67 

            END    START                   

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
