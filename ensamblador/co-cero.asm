.model tiny
.stack 100h
	CR EQU 13
	LF EQU 10
.data
	cero DB CR,LF,'Cantidad de CEROS en binario:',CR,LF,'$'
	uno DB CR,LF,'Cantidad de UNOS binario:',CR,LF,'$'

.code
start:
	mov ah,01h
	int 21h
	mov bl,48
	SUB al,bl
	mov bl,10
	mul bl

	mov cl,al
	
	mov bl,48
	mov ah,01h
	int 21h

	SUB al,bl
	ADD cl,al
	
	xor ax,ax
	mov dl,1
	ciclo:
		mov dl,1
		cmp cl,0
		je fin
		
		AND dl,cl
		cmp dl,0
		je contaCero
		jmp contaUno

		contaCero:	
			inc al
			SAR cl,01
			jmp ciclo

		contaUno:
			inc ah
			SAR cl,01
			jmp ciclo
	fin:
		push ax
		mov dx,OFFSET cero
		mov ax,SEG cero
		mov ds,ax
		LEA dx,cero
		mov ah,9
		int 21h

		pop ax

		OR AX,3030h
		push ax

		mov dl,al
		mov ah,02h
		int 21h

		mov dx,OFFSET uno
		mov ax,SEG uno
		mov ds,ax
		LEA dx,uno
		mov ah,9
		int 21h

		pop ax
		mov dl,ah
		mov ah,02h
		int 21h

		mov ax,4c00h
		int 21h

end start




		
	