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
	DEFAULT = 15  ; white: 15  black: 0


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
	marker BYTE "  ^  ",0
	border BYTE " +---+---+---+---+---+---+---+ ", 0
	spacesPerCol DWORD 5
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
	
	; Player messages
	player1Msg BYTE "Player 1's turn (X)", 0
	player2Msg BYTE "Player 2's turn (O)", 0
	player1WinMsg BYTE "Player 1 (X) Wins!", 0
	player2WinMsg BYTE "Player 2 (O) Wins!", 0


	; AI MOVE
	aiThinking BYTE "AI is thinking...",0
	aiMoveMsg BYTE "AI dropped in column", 0 
	aiWinMsg BYTE "AI Wins!", 0
	humanWinMsg BYTE "Congrats! You Win this Time"
	
	; moves check
	currentOption DWORD 0
	currentPlayer DWORD PLAYER1

	;adding for now(will sort later)
	invalidMoveMsg BYTE "Invalid move! Column is full.", 0
	lastRow DWORD ?
	lastCol DWORD ?

		
	temp1 BYTE "Player vs AI",10,13, "WIll give you $1000 if you win from AI",10,13,0
	temp2 BYTE "Two Player Game",10,13,0
	printing BYTE "Print Option", 0

.code

GetPlayerMove PROC
    pushad                   ; Save all registers
    
	InputLoop:
		; Check for key press with minimal delay
		mov eax, 10             ; Tiny 10ms delay so no input lag when switching columns
		call Delay
		call ReadKey
		jz InputLoop            ; No key pressed

		cmp al, 13              ; Enter
		je ConfirmMove
		cmp ah, 4Bh             ; Left arrow
		je MoveLeft
		cmp ah, 4Dh             ; Right arrow
		je MoveRight
		jmp InputLoop           ; Ignore other keys

	MoveLeft:
		cmp selectedCol, 0		; if at left edge
		jle InputLoop           ; ignore and take input again
		dec selectedCol			; col-1
		jmp UpdateDisplay		; update board

	MoveRight:
		cmp selectedCol, COLS-1 ; if at right most edge
		jge InputLoop           ; ignore and take input again
		inc selectedCol			; col+1

	UpdateDisplay:
		call DisplayBoard       ; Immediate updation of board :)
		jmp InputLoop

	ConfirmMove:
		mov esi, OFFSET board	; esi holding address of board
		mov eax, selectedCol	; THE COL SELECTED NUMBER MOVED TO EAX
		imul eax, TYPE board    ; col * 4
		add esi, eax            ; ESI now points to the top of that selected column

		cmp DWORD PTR [esi], EMPTY ; making sure that the top of the selected column is empty 
		je ValidMove            ; top of the column is empty so jmp

		; Column full - show invald move error
		call Crlf
		mov eax, RED
		call SetTextColor
		mov edx, OFFSET invalidMoveMsg  ; whole thing is for if top of the col has piece on it and we try to still press enter so 
		call WriteString				; it wil give an error of invalid move in red color and will go back to inputloop for valid prompt 
		mov eax, DEFAULT
		call SetTextColor
		call Crlf
		jmp InputLoop

	ValidMove:
		mov eax, selectedCol    ; as top col was empty so its a valid column to place our piece hence we store it in eax register
		popad                   ; Restore registers
		ret
GetPlayerMove ENDP

DropPiece PROC
    pushad
    
		mov edi, OFFSET board
		mov eax, selectedCol    ; Column number (0-6)
		mov ebx, ROWS           ; 6 rows
		dec ebx                 ; Start at bottom row (5)
    
	FindEmptySpot:
		;  Convert (row, column) to byte offset: row * COLS + selectedcol, then multiply by 4 (bytes per cell).
		mov ecx, ebx            ; Current row
		imul ecx, COLS          ; row * 7
		add ecx, eax            ; + column
		mov esi, ecx
		imul esi, TYPE board    ; 4 bytes per cell
    

		cmp DWORD PTR [edi + esi], EMPTY ; Check if cell is empty
		je PlacePiece
    
		
		dec ebx					; Move up one row
		jns FindEmptySpot       ; Contine while row >=0 (jmp if not Signed ) 

		;Should never get here (GetPlayerMove Func already checked)
		popad
		ret
    
	PlacePiece:
		
		mov edx, currentPlayer	; Place player's symbol
		mov [edi + esi], edx	
    
		; Storing just so we can use it in CheckWin acc to the position
		mov lastRow, ebx        ; Row where the piece was placed
		mov lastCol, eax        ; Selected column
    
		popad
		ret
DropPiece ENDP


CheckWin PROC
    pushad
    
		mov esi, OFFSET board
		mov eax, lastRow       ; 
		mov ebx, lastCol       ; loc of last piece placed
    
		; row * COLS + col * 4 = formula to get index of any piece placed
		imul eax, COLS
		add eax, ebx
		imul eax, 4
		add esi, eax           ; ESI points to placed piece
    
		mov edi, currentPlayer ; symbol (can be O or X)
		mov ecx, 3             ; 3 matches excluding piece itself
    
    ; ---- Check Horizontal (Left-Right) ----

		mov edx, esi           ; Start from placed piece
		mov ebx, ecx           ; Reset counter
	Horizontal:
		sub edx, 4             ; Move left
		cmp edx, OFFSET board  ; Boundary check (shoudnt go off the border from left thats why only board)
		jl HorizontalDone	   ; jmp if less than
		cmp [edx], edi		   ; Match Check 
		jne HorizontalDone	   ; jmp if not equal
		dec ebx				   ; else decrement counter
		jz WinFound			   ; jmp if 0
		jmp Horizontal			

	HorizontalDone:
		mov edx, esi           ; Reset to placed piece
		mov ebx, ecx           ; Reset counter
	HorizontalRight:
		add edx, 4								; Move right
		cmp edx, OFFSET board +	 (ROWS*COLS*4) ; Boundary check (from the right hand side thats why the addition with (R*C*4) to get index (in bytes))
		jge Vertical				; jmp if greater/equals to
		cmp [edx], edi				; Match check
		jne Vertical				; jmp if not equal
		dec ebx						; else decrement counter
		jz WinFound					; jmp if 0
		jmp HorizontalRight
    
    ; ---- Check Vertical (Up) ----

	Vertical:
		mov edx, esi				; Reset to placed piece
		mov ebx, ecx				; Reset counter
	VerticalUp:
		sub edx, COLS*4				; Move up (row-1)
		cmp edx, OFFSET board		; Boundary check (shoudnt go off the border from left thats why only board)
		jl Diagonal1				; jmp if less than
		cmp [edx], edi				; Match Check 
		jne Diagonal1				; jmp if not equal
		dec ebx						; else decrement counter
		jz WinFound					; jmp if 0
		jmp VerticalUp
    
    ; ---- Check Diagonal \ (UpLeft-DownRight) ----

	Diagonal1:
		mov edx, esi				; Reset to placed piece
		mov ebx, ecx				; Reset counter
	Diagonal1Up:
		sub edx, (COLS+1)*4			; Up-left
		cmp edx, OFFSET board		; Boundary check (shoudnt go off the border from left thats why only board)
		jl Diagonal1DownCheck		; jmp if less than
		cmp [edx], edi				; Match Check 
		jne Diagonal1DownCheck		; jmp if not equal
		dec ebx						; else decrement counter
		jz WinFound					; jmp if 0
		jmp Diagonal1Up

	Diagonal1DownCheck:
		mov edx, esi
		mov ebx, ecx
	Diagonal1Down:
		add edx, (COLS+1)*4					  ; Down-right
		cmp edx, OFFSET board + (ROWS*COLS*4) ; Boundary check (from the right hand side)
		jge Diagonal2						  ; jmp if greater/equals to
		cmp [edx], edi						  ; Match check
		jne Diagonal2						  ; jmp if not equal
		dec ebx								  ; else decrement counter
		jz WinFound							  ; jmp if 0
		jmp Diagonal1Down
    
    ; ---- Check Diagonal / (UpRight-DownLeft) ----

	Diagonal2:
		mov edx, esi			; Reset to placed piece
		mov ebx, ecx			; Reset counter
	Diagonal2Up:
		sub edx, (COLS-1)*4     ; Up-right
		cmp edx, OFFSET board	; Boundary check (shoudnt go off the border from left thats why only board)
		jl Diagonal2DownCheck	; jmp if less than
		cmp [edx], edi			; Match Check 
		jne Diagonal2DownCheck	; jmp if not equal
		dec ebx					; else decrement counter
		jz WinFound				; jmp if 0
		jmp Diagonal2Up

	Diagonal2DownCheck:
		mov edx, esi
		mov ebx, ecx
	Diagonal2Down:
		add edx, (COLS-1)*4						; Down-left
		cmp edx, OFFSET board + (ROWS*COLS*4)	; Boundary check (from the right hand side)
		jge NoWin								; jmp if greater/equals to
		cmp [edx], edi							; Match check
		jne NoWin								; jmp if not equal
		dec ebx									; else decrement counter
		jz WinFound								; jmp if 0
		jmp Diagonal2Down						


	NoWin:
		popad
		xor eax, eax           ; Return 0 (no win)
		ret

	WinFound:
		popad
		mov eax, 1             ; Return 1 (win)
		ret

CheckWin ENDP


IsDraw PROC
    push esi                 ; Save registers used
    push ecx
    mov esi, OFFSET board    ; Start of the board
    mov ecx, ROWS * COLS     ; Total cells to check

CheckLoop:
    cmp DWORD PTR [esi], EMPTY ; Check if current cell is empty
    je NotDraw                ; If empty, game is still going on
    add esi, 4               ; Move to next cell (4 bytes per DWORD)
    loop CheckLoop            ; Repeat until all cells checked

    ; if every place is filled then its a draw
    pop ecx                  ; Restore original ecx
    pop esi                  ; Restore original esi
    mov eax, 1               ; Return 1 (draw)
    ret

NotDraw:
    pop ecx                  ; Restore original ecx
    pop esi                  ; Restore original esi
    mov eax, 0               ; Return 0 (not draw)
    ret
IsDraw ENDP


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
	call InitializeBoard

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

; ============================================================================= AI MOVE
AIMove PROC
	

	ret
AIMove ENDP


; ============================================================================= PLAYER TO PLAYER
PlayerToPlayer PROC
    call InitializeBoard
    mov currentPlayer, PLAYER1
    
    GameLoop:
        call DisplayBoard
        
        cmp currentPlayer, PLAYER1
        je Player1Turn
        mov edx, OFFSET player2Msg
        jmp ShowTurn
    Player1Turn:
        mov edx, OFFSET player1Msg
    ShowTurn:
        call WriteString
        
        call GetPlayerMove
        call DropPiece
        
        call CheckWin
        cmp eax, 1
        je GameOver
        
        call IsDraw
        cmp eax, 1
        je GameTied
        
        cmp currentPlayer, PLAYER1
        je SetPlayer2
        mov currentPlayer, PLAYER1
        jmp GameLoop
    SetPlayer2:
        mov currentPlayer, PLAYER2
        jmp GameLoop
        
    GameOver:
        call DisplayBoard
        cmp currentPlayer, PLAYER1
        je Player1Wins
        mov edx, OFFSET player2WinMsg
        jmp ShowResult
    Player1Wins:
        mov edx, OFFSET player1WinMsg
    ShowResult:
        call WriteString
        ret
        
    GameTied:
        call DisplayBoard
        mov edx, OFFSET draw
        call WriteString
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

		mov eax, selectedCol
		mov ebx, 4
		mul ebx                 ; column * 4 (each column is 4 chars wide in display)
		add eax, 1              ; +1 to centre
		mov ecx, eax

		; Draw leading spaces
		DrawSpaces:
			mov edx, OFFSET space
			call WriteString
			loop DrawSpaces

		PrintMarker: 
			mov eax, RED
			call SetTextColor
			mov edx, OFFSET marker
			call WriteString
			call CrLf
			mov eax, DEFAULT
			call SetTextColor
		ret

DisplayBoard ENDP


END main
