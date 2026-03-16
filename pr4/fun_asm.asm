/*---------------------------------------------------------------------
**
**  Fichero:
**    fun_asm.c  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 4
**
**-------------------------------------------------------------------*/


//rellenar con directivas .extern y .global
//con las funciones apropiadas

.extern _stack
.extern mul
.extern i_sqrt


.global eucl_dist
.global guardar

.text

la sp,_stack // se carga la direccion de memoria de la pila


//int eucl_dist(int * w, int size);
eucl_dist:
	//Prologo
	addi sp, sp, -20
	sw ra, 16(sp)
	sw s1, 12(sp)
	sw s2, 8(sp)
	sw s3, 4(sp)
	sw s4, 0(sp)

	//recibo dirección de W en a0, y tamaño N en a1
    //realizo los cálculos pertinentes
    //devuelvo el resultado en a0

	mv s1, a0 // en a0 guardo la direccion de W
	mv s2, a1 //en a1 guardo el tamaño N = 5
	li s3, 0 // en s3 cargo el inmediato 0 que va a ser el acc = 0
	li s4,0 //en s4 cargo el inmediato 0 que va a ser i=0

for:
	// for(int i = 0; i < N; i++){ -> el i = 0 ya se ha declarado previamente, igual que el acc = 0
	//		acc += mul(w[i], w[i])
	// }

	bge s4, s2, fin_for // salta a finfor si i es mayor o igual que N

	slli t1, s4, 2 //i*4 porque cada int ocupa 4 bytes
	add t2, s1, t1 // en t2 guardo la direccion de w[i]
	lw t3, 0(t2) // en t3 guardo el valor de W[i]

	mv a0, t3 // en a0 guardo el valor de t3
	mv a1, t3  // en a1 guardo el valor de t3

	call mul  //Llamar a mul

	add s3, s3, a0 // se realiza -> acc += mul(w[i], w[i])
	addi s4, s4, 1 //i++
	j for

fin_for:
	mv a0, s3 // se devuelve el resultado a a0
	call i_sqrt // Llamar a i_sqrt


	//Epilogo
	lw ra, 16(sp)
	lw s1, 12(sp)
	lw s2, 8(sp)
	lw s3, 4(sp)
	lw s4, 0(sp)
	addi sp, sp, 20

	ret

//int guardar(char valor, char * ubicacion);
guardar:
    //recibo el valor en a0, y la dirección destino en a1
    //asegurarse que sólo se guarda UN BYTE!!
    sb a0, 0(a1)
    ret
