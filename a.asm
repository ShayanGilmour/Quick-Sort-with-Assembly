%include "in_out.asm"

section .data
	Msg1	db	' '
	Len1	equ	$-Msg1

section .bss
	str:	resb	200
	len:	resb	8

	ar:	resq	100 ;Main array
	br:	resq	100 ;Helper array #1
	cr:	resq	100 ;Helper array #2

section .text
	global _start

_start:
	mov	rax,	3
	mov	rbx,	2
	mov	rcx,	str
	mov	rdx,	200
	int	0x80

	mov	rsi,	str
	mov	rdi,	ar
	xor	r8,	r8

	readWhile:		;Reading the input and put each number in 8 byte of ar
	call	getNum
	inc	r8
	mov	[rdi], rax
	add	rdi,	8
	
	mov	al,	[rsi]
	cmp	al,	0xA
	jz	afterRead
	
	inc	rsi
	jmp	readWhile

afterRead:
	mov	[len], r8
	mov	r9,	[len]
	mov	r8,	0
	
	push	r9 ;en
	push	r8 ;st
	call	QuickSort	;Quick Sort it

	mov	r8, 0
printWhile:			;Print it
	mov	rax,	[len]
	cmp	r8,	rax
	jz	Exit
	mov	rax,	[ar+8*r8]
	call	writeNum

	mov	rax,	4
	mov	rbx,	1
	mov	rcx,	Msg1
	mov	rdx,	Len1
	int	0x80
	inc	r8
	jmp	printWhile

QuickSort:			;Main function
	mov	r8, [rsp+8]		;st
	mov	r9, [rsp+8*2]	;en

	mov	rax,	r8
	cmp	rax,	r9
	jz	QRet
	inc	rax
	cmp	rax,	r9
	jz	QRet

	mov	rsi,	br
	mov	rdi,	cr

	QWhile:
	cmp	rax,	r9
	jz	afterQWhile
	mov	rbx,	[ar+rax*8]
	cmp	rbx,	[ar+r8*8] 	;CMP to first
	jg	Greater 		;Greater

	mov	rcx,	[ar+rax*8] 	;Less or equal
	mov	[rsi], rcx
	add	rsi,	8
	inc	rax
	jmp	QWhile

	Greater:
	mov	rcx,	[ar+rax*8]
	mov	[rdi], rcx
	add	rdi,	8
	inc	rax
	jmp	QWhile


  	afterQWhile:
	mov	r10,	rsi	;br end point
	mov	r11,	rdi	;cr end point
	mov	rdi, 	ar
	mov	rax,	r8	;1*r8
	add	rax,	rax	;2*r8
	add	rax,	rax	;4*r8
	add	rax,	rax	;8*r8
	add	rdi,	rax
	mov	rcx,	[ar+r8*8] ;Base
	mov	rsi,	br
	
	mov	r12,	r8 ;Mid

	moveLess:	;Move smaller numbers
	cmp	rsi,	r10
	jz	moveBase
	inc	r12
	mov	rax,	[rsi]
	mov	[rdi], rax
	add	rsi,	8
	add	rdi,	8
	jmp	moveLess

	moveBase:	;Move the base number
	mov	[rdi], rcx
	add	rdi,	8
	mov	rsi,	cr

	moveGreater: ;Move the greater numbers	
	cmp	rsi,	r11
	jz	callRec
	mov	rax,	[rsi]
	mov	[rdi], rax
	add	rsi,	8
	add	rdi,	8
	jmp	moveGreater

	callRec: ;Call recursive
	push	r8	;St
	push	r12	;Mid
	push	r9	;En

	push	r12 	;en for 1st rec
	push	r8	;st for 1st rec
	call	QuickSort

	pop	r9
	pop	r12
	pop	r8

	inc 	r12
	push	r9	;en for 2nd rec
	push	r12	;st for 2nd rec
	call	QuickSort


QRet:
ret 16	;Free the st and en

;----------Get Num----------- 
;Returns the the
;number rsi is 
;Pointing in RAX
getNum:

push	r8  ;Ans
push	r9  ;Digit
push	rbx
push	rcx
push	rdx
push	r10
push	r11

xor	r11,	r11
mov	r9b,	[rsi]
cmp	r9b,	'-'
jz	readNeg

xor	r8,	r8

	gWhile:
	mov	r9b,	[rsi] ;One digit
	cmp	r9b,	'0'
	jl	gExit
	cmp	r9b,	'9'
	jg	gExit

	mov	rax,	r8
	mov	r10,	10
	mul	r10

	sub	r9,	'0'
	add	rax,	r9
	mov	r8,	rax

	inc	rsi
	jmp	gWhile

readNeg:
inc	rsi
mov	r11,	1 ;flag for negativity
xor	r8,	r8
jmp	gWhile

makeNeg:
neg	rax
jmp	gPop


gExit:
mov	rax,	r8 ;Ans
cmp	r11,	0
jg	makeNeg

gPop:
pop	r11
pop	r10
pop	rdx
pop	rcx
pop	rbx
pop	r9
pop	r8
ret
;----------Get Num-----------


Exit:
	mov	rax,	1
	mov	rbx,	0
	int	0x80

