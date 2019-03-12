.model tiny
.code
.stack 100h
	CR EQU 13
	LF EQU 10
start:
	mov si,100h
	call clean
	Call marco

	mov cl,0
	
	tiro:
		cmp cl,9
		je ult
		push cx
		cmp cl,5
		jae check

	finChequeo:
		call leeDosCar	
		pop cx		
		cmp al,0
		je tiro
		call gotoxy
		inc cl
		jmp tiro

	check:
		call checkForWinner
		jmp finChequeo
	
	ult:
		call checkForWinner

		mov dx,0F0Fh
		call ubica
		mov dx,OFFSET msgEmpate
		mov ax,SEG msgEmpate
		mov ds,ax
		lea dx,msgEmpate
		mov ah,9
		int 21h

		call return 



	.data
	Texto DB "* * * I * * * I * * *$"
	vert DB 'I$'
	tiro0 DB "O$"
	tirox DB "X$"
	ganaC DB "Ganaron los circulos$"
	ganaX DB "Ganaron las equis$"	
	msgEmpate DB 'GATO!! $'	

	msjError DB "Inserta una posicion adecuada$"
	tab DB 40 DUP(0)

	clean PROC
		MOV AX,0600H
		MOV BH,17H
		MOV CX,0000H
		MOV DX,184FH
		INT 10H
		ret
	clean ENDP

	;aquì estaba el checador de ganador

	checkForWinner PROC
		mov bx,0
		

;--------------------checando horizontales
		mov si,11
		horizontalPrim:
			add bl,tab[si]
			inc si;
			cmp si,13
			jbe horizontalPrim
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc


		mov bx,0
		mov si,21
		horizontalSeg:
			add bl,tab[si]
			inc si;
			cmp si,23
			jbe horizontalSeg
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc

	
		mov bx,0
		mov si,31	
		horizontalTer:
			add bl,tab[si]
			inc si;
			cmp si,33
			jbe horizontalTer
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc

;--------------------checando verticales
	
		mov cl,10
		mov bx,0
		mov si,11
		verticalPrim:				
			add bl,tab[si]
			add si,cx
			cmp si,31
			jbe verticalPrim
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc

;------------------------------------------------------------
		mov bx,0
		mov si,12
		jmp verticalSeg
		ganoEquis:
			call ganoX
			;call return

		ganoCirc:
			call gano0
			;call return

;------------------------------------------------------------
		

		verticalSeg:
			add bl,tab[si]
			add si,cx
			cmp si,32
			jbe verticalSeg
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc

		mov bx,0
		mov si,13
		verticalTer:
			add bl,tab[si]
			add si,cx
			cmp si,33
			jbe verticalTer
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc

;--------------------checando diagonales

		inc cl
		mov bx,0
		mov si,11
		diagPrim:			
			add bl,tab[si]
			add si,cx
			cmp si,33
			jbe diagPrim
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc


		mov cl,9
		mov bx,0
		mov si,13
		diagSeg:
			add bl,tab[si]
			add si,cx
			cmp si,31
			jbe diagSeg
			cmp bl,3
			je ganoEquis
			cmp bl,12
			je ganoCirc

		ret
	checkForWinner ENDP




	ganoX PROC	

		mov dh,15
		mov dl,10
		mov ah,02h
		;xor bh,bh
		int 10h

		mov dx,OFFSET ganax
    		mov ax,SEG ganax
    		mov ds,ax
    		lea dx,ganax
    		mov ah,9
    		int 21h
		call return
	ganoX ENDP


	gano0 PROC

		mov dh,15
		mov dl,10
		mov ah,02h
		;xor bh,bh
		int 10h
					
		mov dx,OFFSET ganac
	    	mov ax,SEG ganac
	    	mov ds,ax
    		lea dx,ganac
    		mov ah,9
  		int 21h
		call return 
	gano0 ENDP


	gotoxy PROC
		mov ah,02h ; pone en ah el nùmero de servicio
		xor bh,bh ; bh se pone a 0 (pagina 0 del video)
		int 10h ; llamada al bios
		;pop bx	;salida del tiro
		mov dl,1
		and dl,cl
		cmp dl,0
		je tiroCirc
		jne tiroEquis

		tiroCirc:
			mov tab[si],4
			mov dx,OFFSET tiro0
			mov ax,SEG tiro0 ; segmento en AX
			jmp final

		tiroEquis:
			mov tab[si],1
			mov dx,OFFSET tirox
			mov ax,SEG tirox ; segmento en AX
			jmp final
		
		final:			
			mov ds,ax ; DS:DX apunta al mensaje
			mov ah,9
			int 21h
			ret
	gotoxy ENDP

	gotox PROC
		mov ah,02h ; pone en ah el nùmero de servicio
		xor bh,bh ; bh se pone a 0 (pagina 0 del video)
		int 10h ; llamada al bios
		mov dx,OFFSET Texto
		mov ax,SEG Texto ; segmento en AX
		mov ds,ax ; DS:DX apunta al mensaje
		mov ah,9
		int 21h
		ret
	gotox ENDP

	gotoy PROC
		mov ah,02h ; pone en ah el nùmero de servicio
		xor bh,bh ; bh se pone a 0 (pagina 0 del video)
		int 10h ; llamada al bios
		mov dx,OFFSET vert
		mov ax,SEG vert ; segmento en AX
		mov ds,ax ; DS:DX apunta al mensaje
		mov ah,9
		int 21h
		ret
	gotoy ENDP

	marco PROC
		mov dh,6
		mov dl,28
		call gotox
		mov dh,10	
		mov dl,28
		call gotox
		mov dh,4
		mov dl,34
		call gotoy
		mov dh,4
		mov dl,42
		call gotoy
		mov dh,8
		mov dl,34
		call gotoy
		mov dh,8
		mov dl,42
		call gotoy
		mov dh,12
		mov dl,34
		call gotoy
		mov dh,12
		mov dl,42
		call gotoy



		ret
	marco ENDP

	leeDosCar PROC
		mov cx,0
		mov bl,48;
		mov dl,24
		xor ah,ah
	
		int 16h 	
		sub al,bl
		mov dh,al

		mov bl,10
		mul bl
		mov cl,al
		mov bl,48

		mov ax,0
		int 16h
		sub al,bl
	
		add cl,al
		
		mov si,cx

		
		cmp tab[si],0
		jne error
	



		cmp al,3
		ja error
		asignaprim:
		
			mov bl,7
			mul bl
			add dl,al

			cmp dh,3
			ja error

		asignaseg:
			mov al,4
			mul dh
			mov dh,al
			mov al,1
			jmp salida
		error:
			mov al,0
	
		salida:
			
			ret
	leeDosCar ENDP

	ubica PROC
		mov ah,02h ; pone en ah el nùmero de servicio
		xor bh,bh ; bh se pone a 0 (pagina 0 del video)
		int 10h ; llamada al bios
		ret
	ubica ENDP


	return PROC
		mov ax,4c00h
		int 21h
		ret
	return ENDP
	
end start