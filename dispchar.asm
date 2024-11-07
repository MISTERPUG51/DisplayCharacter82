;This is the source code for Display Charater 82 by MISTERPUG51
;https://misterpug51.github.io/lnk/dispchar82
;There are very detailed comments for most of the instructions so that beginners can learn from this program.
;This program has no practical use. All it does is allow you do cycle through all 256 characters in the character
;set of the TI-82.

;Also, there is a bug. I've spent a half hour trying to understand why, but I just can't figure it out. For some
;reason, character 214 (hexadecimal D6) always displays one row lower than it should.


#include "CRASH82.INC"

.ORG START_ADDR
TitleStr:
.DB "Display Character 82",0

 ROM_CALL(CLEARLCD)          ;Clears the screen
 LD HL,0                     ;Loads 0 into HL
 LD (CURSOR_POS),HL          ;Sets the cursor position to 0
 LD HL,TitleStr              ;Loads the address of TitleStr into HL
 ROM_CALL(D_ZM_STR)          ;Displays the zero-terminated string at the address in HL (TitleStr) with the menu font

 LD HL,0                     ;Loads 0 into HL
 LD (CURSOR_X),HL            ;Sets CURSOR_X to 0
 LD HL,7                     ;Loads 7 into HL
 LD (CURSOR_Y),HL            ;Sets CURSOR_Y to 7
 LD HL,InstructionStr        ;Loads the address of InstructionStr into HL
 ROM_CALL(D_ZM_STR)          ;Displays the zero-terminated string at the address in HL (InstructionStr) with the menu font
 
 LD HL,0                     ;Loads 0 into HL
 LD (CURSOR_X),HL            ;Sets CURSOR_X to 0
 LD HL,13                    ;Loads 13 into HL
 LD (CURSOR_Y),HL            ;Sets CURSOR_Y to 13
 LD HL,InstructionStr1       ;Loads the address of InstructionStr1 into HL
 ROM_CALL(D_ZM_STR)          ;Displays the zero-terminated string at the address in HL (InstructionStr1) with the menu font

 LD HL,0                     ;Loads 0 into HL
 LD (CURSOR_X),HL            ;Sets CURSOR_X to 0
 LD HL,19                    ;Loads 19 into HL
 LD (CURSOR_Y),HL            ;Sets CURSOR_Y to 19
 LD HL,InstructionStr2       ;Loads the address of InstructionStr2 into HL
 ROM_CALL(D_ZM_STR)          ;Displays the zero-terminated string at the address in HL (InstructionStr2) with the menu font

;Based on the comments for the lines above, you can probably understand what the next few blocks of code do.

 LD HL,0
 LD (CURSOR_X),HL
 LD HL,44
 LD (CURSOR_Y),HL
 LD HL,CPStr
 ROM_CALL(D_ZM_STR)
 
 LD HL,0
 LD (CURSOR_X),HL
 LD HL,50
 LD (CURSOR_Y),HL
 LD HL,CPStr1
 ROM_CALL(D_ZM_STR)
 
 LD HL,0
 LD (CURSOR_X),HL
 LD HL,56
 LD (CURSOR_Y),HL
 LD HL,CPStr2
 ROM_CALL(D_ZM_STR)

 LD B,0                      ;Loads 0 into the B register. This register will be used to store the value of the selected character.
DisplaySelectedCharacter:
 LD HL,4                     ;Loads 4 into HL
 LD (CURSOR_POS),HL          ;Sets CURSOR_POS to 4
 LD A,B                      ;Loads the contents of the B register into the accumulator
 ROM_CALL(TX_CHARPUT)        ;Display the character stored in the accumulator.


 LD HL,$0304                 ;Loads $0304 into HL
 LD (CURSOR_POS),HL          ;Sets CURSOR_POS to $0304
 LD H,0                      ;Loads 0 into H
 LD L,A                      ;Loads the contents of the accumulator into L
 ROM_CALL(D_HL_DECI)         ;Displays the contents of HL as a decimal number


InputLoop:
 CALL GET_KEY                ;Load the currently pressed key into the accumulator (the A register)
 CP G_CLEAR                  ;Set the flags to what they would be if G_CLEAR was subtracted from the accumulator.
 JR Z,QuitProgram            ;If the zero (Z) flag is set, jump to QuitProgram.
 CP G_LEFT                   ;Set the flags to what they would be if G_LEFT was subtracted from the accumulator.
 JR Z,DecreaseB              ;If the zero flag is set, jump to DecreaseB.
 CP G_RIGHT                  ;Set the flags to what they would be if G_RIGHT was subtracted from the accumulator.
 JR Z,IncreaseB              ;If the zero flag is set, jump to IncreaseB.
 JR InputLoop                ;Jump to InputLoop.


DecreaseB:
 DEC B                       ;Decrease the contents of B by 1.
 JR DisplaySelectedCharacter ;Jump to DisplaySelectedCharacter.

IncreaseB:
 INC B                       ;Increase the contents of B by 1.
 JR DisplaySelectedCharacter ;Jump to DisplaySelectedCharacter.


QuitProgram:
 RET                         ;Exits the program

;The following are zero-terminated strings that are used in the program.
InstructionStr:
.DB "Use ",$CF," and ",$05," to cycle through",0
InstructionStr1:
.DB "the character map. Press",0
InstructionStr2:
.DB "CLEAR to exit.",0
CPStr:
.DB "2024 MISTERPUG51",0
CPStr1:
.DB "https://misterpug51.github.",0
CPStr2:
.DB "io/lnk/dispchar82",0


;The assembler doesn't like it if you don't put .END at the end of every asm file.
.END