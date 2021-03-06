/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"
	
#define	M	r3
#define	N	r4
#define	A	r5
#define	LDA	r6
#define B	r7

#define AO1	r8
#define AO2	r9
#define AO3	r10
#define AO4	r11

#define J	r25
#define B1	r26
#define B2	r27
#define B3	r28
#define M4	r29
#define INC	r30
#define INC2	r31
	
#define c01	f0
#define c02	f1
#define c03	f2
#define c04	f3
#define c05	f4
#define c06	f5
#define c07	f6
#define c08	f7
#define c09	f8
#define c10	f9
#define c11	f10
#define c12	f11
#define c13	f12
#define c14	f13
#define c15	f14
#define c16	f15

	PROLOGUE
	PROFCODE

	li	r0, -16

	stfpdux	f14, SP, r0
	stfpdux	f15, SP, r0

	stwu	r31,  -4(SP)
	stwu	r30,  -4(SP)
	stwu	r29,  -4(SP)
	stwu	r28,  -4(SP)

	stwu	r27,  -4(SP)
	stwu	r26,  -4(SP)
	stwu	r25,  -4(SP)

	slwi	LDA, LDA, ZBASE_SHIFT
	slwi	M4, M, 2 + ZBASE_SHIFT

	li	r8, -4
	li	r9, -2

	and	B2, N, r8
	and	B3, N, r9

	mullw	B2, B2, M
	mullw	B3, B3, M

	slwi	B2, B2, ZBASE_SHIFT
	slwi	B3, B3, ZBASE_SHIFT

	add	B2, B2, B
	add	B3, B3, B

	cmpwi	cr0, M, 0
	ble-	LL(99)
	cmpwi	cr0, N, 0
	ble-	LL(99)

	subi	B2, B2, 2 * SIZE
	subi	B3, B3, 2 * SIZE
	subi	M4, M4, 30 * SIZE

	li	INC,  1 * SIZE
	li	INC2, 2 * SIZE

	andi.	r0, A,   2 * SIZE - 1
	bne	LL(100)

	subi	A, A, 2 * SIZE
	srawi.	J,  M,  2
	ble	LL(20)
	.align 4

LL(10):
	mr	AO1, A
	add	AO2, A,   LDA
	add	AO3, AO2, LDA
	add	AO4, AO3, LDA
	add	A,   AO4, LDA

	sub	B1, B, M4
	addi	B, B, 32 * SIZE

	srawi.	r0,  N,  2
	mtspr	CTR, r0
	ble	LL(15)
	.align 4

LL(12):
	LFPDUX	c01,   AO1, INC2
	LFPDUX	c05,   AO2, INC2
 	LFPDUX	c09,   AO3, INC2
	LFPDUX	c13,   AO4, INC2

	LFPDUX	c02,   AO1, INC2
	LFPDUX	c06,   AO2, INC2
	LFPDUX	c10,   AO3, INC2
	LFPDUX	c14,   AO4, INC2

	LFPDUX	c03,   AO1, INC2
	LFPDUX	c07,   AO2, INC2
 	LFPDUX	c11,   AO3, INC2
	LFPDUX	c15,   AO4, INC2

	LFPDUX	c04,   AO1, INC2
	LFPDUX	c08,   AO2, INC2
	LFPDUX	c12,   AO3, INC2
	LFPDUX	c16,   AO4, INC2

	STFPDUX	c01,   B1, M4
	STFPDUX	c02,   B1, INC2
	STFPDUX	c03,   B1, INC2
	STFPDUX	c04,   B1, INC2
	STFPDUX	c05,   B1, INC2
	STFPDUX	c06,   B1, INC2
	STFPDUX	c07,   B1, INC2
	STFPDUX	c08,   B1, INC2
	STFPDUX	c09,   B1, INC2
	STFPDUX	c10,   B1, INC2
	STFPDUX	c11,   B1, INC2
	STFPDUX	c12,   B1, INC2
	STFPDUX	c13,   B1, INC2
	STFPDUX	c14,   B1, INC2
	STFPDUX	c15,   B1, INC2
	STFPDUX	c16,   B1, INC2
	bdnz	LL(12)
	.align 4
	
LL(15):
	andi.	r0,  N,  3
	ble	LL(19)

	andi.	r0,  N,  2
	ble	LL(17)

	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO1, INC2
	LFPDUX	c03,   AO2, INC2
	LFPDUX	c04,   AO2, INC2

	LFPDUX	c05,   AO3, INC2
	LFPDUX	c06,   AO3, INC2
	LFPDUX	c07,   AO4, INC2
	LFPDUX	c08,   AO4, INC2

	STFPDUX	c01,   B2, INC2
	STFPDUX	c02,   B2, INC2
	STFPDUX	c03,   B2, INC2
	STFPDUX	c04,   B2, INC2
	STFPDUX	c05,   B2, INC2
	STFPDUX	c06,   B2, INC2
	STFPDUX	c07,   B2, INC2
	STFPDUX	c08,   B2, INC2
	.align 4

LL(17):
	andi.	r0,  N,  1
	ble	LL(19)

	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO2, INC2
	LFPDUX	c03,   AO3, INC2
	LFPDUX	c04,   AO4, INC2

	STFPDUX	c01,   B3, INC2
	STFPDUX	c02,   B3, INC2
	STFPDUX	c03,   B3, INC2
	STFPDUX	c04,   B3, INC2
	.align 4

LL(19):
	addic.	J, J, -1
	bgt	LL(10)
	.align 4

LL(20):
	andi.	J,  M,  2
	addi	M4, M4, 16 * SIZE

	ble	LL(30)

	mr	AO1, A
	add	AO2, A,   LDA
	add	A,   AO2, LDA

	sub	B1, B, M4
	addi	B, B, 16 * SIZE

	srawi.	r0,  N,  2
	mtspr	CTR, r0
	ble	LL(23)
	.align 4

LL(22):
	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO1, INC2
	LFPDUX	c03,   AO1, INC2
	LFPDUX	c04,   AO1, INC2

	LFPDUX	c05,   AO2, INC2
	LFPDUX	c06,   AO2, INC2
	LFPDUX	c07,   AO2, INC2
	LFPDUX	c08,   AO2, INC2

	STFPDUX	c01,   B1, M4
	STFPDUX	c02,   B1, INC2
	STFPDUX	c03,   B1, INC2
	STFPDUX	c04,   B1, INC2
	STFPDUX	c05,   B1, INC2
	STFPDUX	c06,   B1, INC2
	STFPDUX	c07,   B1, INC2
	STFPDUX	c08,   B1, INC2
	bdnz	LL(22)
	.align 4
	
LL(23):
	andi.	r0,  N,  2
	ble	LL(24)

	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO1, INC2
	LFPDUX	c03,   AO2, INC2
	LFPDUX	c04,   AO2, INC2

	STFPDUX	c01,   B2, INC2
	STFPDUX	c02,   B2, INC2
	STFPDUX	c03,   B2, INC2
	STFPDUX	c04,   B2, INC2
	.align 4

LL(24):
	andi.	r0,  N,  1
	ble	LL(30)

	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO2, INC2

	STFPDUX	c01,   B3, INC2
	STFPDUX	c02,   B3, INC2
	.align 4

LL(30):
	andi.	J,  M,  1
	addi	M4, M4, 8 * SIZE
	ble	LL(99)

	mr	AO1, A
	sub	B1, B, M4

	srawi.	r0,  N,  2
	mtspr	CTR, r0
	ble	LL(33)
	.align 4

LL(32):
	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO1, INC2
	LFPDUX	c03,   AO1, INC2
	LFPDUX	c04,   AO1, INC2

	STFPDUX	c01,   B1, M4
	STFPDUX	c02,   B1, INC2
	STFPDUX	c03,   B1, INC2
	STFPDUX	c04,   B1, INC2
	bdnz	LL(32)
	.align 4
	
LL(33):
	andi.	r0,  N,  2
	ble	LL(34)

	LFPDUX	c01,   AO1, INC2
	LFPDUX	c02,   AO1, INC2


	STFPDUX	c01,   B2, INC2
	STFPDUX	c02,   B2, INC2
	.align 4

LL(34):
	andi.	r0,  N,  1
	ble	LL(99)

	LFPDUX	c01,   AO1, INC2

	STFPDX	c01,   B3, INC2
	.align 4

LL(99):
	addi	SP, SP, -4

	lwzu	r25,   4(SP)
	lwzu	r26,   4(SP)
	lwzu	r27,   4(SP)

	lwzu	r28,   4(SP)
	lwzu	r29,   4(SP)
	lwzu	r30,   4(SP)
	lwzu	r31,   4(SP)

	subi	SP, SP, 12
	li	r0, 16

	lfpdux	f15, SP, r0
	lfpdux	f14, SP, r0

	addi	SP, SP, 16
	blr
	.align 4

LL(100):
	subi	A, A, SIZE
	srawi.	J,  M,  2
	ble	LL(120)
	.align 4

LL(110):
	mr	AO1, A
	add	AO2, A,   LDA
	add	AO3, AO2, LDA
	add	AO4, AO3, LDA
	add	A,   AO4, LDA

	sub	B1, B, M4
	addi	B, B, 32 * SIZE

	srawi.	r0,  N,  2
	mtspr	CTR, r0
	ble	LL(115)
	.align 4

LL(112):
	LFDUX	c01,   AO1, INC
	LFDUX	c05,   AO2, INC
 	LFDUX	c09,   AO3, INC
	LFDUX	c13,   AO4, INC

	LFSDUX	c01,   AO1, INC
	LFSDUX	c05,   AO2, INC
	LFSDUX	c09,   AO3, INC
	LFSDUX	c13,   AO4, INC

	LFDUX	c02,   AO1, INC
	LFDUX	c06,   AO2, INC
	LFDUX	c10,   AO3, INC
	LFDUX	c14,   AO4, INC

	LFSDUX	c02,   AO1, INC
	LFSDUX	c06,   AO2, INC
	LFSDUX	c10,   AO3, INC
	LFSDUX	c14,   AO4, INC

	LFDUX	c03,   AO1, INC
	LFDUX	c07,   AO2, INC
 	LFDUX	c11,   AO3, INC
	LFDUX	c15,   AO4, INC

	LFSDUX	c03,   AO1, INC
	LFSDUX	c07,   AO2, INC
	LFSDUX	c11,   AO3, INC
	LFSDUX	c15,   AO4, INC

	LFDUX	c04,   AO1, INC
	LFDUX	c08,   AO2, INC
	LFDUX	c12,   AO3, INC
	LFDUX	c16,   AO4, INC

	LFSDUX	c04,   AO1, INC
	LFSDUX	c08,   AO2, INC
	LFSDUX	c12,   AO3, INC
	LFSDUX	c16,   AO4, INC

	STFPDUX	c01,   B1, M4
	STFPDUX	c02,   B1, INC2
	STFPDUX	c03,   B1, INC2
	STFPDUX	c04,   B1, INC2
	STFPDUX	c05,   B1, INC2
	STFPDUX	c06,   B1, INC2
	STFPDUX	c07,   B1, INC2
	STFPDUX	c08,   B1, INC2
	STFPDUX	c09,   B1, INC2
	STFPDUX	c10,   B1, INC2
	STFPDUX	c11,   B1, INC2
	STFPDUX	c12,   B1, INC2
	STFPDUX	c13,   B1, INC2
	STFPDUX	c14,   B1, INC2
	STFPDUX	c15,   B1, INC2
	STFPDUX	c16,   B1, INC2
	bdnz	LL(112)
	.align 4
	
LL(115):
	andi.	r0,  N,  3
	ble	LL(119)

	andi.	r0,  N,  2
	ble	LL(117)

	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC
	LFDUX	c03,   AO1, INC
	LFDUX	c04,   AO1, INC

	LFDUX	c05,   AO2, INC
	LFDUX	c06,   AO2, INC
	LFDUX	c07,   AO2, INC
	LFDUX	c08,   AO2, INC

	LFDUX	c09,   AO3, INC
	LFDUX	c10,   AO3, INC
	LFDUX	c11,   AO3, INC
	LFDUX	c12,   AO3, INC
	fsmfp	c01, c02

	LFDUX	c13,   AO4, INC
	fsmfp	c03, c04
	LFDUX	c14,   AO4, INC
	fsmfp	c05, c06
	LFDUX	c15,   AO4, INC
	fsmfp	c07, c08
	LFDUX	c16,   AO4, INC
	fsmfp	c09, c10

	STFPDUX	c01,   B2, INC2
	fsmfp	c11, c12
	STFPDUX	c03,   B2, INC2
	fsmfp	c13, c14
	STFPDUX	c05,   B2, INC2
	fsmfp	c15, c16
	STFPDUX	c07,   B2, INC2
	STFPDUX	c09,   B2, INC2
	STFPDUX	c11,   B2, INC2
	STFPDUX	c13,   B2, INC2
	STFPDUX	c15,   B2, INC2
	.align 4

LL(117):
	andi.	r0,  N,  1
	ble	LL(119)

	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC
	LFDUX	c03,   AO2, INC
	LFDUX	c04,   AO2, INC
	LFDUX	c05,   AO3, INC
	fsmfp	c01, c02
	LFDUX	c06,   AO3, INC
	fsmfp	c03, c04
	LFDUX	c07,   AO4, INC
	fsmfp	c05, c06
	LFDUX	c08,   AO4, INC
	fsmfp	c07, c08

	STFPDUX	c01,   B3, INC2
	STFPDUX	c03,   B3, INC2
	STFPDUX	c05,   B3, INC2
	STFPDUX	c07,   B3, INC2
	.align 4

LL(119):
	addic.	J, J, -1
	bgt	LL(110)
	.align 4

LL(120):
	andi.	J,  M,  2
	addi	M4, M4, 16 * SIZE

	ble	LL(130)

	mr	AO1, A
	add	AO2, A,   LDA
	add	A,   AO2, LDA

	sub	B1, B, M4
	addi	B, B, 16 * SIZE

	srawi.	r0,  N,  2
	mtspr	CTR, r0
	ble	LL(123)
	.align 4

LL(122):
	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC
	LFDUX	c03,   AO1, INC
	LFDUX	c04,   AO1, INC
	LFDUX	c05,   AO1, INC
	LFDUX	c06,   AO1, INC
	LFDUX	c07,   AO1, INC
	LFDUX	c08,   AO1, INC

	LFDUX	c09,   AO2, INC
	LFDUX	c10,   AO2, INC
	LFDUX	c11,   AO2, INC
	LFDUX	c12,   AO2, INC
	fsmfp	c01, c02
	LFDUX	c13,   AO2, INC
	fsmfp	c03, c04
	LFDUX	c14,   AO2, INC
	fsmfp	c05, c06
	LFDUX	c15,   AO2, INC
	fsmfp	c07, c08
	LFDUX	c16,   AO2, INC
	fsmfp	c09, c10

	STFPDUX	c01,   B1, M4
	fsmfp	c11, c12
	STFPDUX	c03,   B1, INC2
	fsmfp	c13, c14
	STFPDUX	c05,   B1, INC2
	fsmfp	c15, c16
	STFPDUX	c07,   B1, INC2
	STFPDUX	c09,   B1, INC2
	STFPDUX	c11,   B1, INC2
	STFPDUX	c13,   B1, INC2
	STFPDUX	c15,   B1, INC2
	bdnz	LL(122)
	.align 4
	
LL(123):
	andi.	r0,  N,  2
	ble	LL(124)

	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC
	LFDUX	c03,   AO1, INC
	LFDUX	c04,   AO1, INC

	LFDUX	c05,   AO2, INC
	fsmfp	c01, c02
	LFDUX	c06,   AO2, INC
	fsmfp	c03, c04
	LFDUX	c07,   AO2, INC
	fsmfp	c05, c06
	LFDUX	c08,   AO2, INC
	fsmfp	c07, c08

	STFPDUX	c01,   B2, INC2
	STFPDUX	c03,   B2, INC2
	STFPDUX	c05,   B2, INC2
	STFPDUX	c07,   B2, INC2
	.align 4

LL(124):
	andi.	r0,  N,  1
	ble	LL(130)

	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC

	LFDUX	c03,   AO2, INC
	LFDUX	c04,   AO2, INC

	fsmfp	c01, c02
	fsmfp	c03, c04

	STFPDUX	c01,   B3, INC2
	STFPDUX	c03,   B3, INC2
	.align 4

LL(130):
	andi.	J,  M,  1
	addi	M4, M4, 8 * SIZE
	ble	LL(999)

	mr	AO1, A
	sub	B1, B, M4

	srawi.	r0,  N,  2
	mtspr	CTR, r0
	ble	LL(133)
	.align 4

LL(132):
	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC
	LFDUX	c03,   AO1, INC
	LFDUX	c04,   AO1, INC
	LFDUX	c05,   AO1, INC
	fsmfp	c01, c02
	LFDUX	c06,   AO1, INC
	fsmfp	c03, c04
	LFDUX	c07,   AO1, INC
	fsmfp	c05, c06
	LFDUX	c08,   AO1, INC
	fsmfp	c07, c08

	STFPDUX	c01,   B1, M4
	STFPDUX	c03,   B1, INC2
	STFPDUX	c05,   B1, INC2
	STFPDUX	c07,   B1, INC2
	bdnz	LL(132)
	.align 4
	
LL(133):
	andi.	r0,  N,  2
	ble	LL(134)

	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC
	LFDUX	c03,   AO1, INC
	LFDUX	c04,   AO1, INC

	fsmfp	c01, c02
	fsmfp	c03, c04

	STFPDUX	c01,   B2, INC2
	STFPDUX	c03,   B2, INC2
	.align 4

LL(134):
	andi.	r0,  N,  1
	ble	LL(999)

	LFDUX	c01,   AO1, INC
	LFDUX	c02,   AO1, INC

	fsmfp	c01, c02
	STFPDX	c01,   B3, INC2
	.align 4

LL(999):
	addi	SP, SP, -4

	lwzu	r25,   4(SP)
	lwzu	r26,   4(SP)
	lwzu	r27,   4(SP)

	lwzu	r28,   4(SP)
	lwzu	r29,   4(SP)
	lwzu	r30,   4(SP)
	lwzu	r31,   4(SP)

	subi	SP, SP, 12
	li	r0, 16

	lfpdux	f15, SP, r0
	lfpdux	f14, SP, r0

	addi	SP, SP, 16
	blr



	EPILOGUE
