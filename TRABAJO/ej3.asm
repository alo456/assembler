.model tiny
.stack 100h

	CR EQU 13
	LF EQU 10
.data

	par db 'Par',CR,LF,'$'
   	impar db 'Impar',CR,LF,'$'
	
.code
start:
	mov bl,48;
	xor ah,ah	
	int 16h 	

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

	mov cl,0

ciclo:
	mov bl,1


	and bl,cl;
   	cmp bl,0;

   	je imprime_par;
   	jne imprime_impar;


imprime_par:
	mov bl,al

    	mov dx,OFFSET par
    	mov ax,SEG par
    	mov ds,ax
    	lea dx,par
    	mov ah,9
    	int 21h

	mov dl,1
	add cl,dl
	mov al,bl

	cmp cl,al
    	jne ciclo;
    	je fin

imprime_impar:
	mov bl,al
	
    	mov dx,OFFSET impar
    	mov ax,SEG impar
    	mov ds,ax
    	lea dx,impar
    	mov ah,9
    	int 21h

	mov dl,1
	add cl,dl
	mov al,bl

	cmp cl,al
    	jne ciclo;
	je fin
	

fin:		
	mov ax,4c00h
	int 21h
	
end start