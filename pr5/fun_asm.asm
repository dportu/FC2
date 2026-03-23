 /*---------------------------------------------------------------------
**
**  Fichero:
**    fun_asm.asm  01/05/2025
**
**    (c) J.M. Mendias
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 5
**
**-------------------------------------------------------------------*/

.global matrixPow // para ver lo del archivo .c (tercer funcion)

.text

matrixCopy: // PRIMERA FUNCION

//en a0 la dimension de n
//a1 contiene la direcion de x[0][0]
//a2 contiene la direccio de z[0][0]
	li t0, 0 // i = 0

for1://(int i = 0; i < n; i++)

	bge t0, a0, efor1 // salta a efor1 cuando i >= que N
	li t1, 0 // j = 0

for2://	(int j = 0; j < n ; j ++)

	bge t1, a0, efor2 // salta a efor2 cuando j >= que N

	// dir(m[i][j])= dir(m) + (i*N+j)*4

	mul t2, t0, a0 // t2 = i*N
	add t2, t2, t1 // t2 = (i*N+j)
	slli t2, t2, 2 //t2 (i*N+j)*4
	add t3, t2, a1 // dir(x[i][j])= dir(m) + (i*N+j)*4 -> direccion de x[i][j] en t3
	add t4, t2, a2 //dir(z[i][j]) = dir(m) + (i*N+j)*4 -> direccion de z[i][j] en t4

	lw t3, 0(t3) // en t3 guardo el valor de x[i][j]
	sw t3, 0(t4) // en la direccion de memoria de t4(z[i][j]) guardo el valor de x[i][j]

	addi t1, t1, 1 // j++
	j for2

efor2:
	addi t0, t0, 1 //i++
	j for1

efor1:
	ret


matrixMul: // segunda funcion
// en a0 la dimension de n
//a1 contiene la direcion de x[0][0]
//a2 contiene la direccio de y[0][0]
//a3 contiene la direccion de z[0][0]

	li t0, 0 // i = 0

for3: // (int i = 0; i < n; i++) -> primer for de la segunda funcion

	bge t0, a0, efor3 // salta a efor3 cuando i >= n
	li t1, 0 // j = 0

for4: // (int j = 0; j < n ; j ++)

	bge t1, a0, efor4    // salta a efor4 cuando j >= n

	// dir(z[i][j])= dir(m) + (i*N+j)*4
	mul t2, t0, a0 // t2 = i*N
	add t2, t2, t1 // t2 = (i*N+j)
	slli t2, t2, 2 //t2 (i*N+j)*4
	add t3, t2, a3 //dir(z[i][j]) = dir(m) + (i*N+j)*4 -> direccion de z[i][j] en t3

	li t4, 0 // para ir guardando el valor de z[i][j]
	li t5, 0 // k = 0

for5: // (int k = 0; k < n ; k ++)

	bge t5, a0, efor5 // salta a efor5 cuadno k >= n

	// dir(m[i][j])= dir(m) + (i*N+k)*4
	mul t2, t0, a0 // t2 = i*N
	add t2, t2, t5 // t2 = (i*N+k)
	slli t2, t2, 2 //t2 (i*N+k)*4
	add t2, t2, a1 //dir(x[i][k]) = dir(m) + (i*N+k)*4 -> direccion de z[i][j] en t2

	lw t2, 0(t2) // en t2 se pone el valor de x[i][k]

	// dir(m[k][j])= dir(m) + (k*N+j)*4
	mul t6, t5, a0 // t6 = k*N
	add t6, t6, t1 // t6 = (k*N+j)
	slli t6, t6, 2 //t6 (k*N+j)*4
	add t6, t6, a2 //

	lw t6, 0(t6)// en t6 se pone el valor de y[k][j]

	//en t2 se pone el valor de x[i][k]
	//en t6 se pone el valor de y[k][j]

	mul t6, t2, t6 // (x[i][k])*(y[k][j])
	add t4, t4, t6 // (z[i][j])= (z[i][j]) + ( (x[i][k])*(y[k][j]) )
	addi t5, t5,1  // k++
	j for5

efor5:
	sw t4, 0(t3) // guardamos el resultado
	addi t1, t1, 1 // j++
	j for4

efor4:
	addi t0, t0, 1 // i++
	j for3
efor3:

	ret

matrixPow: // tercera funcion

//los dos primeros for son para calcular la matriz identidad en z[n][n]

//en a0 esta la dimension de n
//a1 contiene la direcion de x[0][0]
//en a2 se guarda al valor al que esta elevado
//a3 contiene la direccion de z[0][0]

	//prologo
	addi sp, sp, -32
	sw ra, 0(sp) // almacena la direccion de retorno
	sw s1, 4(sp) // en s1 -> j
	sw s2, 8(sp) // en s2 -> k
	sw s3, 12(sp)// en s3 -> i
	sw s4, 16(sp)// en s4 -> n y para calcular el tamaño de la matriz en memoria
	sw s5, 20(sp)// en s5 -> e
	sw s6, 24(sp)// dir (x[0][0])
	sw s7, 28(sp)// dir(z[0][0])

	// calcular el espacio que tenemos que reservar -> n*n*tamaño del dato
	mul s4,a0 ,a0 // en s4 -> tam de la matriz aux
	slli s4, s4, 2 // direcciones necesarias en la pila

	sub sp, sp , s4 // movemos la pila

	mv s4, a0 // en s4 -> ponemos el valor de n
	mv s5, a2 // en s5 -> ponemos el valor de e
	mv s6, a1 // en s6 -> ponemos la direccion de x[0][0]
	mv s7, a3 // en s7 -> ponemos la direccion de z[0][0]

	li s1, 0 // j = 0

for6:
	bge s1, s4, efor6 // saltamoa a efor6 si j >= n
	li s2, 0 // k = 0

for7:
	bge s2, s4, efor7

	// dir(z[j][k])= dir(m) + (j*N+k)*4
	mul t0, s1, s4 // en t0 -> j*N
	add t0, t0, s2 // en t0 -> j*N + k
	slli t0, t0, 2 // en t0 -> (j*N + k)*4
	add t0, t0, s7 // //dir(z[j][k]) = dir(m) + (j*N+k)*4 -> direccion de z[j][k] en t0

if:
	bne s1, s2, else // salrta a else si j!=k
	li t1, 1
	sw t1, 0(t0)

	j eif

else:
	li t1, 0
	sw t1, 0(t0)

eif:
	addi s2, s2, 1 // k++
	j for7

efor7:
	addi s1, s1, 1 // j++
	j for6

efor6:
	li s3, 1 // i = 1


for8: //(int i = i ; i < n ; i ++)-> el tercer for sirve para llamar a las otras dos funciones
	blt s5, s3, efor8 // salta efor8 si i > e

	//PARA MATRIXMUL (n, x, z, aux):
// en a0 la dimension de n
// a1 contiene la direcion de x[0][0]
// a2 contiene la direcion de z [0][0]
// a3 sera sp, la direccion de la amtriz aux
	mv a0, s4
	mv a1, s6 // en a1 -> dir(x[0][0])
	mv a2, s7 // en a2 -> dir(z[0][0])
	mv a3, sp

	call matrixMul

	//PARA MATRIXCOPY (n, aux, z):
// en a0 la dimension de n
// a1 sera sp, la direccion de la amtriz aux
// a2 contiene la direcion de z [0][0]
	mv a0, s4
	mv a1, sp
	mv a2, s7 // en a2 -> dir(z[0][0])
	call matrixCopy

	addi s3, s3, 1 // i++
	j for8

efor8:

// calcular el espacio que tenemos que reservar -> n*n*tamaño del dato
	mul s4, a0, a0
	slli s4, s4, 2

	add sp, sp, s4

	// epilogo
	lw ra, 0(sp) // almacena la direccion de retorno
	lw s1, 4(sp) // en s1 -> j
	lw s2, 8(sp) // en s2 -> k
	lw s3, 12(sp)// en s3 -> i
	lw s4, 16(sp)// en s4 -> n y para calcular el tamaño de la matriz en memoria
	lw s5, 20(sp)// en s5 -> e
	lw s6, 24(sp)// dir (x[0][0])
	lw s7, 28(sp)// dir(z[0][0])
	addi sp, sp, 32

	ret












