/*---------------------------------------------------------------------
**
**  Fichero:
**    pr1_a.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 1a
**
**  Notas de diseño:
**
**	# define N 10
**	int res = 0;
**	for (int i = 0; i < N ; i ++) {
**		res += i ;
**	}
**
**-------------------------------------------------------------------*/

//defino la constante N
.equ N, 10
//reservo espacio para el resultado
.bss
	res: 	.space 4
//programa
.text
.global main
main:
	// res -> t0 ; i -> t1 ; N -> t2 ; res(address) -> t3
	li t0, 0 // res = 0
	li t1, 0 // i = 0
	li t2, N // t2 = N 


for:
	bge t1, t2, save
	add t0, t0, t1
	addi t1, t1, 1
	j for

save:
	la t3, res		// cargamos la direccion de res
	sw t0, 0(t3)	// guardamos el nuevo valor de res
fin:
	j fin

.end