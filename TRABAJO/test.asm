.model small

.stack 100h
CR EQU 13
LF EQU 10
.data

    par db 'Par',CR,LF,'$'
    impar db 'Impar',CR,LF,'$'
.code

START:

    xor ax,ax; inicializar en 0 ax
    mov cl,0; mandar 0 a cl
    mov bl,1;
    
etq1: ;etiqueta , con :

    and bl,cl;
    cmp bl,0;
    je imprime_par;
    jne imprime_impar;

continua:

    mov bl,1;
    add ax,cx; guarda lo que tiene cx a ax
    inc cx; incremento en 
    cmp cx,5; compara cx con 5 , el if  , si no son igales contina a la sig instruccion
    je etq2;
    jmp etq1;
    
etq2:

    mov ax,4c00h; return 0 
    int 21h ; return 0 
    
imprime_par:

    mov dx,OFFSET par
    mov ax,SEG par
    mov ds,ax
    lea dx,par
    mov ah,9
    int 21h
    jmp continua;
    
imprime_impar:

    mov dx,OFFSET impar
    mov ax,SEG impar
    mov ds,ax
    lea dx,impar
    mov ah,9
    int 21h
    jmp continua;
    
END START ;