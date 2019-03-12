Title AHORCADO

stacksg segment para STACK 'stack'
	DB 100h DUP(0)
	CR EQU 13
	LF EQU 10
stacksg ends

datasg segment
	PALABRA DB 64H DUP (0) ;SE DECLARA LA VARIABLE "PALABRA" DE TAMAÑO 100 (64H)
	guess DB 64H DUP(0)

	archivo db "archivo.txt", 0 ;ascii del nombre del archivo
	leido db 100 DUP("$");
	handle dw ? ;identificador del arhivo

	line DB '_.$'
	cuerda DB '|',CR,LF,'$'
	head DB 'O',CR,LF,'$'
	rh DB '\',CR,LF,'$'
	lh DB '/',CR,LF,'$'
	rfoot DB '/',CR,LF,'$'
	lfoot DB '\',CR,LF,'$'
	msgLoser DB 'PERDISTE!! $'
	msgWinner DB 'ADIVINASTE!! $'

datasg ends

codesg segment
	assume cs:codesg, ds:datasg, ss:stacksg
	main proc far
		prologo:
			;push ds
			xor ax,ax
			;push ax
			mov ax,datasg
			mov ds,ax

			LEA SI,PALABRA ; SE CARGA LA VARIBALE "PALABRA" EN 'SI'
			
			;----------------------------------------------------------

			mov al, 0h ;modo de acceso para abrir arhivo, modo lectura/escritura
 			mov dx, offset archivo ;offset lugar de memoria donde esta la variable
			mov ah, 3dh ;se intenta abrir el archivo
	 		int 21h ;llamada a la interrupcion DOS
			mov handle, ax ;si no paso mover a lo que le dio el SO

			mov bx, handle
 			mov cx, 79h ;<---- cantidad de caracteres que lee del archivo
 			mov dx, offset leido ;<--- pasa al dx lo que hay en el archhivo
 			mov ah, 3fh
 			int 21h
 
 			;cerramos archivo
 			mov bx, handle
 			mov ah, 3eh
 			int 21h

			;------------------------------------------------------------

			;CALL clean
			;mov dx,0200h
			;call ubica
			
			mov cx,0
			push cx
			;mov dx,0fffh
			;push dx

		ubicaPalabra:
			CALL clean
			mov dx,0200h
			call ubica

			;call vaciaPila
			pop cx

			LEA DI,leido
			ADD DI,cx
			LEA SI,PALABRA

		INICIO:
			inc cx

			mov al,[DI]

			CMP AL,0DH ;SE COMPARA CON ENTER
			JE finPalabra ;SI ES IGUAL SALTA A 'FINPALABRA'

			CMP AL,'$' ;SE COMPARA CON final del archivo
			JE finPalabra ;SI ES IGUAL salta a la ùltima palabra

			cmp al,20h
			je ESPACIO
			

			MOV [SI],AL ;SE MUEVE 'AL' A LA PRIMERA POSISION DE 'SI'
			INC SI ;SE INCREMENTA 'SI'
			inc di

			call dibEsp

			JMP INICIO ;SE REGRESA A INCIO HASTA QUE SE PRESIONE ENTER

			;SI SE PRECIONA UN ESPACIO SOLO SE INCREMENTE EL VALOR DE 'SI'
			ESPACIO:
				mov ah, 02h
				mov dx, 32 
				int 21h 
				INC SI
				inc di
				JMP INICIO


		finPalabra:


			mov ah, 02h
			mov dx, 10 
			int 21h 

			;SINO ESTA VACIA
		
			
			inc cx
			push cx			;se guarda el desplazamiento de la cadena total		
		
			;mov dx,0fffh
			;push dx	

			mov cx,si
			INC SI ;SE INCREMENTA 'SI'
			MOV AL,'$' ;SE ASIGNA EL CARACTER DEL FIN DE LA CADENA A 'AL'
			MOV [SI],AL ;SE CARGA EN 'SI'
			
			call dibCuerda
			mov bx,0


		ahorcado:
			cmp bl,6
			je loser

			call findAll		;checar si aùn hay letras por descubrir
			cmp bh,0
			je winner 

			push bx
			call leeChar
			
			call checkWord

			cmp bx,0
			je error

			pop bx
	
			jmp ahorcado

			
		error:
			pop bx
			inc bl
			call impMono
			jmp ahorcado	

		loser:
			mov dx,0F0Fh
			call ubica
			mov dx,OFFSET msgLoser
			mov ax,SEG msgLoser
			mov ds,ax
			lea dx,msgLoser
			mov ah,9
			int 21h
			call continuar

			mov al,[DI]
			cmp al,'$'
			

			je return 
			jmp ubicaPalabra

		winner:
			mov dx,0F0Fh
			call ubica
			mov dx,OFFSET msgWinner
			mov ax,SEG msgWinner
			mov ds,ax
			lea dx,msgWinner
			mov ah,9
			int 21h
			
			call continuar

			mov al,[DI]
			cmp al,'$'
			
			

			je return
			jmp ubicaPalabra

		return:
			mov ah,4ch
			int 21h

			
	main endp
		
	continuar PROC
		mov ah,08h
		int 21h
		ret
	continuar ENDP

	posAct PROC
		mov ah,03h
		xor bh,bh
		int 10h
		pop cx
		push dx
		ret
	posAct ENDP

	checkWord PROC
		mov si,0
		mov bx,0
		pal:
			cmp si,cx
			je fin

			cmp al,PALABRA[SI]
			je acierto
			
			inc si
			jmp pal	

		acierto:
			call imprimeAcierto
			mov PALABRA[SI],0h
			mov bx,1
			inc si
			jmp pal

		fin:
			ret
	checkWord ENDP


	findAll PROC
		mov bh,0
		mov si,0
		recorre:
			cmp si,cx
			je finito
			add bh,PALABRA[SI]
			cmp bh,0
			jne finito
			inc si
			jmp recorre
	
		finito:			
			ret
	findAll ENDP	

	imprimeAcierto PROC
	
		mov dx,si
		add dl,dl
		mov dh,2
		
		call ubica
			
		MOV AH,02H
		mov dl,PALABRA[SI]
		INT 21H

		ret
	imprimeAcierto ENDP



	leeChar PROC
		mov ah,08h
		int 21h
		push ax
		mov ah,01h
		int 21h
		pop ax
		ret
	leeChar ENDP

	impMono PROC

		mov dh,10
		mov dl,bl
		call ubica

		mov ah,02h
		mov dl, al
		int 21h

		cmp bl,0
		je salida

		cmp bl,1
		je cabeza

		cmp bl,2
		je cuerpo

		cmp bl,3
		je manoDerecha

		cmp bl,4
		je manoIzquierda

		cmp bl,5
		je pieDerecho

		cmp bl,6
		je pieIzquierdo

		jmp salida

		cabeza:
			call dibHead
			jmp salida

		cuerpo:
			call dibBody
			jmp salida
		
		manoDerecha:
			call dibMD
			jmp salida
		
		manoIzquierda:
			call dibMI
			jmp salida

		pieDerecho:
			call dibPD
			jmp salida

		pieIzquierdo:
			call dibPI
			jmp salida

		salida:
			ret
	impMono ENDP

	asignaEspacios PROC
		mov bx,0
		ciclo:
			
			inc bx
			cmp bx,cx
			jne ciclo
		ret
	asignaEspacios ENDP


;--------------------DIBUJOS---------------------------------------
	dibEsp PROC
		mov dx,OFFSET line
		mov ax,SEG line
		mov ds,ax
		lea dx,line
		mov ah,9
		int 21h 
		ret
	dibEsp ENDP


	clean PROC
		MOV AX,0600H
		MOV BH,17H
		MOV CX,0000H
		MOV DX,184FH
		INT 10H
		ret
	clean ENDP


	dibCuerda PROC
		mov dh,2
		mov dl,45
		call ubica
		call impCuerda
		mov dh,3
		mov dl,45
		call ubica
		call impCuerda
		mov dl,45
		mov dh,4
		call ubica
		call impCuerda
		mov dl,45
		mov dh,5
		call ubica
		call impCuerda
		ret
	dibCuerda ENDP
	
	dibHead PROC
		mov dh,6
		mov dl,45
		call ubica
		call impHead
		ret
	dibHead ENDP

	dibBody PROC
		mov dh,7
		mov dl,45
		call ubica
		call impCuerda
		;mov dh,8
		;mov dl,45
		;call ubica
		;call impCuerda
		ret
	dibBody ENDP

	dibMD PROC
		mov dh,6
		mov dl,44
		call ubica
		call impDer
		ret
	dibMD ENDP

	dibMI PROC
		mov dh,6
		mov dl,46
		call ubica
		call impIzq
		ret
	dibMI ENDP

	dibPD PROC
		mov dh,8
		mov dl,44
		call ubica
		call impIzq
		ret
	dibPD ENDP

	dibPI PROC
		mov dh,8
		mov dl,46
		call ubica
		call impDer
		ret
	dibPI ENDP



	ubica PROC
		mov ah,02h ; pone en ah el nùmero de servicio
		xor bh,bh ; bh se pone a 0 (pagina 0 del video)
		int 10h ; llamada al bios
		ret
	ubica ENDP

	impHead PROC
		mov dx,OFFSET head
		mov ax,SEG head ; segmento en AX
		mov ds,ax ; DS:DX apunta al mensaje
		mov ah,9
		int 21h
		ret
	impHead ENDP

	impCuerda PROC
		mov dx,OFFSET cuerda
		mov ax,SEG cuerda ; segmento en AX
		mov ds,ax ; DS:DX apunta al mensaje
		mov ah,9
		int 21h
		ret
	impCuerda ENDP


	impIzq PROC			;mano izquiera y pie derecho
		mov dx,OFFSET lh
		mov ax,SEG lh ; segmento en AX
		mov ds,ax ; DS:DX apunta al mensaje
		mov ah,9
		int 21h
		ret
	impIzq ENDP

	impDer PROC			;mano derecha y pie izquierdo
		mov dx,OFFSET rh
		mov ax,SEG rh ; segmento en AX
		mov ds,ax ; DS:DX apunta al mensaje
		mov ah,9
		int 21h
		ret
	impDer ENDP
	
		
codesg ends
end main
end