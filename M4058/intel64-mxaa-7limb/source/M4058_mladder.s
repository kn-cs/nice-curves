/*
+-----------------------------------------------------------------------------+
| This code corresponds to the paper https://eprint.iacr.org/2019/1259.pdf by |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2020, Kaushik Nath and Palash Sarkar.                         |
|                                                                             |
| Permission to use this code is granted.                          	      |
|                                                                             |
| Redistribution and use in source and binary forms, with or without          |
| modification, are permitted provided that the following conditions are      |
| met:                                                                        |
|                                                                             |
| * Redistributions of source code must retain the above copyright notice,    |
|   this list of conditions and the following disclaimer.                     |
|                                                                             |
| * Redistributions in binary form must reproduce the above copyright         |
|   notice, this list of conditions and the following disclaimer in the       |
|   documentation and/or other materials provided with the distribution.      |
|                                                                             |
| * The names of the contributors may not be used to endorse or promote       |
|   products derived from this software without specific prior written        |
|   permission.                                                               |
+-----------------------------------------------------------------------------+
| THIS SOFTWARE IS PROVIDED BY THE AUTHORS ""AS IS"" AND ANY EXPRESS OR       |
| IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   |
| OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.     |
| IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,      |
| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT    |
| NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   |
| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       |
| THEORY LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING |
| NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,| 
| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          |
+-----------------------------------------------------------------------------+
*/

.p2align 5
.globl M4058_mladder
M4058_mladder:

movq 	%rsp, %r11
subq 	$648, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X1 ← XP, X3 ← XP
movq	0(%rsi), %r8
movq	%r8, 72(%rsp)
movq	%r8, 240(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 248(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 256(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 264(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 272(%rsp)
movq	40(%rsi), %r8
movq	%r8, 112(%rsp)
movq	%r8, 280(%rsp)
movq	48(%rsi), %r8
movq	%r8, 120(%rsp)
movq	%r8, 288(%rsp)  

// X2 ← 1
movq	$1, 128(%rsp)
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)  

// Z2 ← 0
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)  

// Z3 ← 1
movq	$1, 296(%rsp)
movq	$0, 304(%rsp)
movq	$0, 312(%rsp)
movq	$0, 320(%rsp)
movq	$0, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp)

movq    $55, 360(%rsp)
movb	$3, 352(%rsp)
movb    $0, 354(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:

addq    360(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 356(%rsp)

.L2:

/* 
 * Montgomery ladder step
 *
 * T1 ← X2 + Z2
 * T2 ← X2 - Z2
 * T3 ← X3 + Z3
 * T4 ← X3 - Z3
 * Z3 ← T2 · T3
 * X3 ← T1 · T4
 *
 * bit ← n[i]
 * select ← bit ⊕ prevbit
 * prevbit ← bit
 * CSelect(T1,T3,select): if (select == 1) {T1 = T3}
 * CSelect(T2,T4,select): if (select == 1) {T2 = T4}
 *
 * T2 ← T2^2
 * T1 ← T1^2
 * X3 ← X3 + Z3
 * Z3 ← X3 - Z3
 * Z3 ← Z3^2
 * X3 ← X3^2
 * T3 ← T1 - T2
 * T4 ← ((A + 2)/4) · T3
 * T4 ← T4 + T2
 * X2 ← T1 · T2
 * Z2 ← T3 · T4
 * Z3 ← Z3 · X1
 *
 */

// X2
movq    128(%rsp), %r8
movq    136(%rsp), %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15
movq    %r14, %rcx

// T1 ← X2 + Z2
addq    184(%rsp), %r8
adcq    192(%rsp), %r9
adcq    200(%rsp), %r10
adcq    208(%rsp), %r11
adcq    216(%rsp), %r12
adcq    224(%rsp), %r13
adcq    232(%rsp), %r14

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// T2 ← X2 - Z2
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %rcx

subq    184(%rsp), %rax
sbbq    192(%rsp), %rbx
sbbq    200(%rsp), %rbp
sbbq    208(%rsp), %rsi
sbbq    216(%rsp), %rdi
sbbq    224(%rsp), %r15
sbbq    232(%rsp), %rcx

movq    %rax, 424(%rsp)
movq    %rbx, 432(%rsp)
movq    %rbp, 440(%rsp)
movq    %rsi, 448(%rsp)
movq    %rdi, 456(%rsp)
movq    %r15, 464(%rsp)
movq    %rcx, 472(%rsp)

// X3
movq    240(%rsp), %r8
movq    248(%rsp), %r9
movq    256(%rsp), %r10
movq    264(%rsp), %r11
movq    272(%rsp), %r12
movq    280(%rsp), %r13
movq    288(%rsp), %r14

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15
movq    %r14, %rcx

// T3 ← X3 + Z3
addq    296(%rsp), %r8
adcq    304(%rsp), %r9
adcq    312(%rsp), %r10
adcq    320(%rsp), %r11
adcq    328(%rsp), %r12
adcq    336(%rsp), %r13
adcq    344(%rsp), %r14

movq    %r8,  480(%rsp)
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

// T4 ← X3 - Z3
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %rcx

subq    296(%rsp), %rax
sbbq    304(%rsp), %rbx
sbbq    312(%rsp), %rbp
sbbq    320(%rsp), %rsi
sbbq    328(%rsp), %rdi
sbbq    336(%rsp), %r15
sbbq    344(%rsp), %rcx

movq    %rax, 536(%rsp)
movq    %rbx, 544(%rsp)
movq    %rbp, 552(%rsp)
movq    %rsi, 560(%rsp)
movq    %rdi, 568(%rsp)
movq    %r15, 576(%rsp)
movq    %rcx, 584(%rsp)

// Z3 ← T2 · T3
movq    424(%rsp), %rdx  

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    496(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    504(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    512(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    520(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    528(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 592(%rsp)
movq    %r9, 600(%rsp)

movq    432(%rsp), %rdx

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    496(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    504(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    512(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    520(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    528(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    600(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 600(%rsp)
movq    %r9, 608(%rsp)

movq    440(%rsp), %rdx

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %r10, %rax
addq    %r10, %r9

mulx    496(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    504(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    512(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    520(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    528(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    608(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 608(%rsp)
movq    %r9, 616(%rsp)

movq    448(%rsp), %rdx

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %r11, %rax
addq    %r11, %r9

mulx    496(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    504(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    512(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    520(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    528(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    616(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 616(%rsp)
movq    %r9, 624(%rsp)

movq    456(%rsp), %rdx

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %r12, %rax
addq    %r12, %r9

mulx    496(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    504(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    512(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    520(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    528(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    624(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 624(%rsp)
movq    %r9, 632(%rsp)

movq    464(%rsp), %rdx

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %r13, %rax
addq    %r13, %r9

mulx    496(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    504(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    512(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    520(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    528(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    632(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 632(%rsp)
movq    %r9, 640(%rsp)

movq    472(%rsp), %rdx

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %r14, %rax
addq    %r14, %r9

mulx    496(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    504(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    512(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    520(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    528(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    640(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    $272, %rdx

mulx    %r9,  %r9, %rbx
mulx    %rcx, %rcx, %r15
addq    %rbx, %rcx

mulx    %r10, %r10, %rbx
adcq    %r15, %r10

mulx    %r11, %r11, %r15
adcq    %rbx, %r11

mulx    %r12, %r12, %rbx
adcq    %r15, %r12

mulx    %r13, %r13, %r15
adcq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %r15, %r14
adcq    $0, %rbx

addq    592(%rsp), %r9
adcq    600(%rsp), %rcx
adcq    608(%rsp), %r10
adcq    616(%rsp), %r11
adcq    624(%rsp), %r12
adcq    632(%rsp), %r13
adcq    %r8, %r14
adcq    $0,  %rbx

shld    $4, %r14, %rbx
andq	mask60, %r14

imul    $17, %rbx, %rbx
addq    %rbx, %r9
adcq    $0, %rcx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq    %r9,  296(%rsp)
movq    %rcx, 304(%rsp)
movq    %r10, 312(%rsp)
movq    %r11, 320(%rsp)
movq    %r12, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)

// X3 ← T1 · T4
movq    536(%rsp), %rdx  

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 592(%rsp)
movq    %r9, 600(%rsp)

movq    544(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    392(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    600(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 600(%rsp)
movq    %r9, 608(%rsp)

movq    552(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r10, %rax
addq    %r10, %r9

mulx    384(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    392(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    400(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    408(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    416(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    608(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 608(%rsp)
movq    %r9, 616(%rsp)

movq    560(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r11, %rax
addq    %r11, %r9

mulx    384(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    392(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    400(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    408(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    416(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    616(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 616(%rsp)
movq    %r9, 624(%rsp)

movq    568(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r12, %rax
addq    %r12, %r9

mulx    384(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    392(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    400(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    408(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    416(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    624(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 624(%rsp)
movq    %r9, 632(%rsp)

movq    576(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r13, %rax
addq    %r13, %r9

mulx    384(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    392(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    400(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    408(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    416(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    632(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 632(%rsp)
movq    %r9, 640(%rsp)

movq    584(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r14, %rax
addq    %r14, %r9

mulx    384(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    392(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    400(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    408(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    416(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    640(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    $272, %rdx

mulx    %r9,  %r9, %rbx
mulx    %rcx, %rcx, %r15
addq    %rbx, %rcx

mulx    %r10, %r10, %rbx
adcq    %r15, %r10

mulx    %r11, %r11, %r15
adcq    %rbx, %r11

mulx    %r12, %r12, %rbx
adcq    %r15, %r12

mulx    %r13, %r13, %r15
adcq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %r15, %r14
adcq    $0, %rbx

addq    592(%rsp), %r9
adcq    600(%rsp), %rcx
adcq    608(%rsp), %r10
adcq    616(%rsp), %r11
adcq    624(%rsp), %r12
adcq    632(%rsp), %r13
adcq    %r8, %r14
adcq    $0,  %rbx

shld    $4, %r14, %rbx
andq	mask60, %r14

imul    $17, %rbx, %rbx
addq    %rbx, %r9
adcq    $0, %rcx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq    %r9,  240(%rsp)
movq    %rcx, 248(%rsp)
movq    %r10, 256(%rsp)
movq    %r11, 264(%rsp)
movq    %r12, 272(%rsp)
movq    %r13, 280(%rsp)
movq    %r14, 288(%rsp)

movb	352(%rsp), %cl
movb	356(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    354(%rsp), %bl
movb    %cl, 354(%rsp)

cmpb    $1, %bl

// CSelect(T1,T3,select)
movq    368(%rsp), %r8
movq    376(%rsp), %r9
movq    384(%rsp), %r10
movq    392(%rsp), %r11
movq    400(%rsp), %r12
movq    408(%rsp), %r13
movq    416(%rsp), %r14

movq    480(%rsp), %r15
movq    488(%rsp), %rax
movq    496(%rsp), %rbx
movq    504(%rsp), %rcx
movq    512(%rsp), %rdx
movq    520(%rsp), %rbp
movq    528(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// CSelect(T2,T4,select)
movq    424(%rsp), %r8
movq    432(%rsp), %r9
movq    440(%rsp), %r10
movq    448(%rsp), %r11
movq    456(%rsp), %r12
movq    464(%rsp), %r13
movq    472(%rsp), %r14

movq    536(%rsp), %r15
movq    544(%rsp), %rax
movq    552(%rsp), %rbx
movq    560(%rsp), %rcx
movq    568(%rsp), %rdx
movq    576(%rsp), %rbp
movq    584(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  424(%rsp)
movq    %r9,  432(%rsp)
movq    %r10, 440(%rsp)
movq    %r11, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T2 ← T2^2
movq    424(%rsp), %rdx
    
mulx    432(%rsp), %r9, %r10
mulx    440(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    448(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    456(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    464(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    472(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    432(%rsp), %rdx

mulx    440(%rsp), %rax, %rbx
mulx    448(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    456(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    464(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    472(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    440(%rsp), %rdx

mulx    448(%rsp), %rax, %rbx
mulx    456(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    464(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    472(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    448(%rsp), %rdx

mulx    456(%rsp), %rax, %rbx
mulx    464(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    472(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    456(%rsp), %rdx

mulx    464(%rsp), %rax, %rbx
mulx    472(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    464(%rsp), %rdx

mulx    472(%rsp), %rax, %rbx
addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  592(%rsp)
movq    %r10, 600(%rsp)

movq    424(%rsp), %rdx
mulx    %rdx, %rdi, %r10
addq    592(%rsp), %r10
movq    %r10, 592(%rsp)

movq    432(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    600(%rsp), %r9
adcq    %r10, %r11
movq    %r9,  600(%rsp)

movq    440(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    448(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    456(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    464(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    472(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    $272, %rdx

mulx    %r15,  %r15, %r9
mulx    %rcx, %rcx, %r10
addq    %r9, %rcx

mulx    %r8, %r8, %r9
adcq    %r10, %r8

mulx    %rsi, %rsi, %r10
adcq    %r9, %rsi

mulx    %rbp, %rbp, %r9
adcq    %r10, %rbp

mulx    %rbx, %rbx, %r10
adcq    %r9, %rbx

mulx    %rax, %rax, %r9
adcq    %r10, %rax
adcq    $0, %r9

addq    %rdi, %r15
adcq    592(%rsp), %rcx
adcq    600(%rsp), %r8
adcq    %r11, %rsi
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0,   %r9

shld    $4, %r14, %r9
andq	mask60, %r14

imul    $17, %r9, %r9
addq    %r9, %r15
adcq    $0, %rcx
adcq    $0, %r8
adcq    $0, %rsi
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq    %r15, 424(%rsp)
movq    %rcx, 432(%rsp)
movq    %r8,  440(%rsp)
movq    %rsi, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T1 ← T1^2
movq    368(%rsp), %rdx
    
mulx    376(%rsp), %r9, %r10
mulx    384(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    376(%rsp), %rdx

mulx    384(%rsp), %rax, %rbx
mulx    392(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    384(%rsp), %rdx

mulx    392(%rsp), %rax, %rbx
mulx    400(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    408(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    416(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    392(%rsp), %rdx

mulx    400(%rsp), %rax, %rbx
mulx    408(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    416(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    400(%rsp), %rdx

mulx    408(%rsp), %rax, %rbx
mulx    416(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    408(%rsp), %rdx

mulx    416(%rsp), %rax, %rbx
addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  592(%rsp)
movq    %r10, 600(%rsp)

movq    368(%rsp), %rdx
mulx    %rdx, %rdi, %r10
addq    592(%rsp), %r10
movq    %r10, 592(%rsp)

movq    376(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    600(%rsp), %r9
adcq    %r10, %r11
movq    %r9,  600(%rsp)

movq    384(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    392(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    400(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    408(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    416(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    $272, %rdx

mulx    %r15,  %r15, %r9
mulx    %rcx, %rcx, %r10
addq    %r9, %rcx

mulx    %r8, %r8, %r9
adcq    %r10, %r8

mulx    %rsi, %rsi, %r10
adcq    %r9, %rsi

mulx    %rbp, %rbp, %r9
adcq    %r10, %rbp

mulx    %rbx, %rbx, %r10
adcq    %r9, %rbx

mulx    %rax, %rax, %r9
adcq    %r10, %rax
adcq    $0, %r9

addq    %rdi, %r15
adcq    592(%rsp), %rcx
adcq    600(%rsp), %r8
adcq    %r11, %rsi
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0,   %r9

shld    $4, %r14, %r9
andq	mask60, %r14

imul    $17, %r9, %r9
addq    %r9, %r15
adcq    $0, %rcx
adcq    $0, %r8
adcq    $0, %rsi
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq    %r15, 368(%rsp)
movq    %rcx, 376(%rsp)
movq    %r8,  384(%rsp)
movq    %rsi, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// X3
movq    240(%rsp), %r8
movq    248(%rsp), %r9
movq    256(%rsp), %r10
movq    264(%rsp), %r11
movq    272(%rsp), %r12
movq    280(%rsp), %r13
movq    288(%rsp), %r14

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15
movq    %r14, %rcx

// X3 ← X3 + Z3
addq    296(%rsp), %r8
adcq    304(%rsp), %r9
adcq    312(%rsp), %r10
adcq    320(%rsp), %r11
adcq    328(%rsp), %r12
adcq    336(%rsp), %r13
adcq    344(%rsp), %r14

movq    %r8,  240(%rsp)
movq    %r9,  248(%rsp)
movq    %r10, 256(%rsp)
movq    %r11, 264(%rsp)
movq    %r12, 272(%rsp)
movq    %r13, 280(%rsp)
movq    %r14, 288(%rsp)

// Z3 ← X3 - Z3
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %rcx

subq    296(%rsp), %rax
sbbq    304(%rsp), %rbx
sbbq    312(%rsp), %rbp
sbbq    320(%rsp), %rsi
sbbq    328(%rsp), %rdi
sbbq    336(%rsp), %r15
sbbq    344(%rsp), %rcx

movq    %rax, 296(%rsp)
movq    %rbx, 304(%rsp)
movq    %rbp, 312(%rsp)
movq    %rsi, 320(%rsp)
movq    %rdi, 328(%rsp)
movq    %r15, 336(%rsp)
movq    %rcx, 344(%rsp)

// Z3 ← Z3^2
movq    296(%rsp), %rdx
    
mulx    304(%rsp), %r9, %r10
mulx    312(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    320(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    328(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    336(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    344(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    304(%rsp), %rdx

mulx    312(%rsp), %rax, %rbx
mulx    320(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    328(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    336(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    344(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    312(%rsp), %rdx

mulx    320(%rsp), %rax, %rbx
mulx    328(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    336(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    344(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    320(%rsp), %rdx

mulx    328(%rsp), %rax, %rbx
mulx    336(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    344(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    328(%rsp), %rdx

mulx    336(%rsp), %rax, %rbx
mulx    344(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    336(%rsp), %rdx

mulx    344(%rsp), %rax, %rbx
addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  592(%rsp)
movq    %r10, 600(%rsp)

movq    296(%rsp), %rdx
mulx    %rdx, %rdi, %r10
addq    592(%rsp), %r10
movq    %r10, 592(%rsp)

movq    304(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    600(%rsp), %r9
adcq    %r10, %r11
movq    %r9,  600(%rsp)

movq    312(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    320(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    328(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    336(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    344(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    $272, %rdx

mulx    %r15,  %r15, %r9
mulx    %rcx, %rcx, %r10
addq    %r9, %rcx

mulx    %r8, %r8, %r9
adcq    %r10, %r8

mulx    %rsi, %rsi, %r10
adcq    %r9, %rsi

mulx    %rbp, %rbp, %r9
adcq    %r10, %rbp

mulx    %rbx, %rbx, %r10
adcq    %r9, %rbx

mulx    %rax, %rax, %r9
adcq    %r10, %rax
adcq    $0, %r9

addq    %rdi, %r15
adcq    592(%rsp), %rcx
adcq    600(%rsp), %r8
adcq    %r11, %rsi
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0,   %r9

shld    $4, %r14, %r9
andq	mask60, %r14

imul    $17, %r9, %r9
addq    %r9, %r15
adcq    $0, %rcx
adcq    $0, %r8
adcq    $0, %rsi
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq    %r15, 296(%rsp)
movq    %rcx, 304(%rsp)
movq    %r8,  312(%rsp)
movq    %rsi, 320(%rsp)
movq    %r12, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)

// X3 ← X3^2
movq    240(%rsp), %rdx
    
mulx    248(%rsp), %r9, %r10
mulx    256(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    264(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    272(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    280(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    288(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    248(%rsp), %rdx

mulx    256(%rsp), %rax, %rbx
mulx    264(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    272(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    280(%rsp), %rcx, %r8
adcq    %rcx, %rsi

mulx    288(%rsp), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    256(%rsp), %rdx

mulx    264(%rsp), %rax, %rbx
mulx    272(%rsp), %r8, %rbp
addq    %r8, %rbx

mulx    280(%rsp), %r8, %rsi
adcq    %r8, %rbp

mulx    288(%rsp), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    264(%rsp), %rdx

mulx    272(%rsp), %rax, %rbx
mulx    280(%rsp), %rsi, %rbp
addq    %rsi, %rbx

mulx    288(%rsp), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    272(%rsp), %rdx

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    280(%rsp), %rdx

mulx    288(%rsp), %rax, %rbx
addq    %rax, %rbp
adcq    $0,   %rbx

movq    $0, %rax
shld    $1, %rbx, %rax
shld    $1, %rbp, %rbx
shld    $1, %rsi, %rbp
shld    $1, %r8,  %rsi
shld    $1, %rcx, %r8
shld    $1, %r15, %rcx
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    %r9,  592(%rsp)
movq    %r10, 600(%rsp)

movq    240(%rsp), %rdx
mulx    %rdx, %rdi, %r10
addq    592(%rsp), %r10
movq    %r10, 592(%rsp)

movq    248(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    600(%rsp), %r9
adcq    %r10, %r11
movq    %r9,  600(%rsp)

movq    256(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    264(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    272(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    280(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    288(%rsp), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rbx
adcq    %r10, %rax

movq    $272, %rdx

mulx    %r15,  %r15, %r9
mulx    %rcx, %rcx, %r10
addq    %r9, %rcx

mulx    %r8, %r8, %r9
adcq    %r10, %r8

mulx    %rsi, %rsi, %r10
adcq    %r9, %rsi

mulx    %rbp, %rbp, %r9
adcq    %r10, %rbp

mulx    %rbx, %rbx, %r10
adcq    %r9, %rbx

mulx    %rax, %rax, %r9
adcq    %r10, %rax
adcq    $0, %r9

addq    %rdi, %r15
adcq    592(%rsp), %rcx
adcq    600(%rsp), %r8
adcq    %r11, %rsi
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0,   %r9

shld    $4, %r14, %r9
andq	mask60, %r14

imul    $17, %r9, %r9
addq    %r9, %r15
adcq    $0, %rcx
adcq    $0, %r8
adcq    $0, %rsi
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

// update X3
movq    %r15, 240(%rsp) 
movq    %rcx, 248(%rsp)
movq    %r8,  256(%rsp)
movq    %rsi, 264(%rsp)
movq    %r12, 272(%rsp)
movq    %r13, 280(%rsp)
movq    %r14, 288(%rsp)

// T3 ← T1 - T2
movq    368(%rsp), %r8
movq    376(%rsp), %r9
movq    384(%rsp), %r10
movq    392(%rsp), %r11
movq    400(%rsp), %r12
movq    408(%rsp), %r13
movq    416(%rsp), %r14

addq    _4p0,   %r8
adcq    _4p1_5, %r9
adcq    _4p1_5, %r10
adcq    _4p1_5, %r11
adcq    _4p1_5, %r12
adcq    _4p1_5, %r13
adcq    _4p6,   %r14

subq    424(%rsp), %r8
sbbq    432(%rsp), %r9
sbbq    440(%rsp), %r10
sbbq    448(%rsp), %r11
sbbq    456(%rsp), %r12
sbbq    464(%rsp), %r13
sbbq    472(%rsp), %r14

movq    %r8,  480(%rsp) 
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

// T4 ← ((A + 2)/4) · T3
movq    a24, %rdx

mulx    %r8, %r8, %rcx
mulx    %r9, %r9, %rax
addq    %rcx, %r9

mulx    %r10, %r10, %rcx
adcq    %rax, %r10

mulx    %r11, %r11, %rax
adcq    %rcx, %r11

mulx    %r12, %r12, %rcx
adcq    %rax, %r12

mulx    %r13, %r13, %rax
adcq    %rcx, %r13

mulx    %r14, %r14, %r15
adcq    %rax, %r14
adcq    $0, %r15

shld    $4, %r14, %r15
andq    mask60, %r14

imul    $17, %r15, %r15
addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

// T4 ← T4 + T2
addq    424(%rsp), %r8
adcq    432(%rsp), %r9
adcq    440(%rsp), %r10
adcq    448(%rsp), %r11
adcq    456(%rsp), %r12
adcq    464(%rsp), %r13
adcq    472(%rsp), %r14

movq    %r8,  536(%rsp) 
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)
movq    %r11, 560(%rsp)
movq    %r12, 568(%rsp)
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)

// X2 ← T1 · T2
movq    424(%rsp), %rdx  

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 592(%rsp)
movq    %r9, 600(%rsp)

movq    432(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    384(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    392(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    400(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    408(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    416(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    600(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 600(%rsp)
movq    %r9, 608(%rsp)

movq    440(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r10, %rax
addq    %r10, %r9

mulx    384(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    392(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    400(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    408(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    416(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    608(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 608(%rsp)
movq    %r9, 616(%rsp)

movq    448(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r11, %rax
addq    %r11, %r9

mulx    384(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    392(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    400(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    408(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    416(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    616(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 616(%rsp)
movq    %r9, 624(%rsp)

movq    456(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r12, %rax
addq    %r12, %r9

mulx    384(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    392(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    400(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    408(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    416(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    624(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 624(%rsp)
movq    %r9, 632(%rsp)

movq    464(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r13, %rax
addq    %r13, %r9

mulx    384(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    392(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    400(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    408(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    416(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    632(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 632(%rsp)
movq    %r9, 640(%rsp)

movq    472(%rsp), %rdx

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %r14, %rax
addq    %r14, %r9

mulx    384(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    392(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    400(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    408(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    416(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    640(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    $272, %rdx

mulx    %r9,  %r9, %rbx
mulx    %rcx, %rcx, %r15
addq    %rbx, %rcx

mulx    %r10, %r10, %rbx
adcq    %r15, %r10

mulx    %r11, %r11, %r15
adcq    %rbx, %r11

mulx    %r12, %r12, %rbx
adcq    %r15, %r12

mulx    %r13, %r13, %r15
adcq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %r15, %r14
adcq    $0, %rbx

addq    592(%rsp), %r9
adcq    600(%rsp), %rcx
adcq    608(%rsp), %r10
adcq    616(%rsp), %r11
adcq    624(%rsp), %r12
adcq    632(%rsp), %r13
adcq    %r8, %r14
adcq    $0,  %rbx

shld    $4, %r14, %rbx
andq	mask60, %r14

imul    $17, %rbx, %rbx
addq    %rbx, %r9
adcq    $0, %rcx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

// update X2
movq    %r9,  128(%rsp) 
movq    %rcx, 136(%rsp)
movq    %r10, 144(%rsp)
movq    %r11, 152(%rsp)
movq    %r12, 160(%rsp)
movq    %r13, 168(%rsp)
movq    %r14, 176(%rsp)

// Z2 ← T3 · T4
movq    480(%rsp), %rdx  

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    552(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    560(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    568(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    576(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    584(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 592(%rsp)
movq    %r9, 600(%rsp)

movq    488(%rsp), %rdx

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    552(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    560(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    568(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    576(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    584(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    600(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 600(%rsp)
movq    %r9, 608(%rsp)

movq    496(%rsp), %rdx

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %r10, %rax
addq    %r10, %r9

mulx    552(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    560(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    568(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    576(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    584(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    608(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 608(%rsp)
movq    %r9, 616(%rsp)

movq    504(%rsp), %rdx

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %r11, %rax
addq    %r11, %r9

mulx    552(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    560(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    568(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    576(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    584(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    616(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 616(%rsp)
movq    %r9, 624(%rsp)

movq    512(%rsp), %rdx

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %r12, %rax
addq    %r12, %r9

mulx    552(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    560(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    568(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    576(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    584(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    624(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 624(%rsp)
movq    %r9, 632(%rsp)

movq    520(%rsp), %rdx

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %r13, %rax
addq    %r13, %r9

mulx    552(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    560(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    568(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    576(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    584(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    632(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 632(%rsp)
movq    %r9, 640(%rsp)

movq    528(%rsp), %rdx

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %r14, %rax
addq    %r14, %r9

mulx    552(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    560(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    568(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    576(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    584(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    640(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    $272, %rdx

mulx    %r9,  %r9, %rbx
mulx    %rcx, %rcx, %r15
addq    %rbx, %rcx

mulx    %r10, %r10, %rbx
adcq    %r15, %r10

mulx    %r11, %r11, %r15
adcq    %rbx, %r11

mulx    %r12, %r12, %rbx
adcq    %r15, %r12

mulx    %r13, %r13, %r15
adcq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %r15, %r14
adcq    $0, %rbx

addq    592(%rsp), %r9
adcq    600(%rsp), %rcx
adcq    608(%rsp), %r10
adcq    616(%rsp), %r11
adcq    624(%rsp), %r12
adcq    632(%rsp), %r13
adcq    %r8, %r14
adcq    $0,  %rbx

shld    $4, %r14, %rbx
andq	mask60, %r14

imul    $17, %rbx, %rbx
addq    %rbx, %r9
adcq    $0, %rcx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

// update Z2
movq    %r9,  184(%rsp) 
movq    %rcx, 192(%rsp)
movq    %r10, 200(%rsp)
movq    %r11, 208(%rsp)
movq    %r12, 216(%rsp)
movq    %r13, 224(%rsp)
movq    %r14, 232(%rsp)

// Z3 ← Z3 · X1
movq    296(%rsp), %rdx  

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    88(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    96(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    104(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    112(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    120(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 592(%rsp)
movq    %r9, 600(%rsp)

movq    304(%rsp), %rdx

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    88(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    96(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    104(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    112(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    120(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    600(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 600(%rsp)
movq    %r9, 608(%rsp)

movq    312(%rsp), %rdx

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %r10, %rax
addq    %r10, %r9

mulx    88(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    96(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    104(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    112(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    120(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    608(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 608(%rsp)
movq    %r9, 616(%rsp)

movq    320(%rsp), %rdx

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %r11, %rax
addq    %r11, %r9

mulx    88(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    96(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    104(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    112(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    120(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    616(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 616(%rsp)
movq    %r9, 624(%rsp)

movq    328(%rsp), %rdx

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %r12, %rax
addq    %r12, %r9

mulx    88(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    96(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    104(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    112(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    120(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    624(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 624(%rsp)
movq    %r9, 632(%rsp)

movq    336(%rsp), %rdx

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %r13, %rax
addq    %r13, %r9

mulx    88(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    96(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    104(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    112(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    120(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    632(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 632(%rsp)
movq    %r9, 640(%rsp)

movq    344(%rsp), %rdx

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %r14, %rax
addq    %r14, %r9

mulx    88(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    96(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    104(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    112(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    120(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    640(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    $272, %rdx

mulx    %r9,  %r9, %rbx
mulx    %rcx, %rcx, %r15
addq    %rbx, %rcx

mulx    %r10, %r10, %rbx
adcq    %r15, %r10

mulx    %r11, %r11, %r15
adcq    %rbx, %r11

mulx    %r12, %r12, %rbx
adcq    %r15, %r12

mulx    %r13, %r13, %r15
adcq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %r15, %r14
adcq    $0, %rbx

addq    592(%rsp), %r9
adcq    600(%rsp), %rcx
adcq    608(%rsp), %r10
adcq    616(%rsp), %r11
adcq    624(%rsp), %r12
adcq    632(%rsp), %r13
adcq    %r8, %r14
adcq    $0,  %rbx

shld    $4, %r14, %rbx
andq	mask60, %r14

imul    $17, %rbx, %rbx
addq    %rbx, %r9
adcq    $0, %rcx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

// update Z3
movq    %r9,  296(%rsp) 
movq    %rcx, 304(%rsp)
movq    %r10, 312(%rsp)
movq    %r11, 320(%rsp)
movq    %r12, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)

movb    352(%rsp), %cl
subb    $1, %cl
movb    %cl, 352(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 352(%rsp)
movq    64(%rsp), %rax
movq    360(%rsp), %r15
subq    $1, %r15
movq    %r15, 360(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    128(%rsp),  %r8 
movq    136(%rsp),  %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)

movq    184(%rsp),  %r8 
movq    192(%rsp),  %r9
movq    200(%rsp), %r10
movq    208(%rsp), %r11
movq    216(%rsp), %r12
movq    224(%rsp), %r13
movq    232(%rsp), %r14

// store final value of Z2
movq    %r8,   56(%rdi) 
movq    %r9,   64(%rdi)
movq    %r10,  72(%rdi)
movq    %r11,  80(%rdi)
movq    %r12,  88(%rdi)
movq    %r13,  96(%rdi)
movq    %r14, 104(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
