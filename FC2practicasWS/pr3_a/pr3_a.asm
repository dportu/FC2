/*---------------------------------------------------------------------
**
**  Fichero:
**    pr2_b.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 2b
**
**  Notas de diseño:
**
**	int mul(int a, int b) {
**	    int res = 0;
**	    while (b > 0) {
**	        res += a;
**	        b--;
**	    }
**	    return res;
**	}
**
**	int dotprod(int V[], int W[], int n) {
**	    int acc = 0;
**	    for (int i = 0; i < n; i++) {
**	        acc += mul(V[i], W[i]);
**	    }
**	    return acc;
**	}
**
**	#define N 4
**	int A[] = {3, 5, 1, 9}
**	int B[] = {1, 6, 2, 3}
**
**	int res;
**
**	void main() {
**	    int normA = dotprod(A, A, N);
**	    int normB = dotprod(B, B, N);
**	    if (normA > normB)
**	        res = 0xa;
**	    else
**	        res = 0xb;
**	}
**
**-------------------------------------------------------------------*/

.extern _stack
.global main

.equ N, 4
.data
    A: .word 3, 5, 1, 9
    B: .word 1, 6, 2, 3
.bss 
    res: .space 4
.text

main:
    la sp , _stack  // inicializa sp

    la a0, A       // a0 = address(A)
    la a1, A       // a1 = address(A)
    li a2, N
    call dotprod
    mv s0, a0       // s0 = normA = dotprod (A , A , N)

    la a0, B       // a0 = address(B)
    la a1, B       // a1 = address(B)
    li a2, N
    call dotprod
    mv s1, a0       // s1 = normB = dotprod (B , B , N)

    la t0, res      // t0 = address(res)

    bgt s0, s1, greater
    li t1, 0xb
    j save 

greater:
    li t1, 0xa

save:
    sw t1, 0(t0)
fin:
    j fin


//  SUBRUTINA MUL
mul : //    a0 -> a ; a1 -> b  
    li t0, 0       // t0 = res
while: 
    beqz a1, return_mul // if b == 0 -> j return
    add t0, t0, a0      // res += a
    addi a1, a1, -1     // b--
    j while
return_mul: // movemos ret a a0 y lo devolvemos
    mv a0, t0   
    ret 


//  SUBRUTINA DOT PRODUCT
dotprod: // a0 -> address(V) ; a1 -> address(W) ; a2 -> n

    // PROLOGO
    addi sp, sp, -24    // ra, s0-s4
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)

    // movemos a0-a2 a s0-s2 para preservarlos
    mv s0, a0
    mv s1, a1
    mv s2, a2

    li s3, 0 // s3 = i
    li s4, 0 // s4 = acc
for:
    bge s3, s2, epilogo // if i >= n; j for_end
    
    // Cargamos argumentos para mul
    lw a0, 0(s0) // a = V[i]
    lw a1, 0(s1) // b = W[i]
    call mul

    // Acumulamos el resultado
    add s4, s4, a0 // acc += mul(V[i], W[i])

    addi s3, s3, 1 // i++
    addi s0, s0, 4 // s0 = address V[i]
    addi s1, s1, 4 // s1 = address W[i]
    j for

epilogo: // EPILOGO
    mv a0, s4
    lw ra, 20(sp)
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw s4, 0(sp)
    addi sp, sp, 24
    ret
