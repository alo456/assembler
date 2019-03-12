.model tiny
.stack
.data

.code
start:
	mov bl,48;
	xor ah,ah	;asigna 0 a 'a'
	int 16h 	;interrupcion 16

	sub al,bl
	mov bl,10
	mul bl

	mov cl,al
	
	mov bl,48
	mov ax,0
	int 16h

	sub al,bl
	add cl,al

	mov ax,0
	mov al,cl

	mov cl,10

	sub al,cl

		
	ciclo:				
		div cl
		cmp al,0
		jne imprime
		je fin

	imprime:
		

		add al,bl
		mov dl,al
		mov cl,ah
		mov ah,02h
		int 21h

		mov al,cl
		add al,bl
		mov dl,al

		mov ah,02h
		int 21h
		jmp return 
		
	fin:		

		add ah,bl
		mov dl,ah
		mov ah,02h
		int 21h

	return:
		mov ax,4c00h
		int 21h
end start