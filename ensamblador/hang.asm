Title AHORCADO

stacksg segment para STACK 'stack'
	DB 100h DUP(0)
	CR EQU 13
	LF EQU 10
stacksg ends

datasg segment
	PALABRA DB 64H DUP (0) ;SE DECLARA LA VARIABLE "PALABRA" DE TAMAÑO 100 (64H)
	guess DB 64H DUP(0)
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
			CALL clean
			mov dx,0200h
			call ubica

		INICIO:
			MOV AH,08H ;SE CAPTURA EL CARACTER sin mostrarlo 08, mostrar con 01
			INT 21H

			CMP AL,0DH ;SE COMPARA CON ENTER
			JE FINPALABRA ;SI ES IGUAL SALTA A 'FINPALABRA'

			CMP AL,20H ;SE COMPARA CON EL ESPACIO
			JE ESPACIO ;SI ES IGUAL SALTA A ESPACIO
			

			MOV [SI],AL ;SE MUEVE 'AL' A LA PRIMERA POSISION DE 'SI'
			INC SI ;SE INCREMENTA 'SI'

			mov dx,OFFSET line
			mov ax,SEG line
			mov ds,ax
			lea dx,line
			mov ah,9
			int 21h 

			JMP INICIO ;SE REGRESA A INCIO HASTA QUE SE PRESIONE ENTER

			;SI SE PRECIONA UN ESPACIO SOLO SE INCREMENTE EL VALOR DE 'SI'
			ESPACIO:
				mov ah, 02h
				mov dx, 32 
				int 21h 
				INC SI
				JMP INICIO


		FINPALABRA:

			; COMPRUEBA SI LA CADENA ESTA VACIA 
			MOV CX,0000H
			CMP SI,CX ;SE COMPARA 'SI' CON 0 (CERO)
			JE INICIO ;SI ES IGUAL REGRESA A INICIO
			mov ah, 02h
			mov dx, 10 
			int 21h 
			;SINO ESTA VACIA
			;push si
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
			jmp return

		winner:
			mov dx,0F0Fh
			call ubica
			mov dx,OFFSET msgWinner
			mov ax,SEG msgWinner
			mov ds,ax
			lea dx,msgWinner
			mov ah,9
			int 21h
							
		return:
			mov ah,4ch
			int 21h
	main endp

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