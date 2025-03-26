INCLUDE Irvine32.inc
INCLUDELIB kernel32.lib

.data
	mainborder BYTE "=============================================================================",10,13,0
	Connect4Game    BYTE " ====================================================",10,13
					BYTE "    _____    _  _         _____                      ",10,13
					BYTE "   / ____|  | || |       / ____|                     ",10,13
					BYTE "  |  |      | || |_ ____| |  __  __ _ _ __ ___   ___ ",10,13
					BYTE "  |  |      |__   _|____| | |_ |/ _` | '_ ` _ \ / _ \",10,13
					BYTE "  |  |____     | |      | |__| | (_| | | | | | |  __/",10,13
					BYTE "   \______|    |_|       \_____|\__,_|_| |_| |_|\___|",10,13
					BYTE "                                                     ",10,13
					BYTE " ====================================================",10,13, 0

	WelcomeFast BYTE "Welcome to: ",0
	FastLogo BYTE   ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",10,13
			BYTE	",,,*???  ???;.+********************************************;  +**********************************.,,",10,13
			BYTE	",,,*???  ???;.;+++++++++++++++++++++++++++++????;;????????; ;????++++++++++++++++++++++++++++++++,,,",10,13
			BYTE	",,,*???  ???;.                              ????;;????????+ ;????;,            ;***  ***;           ",10,13
			BYTE	",,,*???  ???;.                ,:::::, ,;:;:,*???;;???*;????+, +???*;,          ;???  ???+           ",10,13
			BYTE	",,,*???  ???;.;+++++++;     ,:*???+ ,+???+: *???;;???* :*???*;, +???*;,        ;???  ???+           ",10,13
			BYTE	",,,*???  ???;.+???????*    :+???* ,+???+:   *???;;???*   :+???*; :+???*:,      ;???  ???+           ",10,13
			BYTE	",,,*???  ???;..........  :+???* ,+???+:     *???;;???*      +*??*; :+???+:,    ;???  ???+           ",10,13
			BYTE	",,,*???  ???;.*???????*,+???* :+???+,       *???;;???*        ;*???+: *???+:   ;???  ???+           ",10,13
			BYTE	",,,*???  ???;.       ;*???* :+???+,         *???;;???*          ;*???*; *???+  ;???  ???+           ",10,13
			BYTE	",,,*???  ???;.      ;*??? :+???+,           *???;;???*            ;*???* :???? ;???  ???+           ",10,13
			BYTE	",,,*???  ???;.     :???* ;???+,             *???;;???*              *???* :???*+???  ???+           ",10,13
			BYTE	",,,*???  ???;.     +??? ,*???*+;;;;;;;;;;;;;*???+:????;;;;;;;;;;;;;;*???* ,????+???  ???+           ",10,13
			BYTE	",,,*???  ???;.     :???+ ,;++**????????????*;????+;+******************+;:;*???+;???  ???+           ",10,13
			BYTE	",,,*???  ???;.      :+???*++****************,:*?????*****************++*????*;,;???  ???+           ",10,13
			BYTE	",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",10,13, 0

	howtoplay BYTE 10, 13, " How to Play Connect 4:", 10, 13
              BYTE " - Use arrow keys to select a column.", 10, 13
              BYTE " - Press Enter to drop your piece.", 10, 13
              BYTE " - Connect 4 pieces in a row to win!", 10, 13
              BYTE " - Rows, columns, or diagonals count.", 10, 13
              BYTE " Press any key to return...", 0

	; colors
	YELLOW = 14
	CYAN = 11
	RED = 12
	GREEN = 10
	DEFAULT = 0  ; white: 15  black: 0


	; constants
	ROWS = 6
	COLS = 7
	EMPTY = ' '
	PLAYER1 = 'X'
	PLAYER2 = 'O'
	delayTime DWORD 1000

	board DWORD ROWS * COLS DUP(EMPTY)

	; Display board elements
	vline BYTE " | ", 0
	hline BYTE "_", 0
	corner BYTE "+", 0
	space BYTE " ", 0
	marker BYTE "^", 0
	border BYTE " +---+---+---+---+---+---+---+ ", 0
	selectedCol DWORD 0


	; MENU
	welcome BYTE 10,13, "Lets play Connect Four Game!",10,13, 0
	opt1 BYTE "1. Play AI", 0
	opt2 BYTE "2. Two Player", 0
	opt3 BYTE "3. How to play", 0
	opt4 BYTE "4. Exit",0
	selected BYTE "-> ",0
	unselected BYTE "  ", 0


	; Game States
	over BYTE "Game Over!", 0
	draw BYTE "Game Draw!", 0
	wins BYTE "You Win, Hurray!", 0
	loss BYTE "You Loss, Try for the next time :(", 0


	; AI MOVE
	aiThinking BYTE "AI is thinking...",0
	aiMoveMsg BYTE "AI dropped in column", 0 
	aiWinMsg BYTE "AI Wins!", 0
	humanWinMsg BYTE "Congrats! You Win this Time"
	
	; moves check
	currentOption DWORD 0


	
		
	temp1 BYTE "Player vs AI",10,13, "WIll give you $1000 if you win from AI",10,13,0
	temp2 BYTE "Two Player Game",10,13,0
	printing BYTE "Print Option", 0

.code
 ; ==================================================================== MAIN MENU
main PROC
	call ClrScr

		; ============== Displaying FAST logo and welcome
	mov edx, OFFSET welcomeFAST
	call WriteString
	call CrLF
	mov eax, CYAN
	call SetTextColor
	mov edx, OFFSET FastLogo
	call WriteString
	mov ecx, delayTime
	push ecx
	call Sleep


	menuLoop:
		
		call DisplayMenu
		; ================= Getting Inpout
		call GetMenuInput
		cmp eax, 1
		JE optionSelected
		JMP MenuLoop

		optionSelected:
			cmp currentOption, 0
			JE playAI
			cmp currentOption, 1
			JE TwoPlayer
			cmp currentOption, 2
			JE ShowHowtoPlay
			cmp currentOption, 3
			JE ExitGame
			JMP menuLoop

			playAI:
				call Clrscr
				mov edx, OFFSET temp1
				call writeString
				call PlayVsAI
				call WaitMsg
				JMP menuloop
			
			TwoPlayer:
				call Clrscr
				mov edx, OFFSET temp2
				call WriteString
				call PlayerToPlayer
				call WaitMsg
				JMP menuloop

			ShowHowtoPlay:
				call Clrscr
				mov eax, CYAN
				mov eax, setTextColor
				mov edx, OFFSET howtoplay
				call writeString
				mov eax, DEFAULT
				call setTextColor
				call ReadChar                        ; was checking why we need it
				JMP menuloop

			ExitGame:
				invoke exitProcess, 0


main ENDP	


; ============================================================================= PLAYER VS AI PROCEDURE
PlayVsAI PROC
	call InitializedBoard

	AIGameLoop:
		call DisplayBoard
		cmp currentPlayer, Player1
		JE HumanTurn
		JMP AITurn

	HumanTurn:
		call GetPlayerMove                   ; have to make this now
		call DropPiece                        ; have to make this now
		call CheckWin                   ; have to make this now
		cmp eax, 1
		JE HumanWin
		call IsDraw
		cmp eax, 1
		JE GameDraw
		mov currentPlayer, PLAYER2
		JMP AIGameLoop

	AITurn:
		mov edx, OFFSET aiThinking
		call WriteString
		call CrLf

		call AIMOVE               ; THIS INCLUDES LINKING OF MINIMAX
		call DropPiece
		mov edx, OFFSET aiMoveMsg
		call WriteString
		call WriteDec      ; this is for showing col number
		call CrLf

		call CheckWin
		cmp eax, 1
		JE AIWin
		call IsDraw
		cmp eax, 1
		JE GameDraw
		mov currentPlayer, PLAYER1
		JMP AIGameLoop

	HumanWin:
		call DisplayBoard       ; displaying board 
		mov edx, OFFSET humanWinMsg
		call writeString        ; showing winning text
		call CrLf
		JMP EndGame

	AIWin:
		call DisplayBoard       ; displaying board 
		mov edx, OFFSET aiWinMsg
		call writeString        ; showing winning text
		call CrLf
		JMP EndGame

	GameDraw:
		call Displayboard
		mov edx, OFFSET draw
		call WriteString
		call CrLF
		               ; here no need to write JMP ENDGAME because it will directly go there due to beign at the last position

	EndGame:
		call WaitMsg
	
	ret
PlayVsAI  ENDP

; ========================================================================================= AI MOVE
AIMove PROC
	

	ret
AIMove ENDP











; ============================================================================= PLAYER TO PLAYER
PlayerToPlayer PROC

	ret
PlayerToPlayer ENDP


 ; ==================================================================== DISPLAY MENU
DisplayMenu PROC
	call ClrScr



	;============== Displaying the name of game
	call Clrscr
	mov eax, CYAN
	call SetTextColor
	mov edx, OFFSET Connect4Game
	call WriteString
	call CrLf

	;================ Displaying options
	mov eax, DEFAULT
	call SetTextColor
	mov edx, OFFSET welcome
	call WriteString 
	mov ecx, 0          ; loop starts with 0

	;=============== Option loop starts here which will show arrow key going up and down
	optionLoop:
		CMP ecx, currentOption
		JE highlightOption
		mov edx, OFFSET unselected
		call WriteString
		JMP printOption

	highlightOption:
		mov eax, RED
		call SetTextColor
		mov edx, OFFSET selected       ; highlight -> marker
		call writeString

	printOption:
		cmp ecx, 0
		JE printOpt1
		cmp ecx, 1
		JE printOpt2
		cmp ecx, 2
		JE printOpt3
		cmp ecx, 3
		JE printOpt4
		JMP nextOption

	printOpt1: 
		mov edx, OFFSET opt1
		call writeString
		call CrLf
		mov eax, DEFAULT
		call SetTextColor
		JMP nextOption

	printOpt2:
		mov edx, OFFSET opt2
		call writeString
		call CrLf
		mov eax, DEFAULT
		call SetTextColor
		JMP nextOption

	printOpt3:
		mov edx, OFFSET opt3
		call WriteString
		call CrLf
		mov eax, DEFAULT
		call SetTextColor
		JMP nextOption

	printOpt4:
		mov edx, OFFSET opt4
		call WriteString
		call CrLf
		mov eax, DEFAULT
		call SetTextColor
		JMP nextOption

	nextOption:
		inc ecx
		cmp ecx, 4
		JL optionLoop

		ret
DisplayMenu ENDP

 ; ==================================================================== GET MENU INPUT
GetMenuInput PROC
	call ReadChar
	cmp al, 0             ; arrows
	JE checkArrow  

	cmp al, 13             ; enter key
	JE selectOption

	mov eax, 0             ; no action
	ret

	checkArrow:
		cmp ah, 48h        ; up arrow key
		JE moveUp
		cmp ah, 50h        ; down arrow key
		JE moveDown
		mov eax, 0
		ret

		moveUp:
			cmp currentOption, 0 ; if already at first then dont go more up
			JE noChange
			dec currentOption
			mov eax, 0
			ret

		moveDown:
			cmp currentOption, 3   ; if already at last then dont go more down
			JE noChange
			inc currentOption
			mov eax, 0
			ret

		noChange:
			mov eax, 0
			ret

		selectOption:
			mov eax, 1
			ret

GetMenuInput ENDP
	
; ==================================================================== INITIALIZE BOARD
InitializeBoard PROC		
	mov ecx, ROWS * COLS
	mov esi, OFFSET board
	mov eax, EMPTY

	fillLoop:
		mov [esi], eax
		add esi, 4
		loop fillLoop

	mov selectedCol, 0
	ret
InitializeBoard ENDP


; ==================================================================== DISPLAY BOARD
DisplayBoard PROC
	call ClrScr

	mov ecx, ROWS
	mov esi, OFFSET board

	RowLoop:
		push ecx

		;=============== top border of the row
		mov eax, YELLOW
		call SetTextColor
		mov edx, OFFSET border
		call WriteString
		call CrLf
		
		;================ Middle of the row with pieces
			mov eax, DEFAULT
			call SetTextColor
			mov ecx, COLS

		CellLoop:
			mov edx, OFFSET vline    ; print | on every box
			call WriteString

			mov eax, [esi]
			cmp al, PLAYER1
			JE RedX
			cmp al, PLAYER2
			JE GreenO
			JMP PrintEmpty

			RedX:
				mov eax, RED
				call SetTextColor
				mov eax, [esi]
				JMP PrintCell

			GreenO:
				mov eax, GREEN
				call SetTextColor
				mov eax, [esi]
				JMP PrintCell

			
				PrintCell:
					call WriteChar
					mov eax, DEFAULT
					call SetTextColor
					JMP nextCell

			PrintEmpty:
				mov edx, OFFSET space
				call WriteString

			nextCell:
				add esi, 4
				dec ecx
				JNZ CellLoop

			mov edx, OFFSET vline
			call WriteString
			call CrLf

			pop ecx
			dec ecx
			JNZ RowLoop

		; ===========  bottom border
		mov eax, YELLOW 
		call SetTextColor
		mov edx, OFFSET border
		call WriteString
		call CrLf

		;=============== Marker Row
		mov eax, YELLOW
		call SetTextColor
		mov ecx, COLS
		mov ebx, 0

		MarkerLoop:
			cmp ebx, selectedCol
			JE PrintMarker
			mov edx, OFFSET space
			call WriteString
			call WriteString
			inc ebx
			dec ecx
			JNZ MarkerLoop

		PrintMarker: 
			mov eax, RED
			call SetTextColor
			mov edx, OFFSET marker
			call WriteString
			call CrLf
			mov eax, DEFAULT
			call SetTextColor

		mov eax, DEFAULT
		call SetTextColor
		call CrLf
		ret


DisplayBoard ENDP


END main

