.model tiny
.stack 100h
	CR EQU 13
	LF EQU 10
 
.code
start:

	mov dx,OFFSET instr1
	mov ax,SEG instr1
	mov ds,ax
	LEA dx,instr1
	mov ah,9
	int 21h
	
	LEA SI,matrizUno
	call leeMatriz

	mov dx,OFFSET instr2
	mov ax,SEG instr2
	mov ds,ax
	LEA dx,instr2
	mov ah,9
	int 21h
	
	LEA SI,matrizDos

	call leeMatriz


	mov dx,0	
	call prodMatriz

	call return



.data
	matrizUno DB 9 DUP(0)
	matrizDos DB 9 DUP(0)
	matrizRes DW 9 DUP(0)
	instr1 DB 'Inserte los valores de la primera matriz',CR,LF,'$'
	instr2 DB 'Inserte los valores de la segunda matriz',CR,LF,'$'
	msgFinal DB 'El producto de las matrices es de',CR,LF,'$'		

	leeMatriz PROC
		mov cx,0
		ciclo:
			cmp ch,9
			je fin
			cmp cl,3
			je sl
			jmp continue

		sl:
			xor cl,cl
			call formaMat
		
		continue:
			mov ah,01h
			int 21h
			AND al,0Fh 	;le quito el 48
			mov [SI],al	;lo guardo en la primera matriz
			inc cl
			inc ch
			inc SI
			jmp ciclo
	
		fin:
			call formaMat
			ret
	leeMatriz ENDP


	formaMat PROC
		mov dl,10
		mov ah,02h
		int 21h
		ret
	formaMat ENDP

prodMatriz PROC 

		mov dx,0
		mov cx,0
		push cx
		ciclos:
			pop cx
			;push dx
			inc cx
			
			cmp cx,1
			je fila1
			cmp cx,2
			je fila2
			cmp cx,3
			je fila3
			
			jmp salida


		fila1:
				push cx
				LEA DI, matrizUno

				mov ax, [DI]		;valor de la primera matriz
		
				xor cx,cx
				push cx
				mov dx,0
				jmp columnas

		fila2:
				push cx
				LEA DI, matrizUno
				ADD DI,3
				mov ax, [DI]	
		
				xor cx,cx
				push cx
				mov dx,0
				jmp columnas


		fila3:
				push cx
				LEA DI,matrizUno
				ADD DI,6
				mov ax,[DI]


				mov dx,0	
				xor cx,cx
				push cx
				jmp columnas

			

		columnas:

				pop cx
				inc cx
				
				cmp cx,1
				je col1
				cmp cx,2
				je col2
				cmp cx,3
				je col3

				call formaMat
				jmp ciclos
				
		col1:
					push cx
					LEA SI,matrizDos
					mov bx,[SI]
					xor dx,dx

					jmp producto
			
		col2: 
					push cx
					LEA SI,matrizDos
					INC SI
					mov bx,[SI]
					xor dx,dx
	
					jmp producto

		col3:
					push cx
					LEA SI,matrizDos
					mov cx,2
					ADD si,cx
					mov bx,[SI]
					xor dx,dx

					jmp producto	

			

				
		producto:
					mov cx,3
					mul bl
					
					push ax
				
					inc DI
					inc dx
					ADD SI,cx
				
					cmp dx,3
					je finCol

					mov ax,[DI]
					mov bx,[SI]
					
					

					jmp producto


		finCol:
					xor dx,dx

					pop ax
					ADD dx,ax
					pop ax
					ADD dx,ax
					pop ax
					ADD dx,ax
					
					mov ax,dx
					AAM

					LEA SI,matrizRes
					
					
					asignaRes:	
							mov bx,[SI]
							cmp bx,0
							je libre
							inc SI
							jmp asignaRes

					libre:
						mov [SI],ax
						mov bx,ax
						call impNumero
					SUB DI,3
					mov ax,[DI]
					jmp columnas

	salida:
	ret
prodMatriz ENDP	

impNumero PROC
	cmp bh,9
	ja tresDigitos

	OR bx,3030h
	mov dl,bh
	mov ah,02h
	int 21h

	mov dl,bl
	mov ah,02h
	int 21h
	
	jmp espacio

	tresDigitos:
		push bx

		mov al,bh
		AAM
		mov bx,ax
		
		OR bx,3030h
		mov dl,bh
		mov ah,02h
		int 21h

		mov dl,bl
		mov ah,02h
		int 21h

		pop bx

		mov dl,bl
		OR dl,30h

		mov ah,02h
		int 21h
		jmp unEspacio
		
	espacio:
		mov dl,32
		mov ah,02h
		int 21h
	unEspacio:
		mov dl,32
		mov ah,02h
		int 21h
	ret
impNumero ENDP



	return PROC
		mov ax,4c00h
		int 21h
		ret
	return ENDP

	
end start

