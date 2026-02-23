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
	// res -> s0 ; i -> s1 
	li s0, 0 // res = 0
	li s1, 0 // i = 0

for:
	bgt s1, N, save
	add s0, s0, s1
	addi s1, s1, 1
	j for

save:
	la t0, res		// cargamos la direccion de res
	sw s0, 0(t0)	// guardamos el nuevo valor de res
fin:
	j fin
.end