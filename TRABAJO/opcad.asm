TITLE	P12SCAST (COM) OPERACIONES DE CADENAS CON SCAS
	.MODEL	SMALL
	.STACK
	.CODE
	ORG	100H
BEGIN:	JMP	SHORT MAIN
;-----------------------------------------
NAME1	DB	'Assemblers'	;Elementos de datos
;-----------------------------------------
MAIN	PROC	NEAR
	CLD
	MOV	AL,'m'
	MOV	CX,10
	LEA	DI,NAME1 +100H
	;MOV	SI,AL
	REPNE	SCASB
	JNE	H20

	MOV	AL,03

H20:
	MOV 	AH,4CH
	INT	21H
MAIN	ENDP
	END	BEGIN