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
.globl M4698_mladder
M4698_mladder:

movq 	%rsp, %r11
subq 	$448, %rsp

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
movq	%r8, 192(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 200(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 208(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 216(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 224(%rsp)

// X2 ← 1
movq	$1, 112(%rsp)
movq	$0, 120(%rsp)
movq	$0, 128(%rsp)
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)

// Z2 ← 0
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)

// Z3 ← 1
movq	$1, 232(%rsp)
movq	$0, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)
movq	$0, 264(%rsp)

movq    $31, 440(%rsp)
movb	$2, 432(%rsp)
movb    $0, 434(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:

addq    440(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 436(%rsp)

.L2:

/* 
 * Montgomery ladder step
 *
 * The idea of multiplication with a small constant is taken from the 64-bit implementation 
 * "amd64-51" of the work "https://link.springer.com/article/10.1007/s13389-012-0027-1"
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
movq    112(%rsp), %r8  
movq    120(%rsp), %r9
movq    128(%rsp), %r10
movq    136(%rsp), %r11
movq    144(%rsp), %r12

// copy X2
movq    %r8,  %r13
movq    %r9,  %r14
movq    %r10, %r15
movq    %r11, %rax
movq    %r12, %rbx

// T1 ← X2 + Z2
addq    152(%rsp), %r8
adcq    160(%rsp), %r9
adcq    168(%rsp), %r10
adcq    176(%rsp), %r11
adcq    184(%rsp), %r12

movq    %r8,  272(%rsp)
movq    %r9,  280(%rsp)
movq    %r10, 288(%rsp)
movq    %r11, 296(%rsp)
movq    %r12, 304(%rsp)

// T2 ← X2 - Z2
addq    _2p0,   %r13
adcq    _2p123, %r14
adcq    _2p123, %r15
adcq    _2p123, %rax
adcq    _2p4,   %rbx

subq    152(%rsp), %r13
subq    160(%rsp), %r14
subq    168(%rsp), %r15
subq    176(%rsp), %rax
subq    184(%rsp), %rbx

movq    %r13, 312(%rsp)
movq    %r14, 320(%rsp)
movq    %r15, 328(%rsp)
movq    %rax, 336(%rsp)
movq    %rbx, 344(%rsp)

// X3
movq    192(%rsp), %r8  
movq    200(%rsp), %r9
movq    208(%rsp), %r10
movq    216(%rsp), %r11
movq    224(%rsp), %r12

// copy X3
movq    %r8,  %r13
movq    %r9,  %r14
movq    %r10, %r15
movq    %r11, %rax
movq    %r12, %rbx

// T3 ← X3 + Z3
addq    232(%rsp), %r8
adcq    240(%rsp), %r9
adcq    248(%rsp), %r10
adcq    256(%rsp), %r11
adcq    264(%rsp), %r12

movq    %r8,  352(%rsp)
movq    %r9,  360(%rsp)
movq    %r10, 368(%rsp)
movq    %r11, 376(%rsp)
movq    %r12, 384(%rsp)

// T4 ← X3 - Z3
addq    _2p0,   %r13
adcq    _2p123, %r14
adcq    _2p123, %r15
adcq    _2p123, %rax
adcq    _2p4,   %rbx

subq    232(%rsp), %r13
subq    240(%rsp), %r14
subq    248(%rsp), %r15
subq    256(%rsp), %rax
subq    264(%rsp), %rbx

movq    %r13, 392(%rsp)
movq    %r14, 400(%rsp)
movq    %r15, 408(%rsp)
movq    %rax, 416(%rsp)
movq    %rbx, 424(%rsp)

// Z3 ← T2 · T3
movq    312(%rsp), %rax
mulq    352(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    312(%rsp), %rax
mulq    360(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    320(%rsp), %rax
mulq    352(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    312(%rsp), %rax
mulq    368(%rsp)
movq    %rax, %r12
movq    %rdx, %r13

movq    320(%rsp), %rax
mulq    360(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    328(%rsp), %rax
mulq    352(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    312(%rsp), %rax
mulq    376(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    320(%rsp), %rax
mulq    368(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    328(%rsp), %rax
mulq    360(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    336(%rsp), %rax
mulq    352(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    312(%rsp), %rax
mulq    384(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

movq    320(%rsp), %rax
mulq    376(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    328(%rsp), %rax
mulq    368(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    336(%rsp), %rax
mulq    360(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    344(%rsp), %rax
mulq    352(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $17, %rbx, %rbp

imul    $144, 320(%rsp), %rax
mulq    384(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 328(%rsp), %rax
mulq    376(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 336(%rsp), %rax
mulq    368(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 344(%rsp), %rax
mulq    360(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

shld    $13, %r8,  %r9

imul    $144, 328(%rsp), %rax
mulq    384(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 336(%rsp), %rax
mulq    376(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 344(%rsp), %rax
mulq    368(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $144, 336(%rsp), %rax
mulq    384(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 344(%rsp), %rax
mulq    376(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $144, 344(%rsp), %rax
mulq    384(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

imul    $9, %rbp, %rbp

movq    mask51, %rdx

andq    %rdx, %r8
andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    mask47, %rbx

addq    %r9,  %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r8, %rax
shrq    $51, %rax
addq    %r10, %rax
andq    %rdx, %r8

movq    %rax, %r9
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r9

movq    %rax, %r11
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r11

movq    %rax, %r13
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r13

movq    %rax, %r15
shrq    $47, %rax
imul    $9, %rax ,%rax
addq    %r8, %rax
andq    mask47, %r15

movq    %rax, 232(%rsp)
movq    %r9,  240(%rsp)
movq    %r11, 248(%rsp)
movq    %r13, 256(%rsp)
movq    %r15, 264(%rsp)

// X3 ← T1 · T4
movq    272(%rsp), %rax
mulq    392(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    272(%rsp), %rax
mulq    400(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    280(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    272(%rsp), %rax
mulq    408(%rsp)
movq    %rax, %r12
movq    %rdx, %r13

movq    280(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    288(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    272(%rsp), %rax
mulq    416(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    280(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    288(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    296(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    272(%rsp), %rax
mulq    424(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

movq    280(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    288(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    296(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    304(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $17, %rbx, %rbp

imul    $144, 280(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 288(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 296(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 304(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

shld    $13, %r8,  %r9

imul    $144, 288(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 296(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 304(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $144, 296(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 304(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $144, 304(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

imul    $9, %rbp, %rbp

movq    mask51, %rdx

andq    %rdx, %r8
andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    mask47, %rbx

addq    %r9,  %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r8, %rax
shrq    $51, %rax
addq    %r10, %rax
andq    %rdx, %r8

movq    %rax, %r9
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r9

movq    %rax, %r11
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r11

movq    %rax, %r13
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r13

movq    %rax, %r15
shrq    $47, %rax
imul    $9, %rax ,%rax
addq    %r8, %rax
andq    mask47, %r15

movq    %rax, 192(%rsp)
movq    %r9,  200(%rsp)
movq    %r11, 208(%rsp)
movq    %r13, 216(%rsp)
movq    %r15, 224(%rsp)

movb	432(%rsp), %cl
movb	436(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    434(%rsp), %bl
movb    %cl, 434(%rsp)

cmpb    $1, %bl 

// CSelect(T1,T3,select)
movq    272(%rsp), %r8
movq    280(%rsp), %r9
movq    288(%rsp), %r10
movq    296(%rsp), %r11
movq    304(%rsp), %r12

movq    352(%rsp), %r13
movq    360(%rsp), %r14
movq    368(%rsp), %r15
movq    376(%rsp), %rax
movq    384(%rsp), %rbx

cmove   %r13, %r8
cmove   %r14, %r9
cmove   %r15, %r10
cmove   %rax, %r11
cmove   %rbx, %r12

movq    %r8,  272(%rsp)
movq    %r9,  280(%rsp)
movq    %r10, 288(%rsp)
movq    %r11, 296(%rsp)
movq    %r12, 304(%rsp)

// CSelect(T2,T4,select)
movq    312(%rsp), %r8
movq    320(%rsp), %r9
movq    328(%rsp), %rsi
movq    336(%rsp), %rdi
movq    344(%rsp), %r10

movq    392(%rsp), %r11
movq    400(%rsp), %r12
movq    408(%rsp), %r13
movq    416(%rsp), %r14
movq    424(%rsp), %r15

cmove   %r11, %r8
cmove   %r12, %r9
cmove   %r13, %rsi
cmove   %r14, %rdi
cmove   %r15, %r10

// T2 ← T2^2
movq    %r10, 344(%rsp)

movq    %r8, %rax
mulq    %r8
movq    %rax, %r10
movq    %rdx, %r11

shlq    $1, %r8
movq    %r8, %rax
mulq    %r9
movq    %rax, %r12
movq    %rdx, %r13

movq    %r8, %rax
mulq    %rsi
movq    %rax, %r14
movq    %rdx, %r15

movq    %r9, %rax
mulq    %r9
addq    %rax, %r14
adcq    %rdx, %r15

movq    %r8, %rax
mulq    %rdi
movq    %rax, %rbx
movq    %rdx, %rbp

shlq    $1, %r9
movq    %r9, %rax
mulq    %rsi
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    %r8, %rax
mulq    344(%rsp)
movq    %rax, %r8
movq    %rdx, %rcx

movq    %r9, %rax
mulq    %rdi
addq    %rax, %r8
adcq    %rdx, %rcx

movq    %rsi, %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %rcx

shld    $17, %r8,  %rcx

imul    $144, %rdi, %rax
mulq    %rdi
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 344(%rsp), %rax
movq    %rax, 336(%rsp)
mulq    344(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $13, %rbx, %rbp

imul    $144, 344(%rsp), %rax
mulq    %r9
addq    %rax, %r10
adcq    %rdx, %r11

imul    $288, %rdi, %rax
mulq    %rsi
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $288, 344(%rsp), %rax
mulq    %rdi
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

movq    336(%rsp), %rax
shlq    $1, %rax
mulq    %rsi
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $9, %rcx, %rcx

movq    mask51, %rdx

andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    %rdx, %rbx
andq    mask47, %r8

addq    %rcx, %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r10, %rax
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r10

movq    %rax, %r9
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r9

movq    %rax, %r14
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r14

movq    %rax, %rbx
shrq    $51, %rax
addq    %r8, %rax
andq    %rdx, %rbx

movq    %rax, %r8
shrq    $47, %r8
imul    $9, %r8, %r8
addq    %r10, %r8
andq    mask47, %rax

movq    %r8, 312(%rsp)
movq    %r9, 320(%rsp)
movq    %r14, 328(%rsp)
movq    %rbx, 336(%rsp)
movq    %rax, 344(%rsp)

// T1 ← T1^2
movq    272(%rsp), %r8
movq    280(%rsp), %r9

movq    %r8, %rax
mulq    %r8
movq    %rax, %r10
movq    %rdx, %r11

shlq    $1, %r8
movq    %r8, %rax
mulq    %r9
movq    %rax, %r12
movq    %rdx, %r13

movq    %r8, %rax
mulq    288(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    %r9, %rax
mulq    %r9
addq    %rax, %r14
adcq    %rdx, %r15

movq    %r8, %rax
mulq    296(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

shlq    $1, %r9
movq    %r9, %rax
mulq    288(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    %r8, %rax
mulq    304(%rsp)
movq    %rax, %r8
movq    %rdx, %rcx

movq    %r9, %rax
mulq    296(%rsp)
addq    %rax, %r8
adcq    %rdx, %rcx

movq    288(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %rcx

shld    $17, %r8,  %rcx

imul    $144, 296(%rsp), %rax
mulq    296(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 304(%rsp), %rax
movq    %rax, 280(%rsp)
mulq    304(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $13, %rbx, %rbp

imul    $144, 304(%rsp), %rax
mulq    %r9
addq    %rax, %r10
adcq    %rdx, %r11

imul    $288, 296(%rsp), %rax
mulq    288(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $288, 304(%rsp), %rax
mulq    296(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

movq    280(%rsp), %rax
shlq    $1, %rax
mulq    288(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $9, %rcx, %rcx

movq    mask51, %rdx

andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    %rdx, %rbx
andq    mask47, %r8

addq    %rcx, %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r10, %rax
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r10

movq    %rax, %r9
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r9

movq    %rax, %r14
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r14

movq    %rax, %rbx
shrq    $51, %rax
addq    %r8, %rax
andq    %rdx, %rbx

movq    %rax, %r8
shrq    $47, %r8
imul    $9, %r8, %r8
addq    %r10, %r8
andq    mask47, %rax

movq    %r8, 272(%rsp)
movq    %r9, 280(%rsp)
movq    %r14, 288(%rsp)
movq    %rbx, 296(%rsp)
movq    %rax, 304(%rsp)

// X3
movq    192(%rsp), %r11
movq    200(%rsp), %r12
movq    208(%rsp), %r13
movq    216(%rsp), %r14
movq    224(%rsp), %r15

// copy X3
movq    %r11, %r8
movq    %r12, %r9
movq    %r13, %rsi
movq    %r14, %rdi
movq    %r15, %r10

// X3 ← X3 + Z3
addq    232(%rsp), %r11
adcq    240(%rsp), %r12
adcq    248(%rsp), %r13
adcq    256(%rsp), %r14
adcq    264(%rsp), %r15

movq    %r11, 192(%rsp)
movq    %r12, 200(%rsp)
movq    %r13, 208(%rsp)
movq    %r14, 216(%rsp)
movq    %r15, 224(%rsp)

// Z3 ← X3 - Z3
addq    _2p0,   %r8
adcq    _2p123, %r9
adcq    _2p123, %rsi
adcq    _2p123, %rdi
adcq    _2p4,   %r10

subq    232(%rsp), %r8
subq    240(%rsp), %r9
subq    248(%rsp), %rsi
subq    256(%rsp), %rdi
subq    264(%rsp), %r10

movq    %r8,  232(%rsp)
movq    %r9,  240(%rsp)
movq    %rsi, 248(%rsp)
movq    %rdi, 256(%rsp)
movq    %r10, 264(%rsp)

// Z3 ← Z3^2
movq    %r8, %rax
mulq    %r8
movq    %rax, %r10
movq    %rdx, %r11

shlq    $1, %r8
movq    %r8, %rax
mulq    %r9
movq    %rax, %r12
movq    %rdx, %r13

movq    %r8, %rax
mulq    %rsi
movq    %rax, %r14
movq    %rdx, %r15

movq    %r9, %rax
mulq    %r9
addq    %rax, %r14
adcq    %rdx, %r15

movq    %r8, %rax
mulq    %rdi
movq    %rax, %rbx
movq    %rdx, %rbp

shlq    $1, %r9
movq    %r9, %rax
mulq    %rsi
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    %r8, %rax
mulq    264(%rsp)
movq    %rax, %r8
movq    %rdx, %rcx

movq    %r9, %rax
mulq    %rdi
addq    %rax, %r8
adcq    %rdx, %rcx

movq    %rsi, %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %rcx

shld    $17, %r8,  %rcx

imul    $144, %rdi, %rax
mulq    %rdi
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 264(%rsp), %rax
movq    %rax, 256(%rsp)
mulq    264(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $13, %rbx, %rbp

imul    $144, 264(%rsp), %rax
mulq    %r9
addq    %rax, %r10
adcq    %rdx, %r11

imul    $288, %rdi, %rax
mulq    %rsi
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $288, 264(%rsp), %rax
mulq    %rdi
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

movq    256(%rsp), %rax
shlq    $1, %rax
mulq    %rsi
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $9, %rcx, %rcx

movq    mask51, %rdx

andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    %rdx, %rbx
andq    mask47, %r8

addq    %rcx, %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r10, %rax
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r10

movq    %rax, %r9
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r9

movq    %rax, %r14
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r14

movq    %rax, %rbx
shrq    $51, %rax
addq    %r8, %rax
andq    %rdx, %rbx

movq    %rax, %r8
shrq    $47, %r8
imul    $9, %r8, %r8
addq    %r10, %r8
andq    mask47, %rax

movq    %r8, 232(%rsp)
movq    %r9, 240(%rsp)
movq    %r14, 248(%rsp)
movq    %rbx, 256(%rsp)
movq    %rax, 264(%rsp)

// X3 ← X3^2
movq    192(%rsp), %r8
movq    200(%rsp), %r9

movq    %r8, %rax
mulq    %r8
movq    %rax, %r10
movq    %rdx, %r11

shlq    $1, %r8
movq    %r8, %rax
mulq    %r9
movq    %rax, %r12
movq    %rdx, %r13

movq    %r8, %rax
mulq    208(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    %r9, %rax
mulq    %r9
addq    %rax, %r14
adcq    %rdx, %r15

movq    %r8, %rax
mulq    216(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

shlq    $1, %r9
movq    %r9, %rax
mulq    208(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    %r8, %rax
mulq    224(%rsp)
movq    %rax, %r8
movq    %rdx, %rcx

movq    %r9, %rax
mulq    216(%rsp)
addq    %rax, %r8
adcq    %rdx, %rcx

movq    208(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %rcx

shld    $17, %r8,  %rcx

imul    $144, 216(%rsp), %rax
mulq    216(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 224(%rsp), %rax
movq    %rax, 200(%rsp)
mulq    224(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $13, %rbx, %rbp

imul    $144, 224(%rsp), %rax
mulq    %r9
addq    %rax, %r10
adcq    %rdx, %r11

imul    $288, 216(%rsp), %rax
mulq    208(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $288, 224(%rsp), %rax
mulq    216(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

movq    200(%rsp), %rax
shlq    $1, %rax
mulq    208(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $9, %rcx, %rcx

movq    mask51, %rdx

andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    %rdx, %rbx
andq    mask47, %r8

addq    %rcx, %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r10, %rax
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r10

movq    %rax, %r9
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r9

movq    %rax, %r14
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r14

movq    %rax, %rbx
shrq    $51, %rax
addq    %r8, %rax
andq    %rdx, %rbx

movq    %rax, %r8
shrq    $47, %r8
imul    $9, %r8, %r8
addq    %r10, %r8
andq    mask47, %rax

// update X3
movq    %r8, 192(%rsp)
movq    %r9, 200(%rsp)
movq    %r14, 208(%rsp)
movq    %rbx, 216(%rsp)
movq    %rax, 224(%rsp)

// T3 ← T1 - T2
movq    272(%rsp), %rax
movq    280(%rsp), %r9
movq    288(%rsp), %r10
movq    296(%rsp), %r11
movq    304(%rsp), %r12

addq    _2p0,   %rax
adcq    _2p123, %r9
adcq    _2p123, %r10
adcq    _2p123, %r11
adcq    _2p4,   %r12

subq    312(%rsp), %rax
subq    320(%rsp), %r9
subq    328(%rsp), %r10
subq    336(%rsp), %r11
subq    344(%rsp), %r12

movq    %rax, 352(%rsp)
movq    %r9,  360(%rsp)
movq    %r10, 368(%rsp)
movq    %r11, 376(%rsp)
movq    %r12, 384(%rsp)

// T4 ← ((A + 2)/4) · T3
mulq    a24x2e13
shrq    $13,  %rax
movq    %rax, %rsi
movq    %rdx, %rcx

movq    %r9,  %rax
mulq    a24x2e13
shrq    $13,  %rax
addq    %rax, %rcx
movq    %rdx, %rbx

movq    %r10, %rax
mulq    a24x2e13
shrq    $13,  %rax
addq    %rax, %rbx
movq    %rdx, %rbp

movq    %r11, %rax
mulq    a24x2e13
shrq    $13,  %rax
addq    %rax, %rbp
movq    %rdx, %rdi

movq    %r12, %rax
mulq    a24x2e17
shrq    $17,  %rax
addq    %rax, %rdi
imul    $9, %rdx, %rdx
addq    %rdx, %rsi

// T4 ← T4 + T2
addq    312(%rsp), %rsi
adcq    320(%rsp), %rcx
adcq    328(%rsp), %rbx
adcq    336(%rsp), %rbp
adcq    344(%rsp), %rdi

movq    %rsi, 392(%rsp)
movq    %rcx, 400(%rsp)
movq    %rbx, 408(%rsp)
movq    %rbp, 416(%rsp)
movq    %rdi, 424(%rsp)

// X2 ← T1 · T2
movq    272(%rsp), %rax
mulq    312(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    272(%rsp), %rax
mulq    320(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    280(%rsp), %rax
mulq    312(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    272(%rsp), %rax
mulq    328(%rsp)
movq    %rax, %r12
movq    %rdx, %r13

movq    280(%rsp), %rax
mulq    320(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    288(%rsp), %rax
mulq    312(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    272(%rsp), %rax
mulq    336(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    280(%rsp), %rax
mulq    328(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    288(%rsp), %rax
mulq    320(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    296(%rsp), %rax
mulq    312(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    272(%rsp), %rax
mulq    344(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

movq    280(%rsp), %rax
mulq    336(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    288(%rsp), %rax
mulq    328(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    296(%rsp), %rax
mulq    320(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    304(%rsp), %rax
mulq    312(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $17, %rbx, %rbp

imul    $144, 280(%rsp), %rax
mulq    344(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 288(%rsp), %rax
mulq    336(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 296(%rsp), %rax
mulq    328(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 304(%rsp), %rax
mulq    320(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

shld    $13, %r8,  %r9

imul    $144, 288(%rsp), %rax
mulq    344(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 296(%rsp), %rax
mulq    336(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 304(%rsp), %rax
mulq    328(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $144, 296(%rsp), %rax
mulq    344(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 304(%rsp), %rax
mulq    336(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $144, 304(%rsp), %rax
mulq    344(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

imul    $9, %rbp, %rbp

movq    mask51, %rdx

andq    %rdx, %r8
andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    mask47, %rbx

addq    %r9,  %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r8, %rax
shrq    $51, %rax
addq    %r10, %rax
andq    %rdx, %r8

movq    %rax, %r9
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r9

movq    %rax, %r11
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r11

movq    %rax, %r13
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r13

movq    %rax, %r15
shrq    $47, %rax
imul    $9, %rax ,%rax
addq    %r8, %rax
andq    mask47, %r15

// update X2
movq    %rax, 112(%rsp) 
movq    %r9,  120(%rsp)
movq    %r11, 128(%rsp)
movq    %r13, 136(%rsp)
movq    %r15, 144(%rsp)

// Z2 ← T3 · T4
movq    352(%rsp), %rax
mulq    392(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    352(%rsp), %rax
mulq    400(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    360(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq    408(%rsp)
movq    %rax, %r12
movq    %rdx, %r13

movq    360(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    368(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    352(%rsp), %rax
mulq    416(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    360(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    368(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    376(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    352(%rsp), %rax
mulq    424(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

movq    360(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    368(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    376(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    384(%rsp), %rax
mulq    392(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $17, %rbx, %rbp

imul    $144, 360(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 368(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 376(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 384(%rsp), %rax
mulq    400(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

shld    $13, %r8,  %r9

imul    $144, 368(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 376(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 384(%rsp), %rax
mulq    408(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $144, 376(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 384(%rsp), %rax
mulq    416(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $144, 384(%rsp), %rax
mulq    424(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

imul    $9, %rbp, %rbp

movq    mask51, %rdx

andq    %rdx, %r8
andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    mask47, %rbx

addq    %r9,  %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r8, %rax
shrq    $51, %rax
addq    %r10, %rax
andq    %rdx, %r8

movq    %rax, %r9
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r9

movq    %rax, %r11
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r11

movq    %rax, %r13
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r13

movq    %rax, %r15
shrq    $47, %rax
imul    $9, %rax ,%rax
addq    %r8, %rax
andq    mask47, %r15

// update Z2
movq    %rax, 152(%rsp) 
movq    %r9,  160(%rsp)
movq    %r11, 168(%rsp)
movq    %r13, 176(%rsp)
movq    %r15, 184(%rsp)

// Z3 ← Z3 · X1
movq    232(%rsp), %rax
mulq    72(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    232(%rsp), %rax
mulq    80(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    240(%rsp), %rax
mulq    72(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    232(%rsp), %rax
mulq    88(%rsp)
movq    %rax, %r12
movq    %rdx, %r13

movq    240(%rsp), %rax
mulq    80(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    248(%rsp), %rax
mulq    72(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    232(%rsp), %rax
mulq    96(%rsp)
movq    %rax, %r14
movq    %rdx, %r15

movq    240(%rsp), %rax
mulq    88(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    248(%rsp), %rax
mulq    80(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    256(%rsp), %rax
mulq    72(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    232(%rsp), %rax
mulq    104(%rsp)
movq    %rax, %rbx
movq    %rdx, %rbp

movq    240(%rsp), %rax
mulq    96(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    248(%rsp), %rax
mulq    88(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    256(%rsp), %rax
mulq    80(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    264(%rsp), %rax
mulq    72(%rsp)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $17, %rbx, %rbp

imul    $144, 240(%rsp), %rax
mulq    104(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 248(%rsp), %rax
mulq    96(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 256(%rsp), %rax
mulq    88(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

imul    $144, 264(%rsp), %rax
mulq    80(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

shld    $13, %r8,  %r9

imul    $144, 248(%rsp), %rax
mulq    104(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 256(%rsp), %rax
mulq    96(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

imul    $144, 264(%rsp), %rax
mulq    88(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

imul    $144, 256(%rsp), %rax
mulq    104(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 264(%rsp), %rax
mulq    96(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

shld    $13, %r12, %r13

imul    $144, 264(%rsp), %rax
mulq    104(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

imul    $9, %rbp, %rbp

movq    mask51, %rdx

andq    %rdx, %r8
andq    %rdx, %r10
andq    %rdx, %r12
andq    %rdx, %r14
andq    mask47, %rbx

addq    %r9,  %r10
addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8

movq    %r8, %rax
shrq    $51, %rax
addq    %r10, %rax
andq    %rdx, %r8

movq    %rax, %r9
shrq    $51, %rax
addq    %r12, %rax
andq    %rdx, %r9

movq    %rax, %r11
shrq    $51, %rax
addq    %r14, %rax
andq    %rdx, %r11

movq    %rax, %r13
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r13

movq    %rax, %r15
shrq    $47, %rax
imul    $9, %rax ,%rax
addq    %r8, %rax
andq    mask47, %r15

// update Z3
movq    %rax, 232(%rsp)
movq    %r9,  240(%rsp)
movq    %r11, 248(%rsp)
movq    %r13, 256(%rsp)
movq    %r15, 264(%rsp)

movb    432(%rsp), %cl
subb    $1, %cl
movb    %cl, 432(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 432(%rsp)
movq    64(%rsp), %rax
movq    440(%rsp), %r15
subq    $1, %r15
movq    %r15, 440(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    112(%rsp), %r8 
movq    120(%rsp), %r9
movq    128(%rsp), %r10
movq    136(%rsp), %r11
movq    144(%rsp), %r12

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)

movq    152(%rsp), %r8 
movq    160(%rsp), %r9
movq    168(%rsp), %r10
movq    176(%rsp), %r11
movq    184(%rsp), %r12

// store final value of Z2
movq    %r8,  40(%rdi) 
movq    %r9,  48(%rdi)
movq    %r10, 56(%rdi)
movq    %r11, 64(%rdi)
movq    %r12, 72(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
