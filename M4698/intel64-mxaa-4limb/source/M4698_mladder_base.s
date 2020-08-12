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
.globl M4698_mladder_base
M4698_mladder_base:

movq 	%rsp, %r11
subq 	$344, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X2 ← 1
movq	$1, 72(%rsp)
movq	$0, 80(%rsp)
movq	$0, 88(%rsp)
movq	$0, 96(%rsp)

// Z2 ← 0
movq	$0, 104(%rsp)
movq	$0, 112(%rsp)
movq	$0, 120(%rsp)
movq	$0, 128(%rsp)

// X3 ← XP
movq	0(%rsi), %r8
movq	%r8, 136(%rsp)
movq	8(%rsi), %r8
movq	%r8, 144(%rsp)
movq	16(%rsi), %r8
movq	%r8, 152(%rsp)
movq	24(%rsi), %r8
movq	%r8, 160(%rsp)

// Z3 ← 1
movq	$1, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)

movq    $31, 208(%rsp)
movb	$2, 200(%rsp)
movb    $0, 202(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:

addq    208(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 204(%rsp)

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
movq    72(%rsp), %r8  
movq    80(%rsp), %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11

// copy X2
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

// T1 ← X2 + Z2
addq    104(%rsp), %r8
adcq    112(%rsp), %r9
adcq    120(%rsp), %r10
adcq    128(%rsp), %r11

movq    %r8,  216(%rsp)
movq    %r9,  224(%rsp)
movq    %r10, 232(%rsp)
movq    %r11, 240(%rsp)

// T2 ← X2 - Z2
addq    _4p0,  %rax
adcq    _4p12, %rbx
adcq    _4p12, %rbp
adcq    _4p3,  %rsi

subq    104(%rsp), %rax
sbbq    112(%rsp), %rbx
sbbq    120(%rsp), %rbp
sbbq    128(%rsp), %rsi

movq    %rax, 248(%rsp)
movq    %rbx, 256(%rsp)
movq    %rbp, 264(%rsp)
movq    %rsi, 272(%rsp)

// X3
movq    136(%rsp), %r8
movq    144(%rsp), %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11

// copy X3 
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

// T3 ← X3 + Z3
addq    168(%rsp), %r8
adcq    176(%rsp), %r9
adcq    184(%rsp), %r10
adcq    192(%rsp), %r11

movq    %r8,  280(%rsp)
movq    %r9,  288(%rsp)
movq    %r10, 296(%rsp)
movq    %r11, 304(%rsp)

// T4 ← X3 - Z3
addq    _4p0,  %rax
adcq    _4p12, %rbx
adcq    _4p12, %rbp
adcq    _4p3,  %rsi

subq    168(%rsp), %rax
sbbq    176(%rsp), %rbx
sbbq    184(%rsp), %rbp
sbbq    192(%rsp), %rsi

movq    %rax, 312(%rsp)
movq    %rbx, 320(%rsp)
movq    %rbp, 328(%rsp)
movq    %rsi, 336(%rsp)

// Z3 ← T2 · T3
movq    248(%rsp), %rdx

mulx    280(%rsp), %r8, %r9
mulx    288(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    296(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    304(%rsp), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    256(%rsp), %rdx    

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    296(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    304(%rsp), %rcx, %r13
adcq    %rcx, %rsi
adcq    $0, %r13

addq    %rax, %r9
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    $0,   %r13

movq    264(%rsp), %rdx

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    296(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    304(%rsp), %rcx, %r14
adcq    %rcx, %rsi
adcq    $0, %r14

addq    %rax, %r10
adcq    %rbx, %r11
adcq    %rbp, %r12
adcq    %rsi, %r13
adcq    $0,   %r14

movq    272(%rsp), %rdx

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    296(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    304(%rsp), %rcx, %r15
adcq    %rcx, %rsi
adcq    $0, %r15

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    $0,   %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

movq    %r8,  168(%rsp)
movq    %r9,  176(%rsp)
movq    %r10, 184(%rsp)
movq    %r11, 192(%rsp)

// X3 ← T1 · T4
movq    216(%rsp), %rdx

mulx    312(%rsp), %r8, %r9
mulx    320(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    328(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    336(%rsp), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    224(%rsp), %rdx    

mulx    312(%rsp), %rax, %rbx
mulx    320(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    328(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    336(%rsp), %rcx, %r13
adcq    %rcx, %rsi
adcq    $0, %r13

addq    %rax, %r9
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    $0,   %r13

movq    232(%rsp), %rdx

mulx    312(%rsp), %rax, %rbx
mulx    320(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    328(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    336(%rsp), %rcx, %r14
adcq    %rcx, %rsi
adcq    $0, %r14

addq    %rax, %r10
adcq    %rbx, %r11
adcq    %rbp, %r12
adcq    %rsi, %r13
adcq    $0,   %r14

movq    240(%rsp), %rdx

mulx    312(%rsp), %rax, %rbx
mulx    320(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    328(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    336(%rsp), %rcx, %r15
adcq    %rcx, %rsi
adcq    $0, %r15

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    $0,   %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

movq    %r8,  136(%rsp)
movq    %r9,  144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)

movb	200(%rsp), %cl
movb	204(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    202(%rsp), %bl
movb    %cl, 202(%rsp)

cmpb    $1, %bl 

// CSelect(T1,T3,select)
movq    216(%rsp), %r8
movq    224(%rsp), %r9
movq    232(%rsp), %r10
movq    240(%rsp), %r11

movq    280(%rsp), %r12
movq    288(%rsp), %r13
movq    296(%rsp), %r14
movq    304(%rsp), %r15

cmove   %r12, %r8
cmove   %r13, %r9
cmove   %r14, %r10
cmove   %r15, %r11

movq    %r8,  216(%rsp)
movq    %r9,  224(%rsp)
movq    %r10, 232(%rsp)
movq    %r11, 240(%rsp)

// CSelect(T2,T4,select)
movq    248(%rsp), %rdx
movq    256(%rsp), %rbp
movq    264(%rsp), %rsi
movq    272(%rsp), %rdi

movq    312(%rsp), %r12
movq    320(%rsp), %r13
movq    328(%rsp), %r14
movq    336(%rsp), %r15

cmove   %r12, %rdx
cmove   %r13, %rbp
cmove   %r14, %rsi
cmove   %r15, %rdi

// T2 ← T2^2
movq    %rdx, 248(%rsp)

mulx    %rbp, %r9, %r10
mulx    %rsi, %rcx, %r11
addq    %rcx, %r10

mulx    %rdi, %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    %rbp, %rdx

mulx    %rsi, %rax, %rbx
mulx    %rdi, %rcx, %r13
addq    %rcx, %rbx
adcq    $0, %r13

addq    %rax, %r11
adcq    %rbx, %r12
adcq    $0, %r13

movq    %rsi, %rdx

mulx    %rdi, %rax, %r14

addq    %rax, %r13
adcq    $0, %r14

movq    $0, %r15
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    248(%rsp), %rdx
mulx    %rdx, %r8, %rax
addq    %rax, %r9

movq    %rbp, %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r10
adcq    %rbx, %r11

movq    %rsi, %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r12
adcq    %rbx, %r13

movq    %rdi, %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r14
adcq    %rbx, %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

movq    %r8, 248(%rsp)
movq    %r9, 256(%rsp)
movq    %r10, 264(%rsp)
movq    %r11, 272(%rsp)

// T1 ← T1^2
movq    216(%rsp), %rdx
    
mulx    224(%rsp), %r9, %r10
mulx    232(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    240(%rsp), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    224(%rsp), %rdx

mulx    232(%rsp), %rax, %rbx
mulx    240(%rsp), %rcx, %r13
addq    %rcx, %rbx
adcq    $0, %r13

addq    %rax, %r11
adcq    %rbx, %r12
adcq    $0, %r13

movq    232(%rsp), %rdx

mulx    240(%rsp), %rax, %r14

addq    %rax, %r13
adcq    $0, %r14

movq    $0, %r15
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    216(%rsp), %rdx
mulx    %rdx, %r8, %rax
addq    %rax, %r9

movq    224(%rsp), %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r10
adcq    %rbx, %r11

movq    232(%rsp), %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r12
adcq    %rbx, %r13

movq    240(%rsp), %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r14
adcq    %rbx, %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

movq    %r8, 216(%rsp) 
movq    %r9, 224(%rsp)
movq    %r10, 232(%rsp)
movq    %r11, 240(%rsp)

// X3
movq    136(%rsp), %r8
movq    144(%rsp), %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11

// copy X3
movq    %r8, %rdx
movq    %r9, %rbp
movq    %r10, %rsi
movq    %r11, %rdi

// X3 ← X3 + Z3
addq    168(%rsp), %r8
adcq    176(%rsp), %r9
adcq    184(%rsp), %r10
adcq    192(%rsp), %r11

movq    %r8,  136(%rsp)
movq    %r9,  144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)

// Z3 ← X3 - Z3
addq    _4p0,  %rdx
adcq    _4p12, %rbp
adcq    _4p12, %rsi
adcq    _4p3,  %rdi

subq    168(%rsp), %rdx
sbbq    176(%rsp), %rbp
sbbq    184(%rsp), %rsi
sbbq    192(%rsp), %rdi

// Z3 ← Z3^2
movq    %rdx, 104(%rsp)

mulx    %rbp, %r9, %r10
mulx    %rsi, %rcx, %r11
addq    %rcx, %r10

mulx    %rdi, %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    %rbp, %rdx

mulx    %rsi, %rax, %rbx
mulx    %rdi, %rcx, %r13
addq    %rcx, %rbx
adcq    $0, %r13

addq    %rax, %r11
adcq    %rbx, %r12
adcq    $0, %r13

movq    %rsi, %rdx

mulx    %rdi, %rax, %r14

addq    %rax, %r13
adcq    $0, %r14

movq    $0, %r15
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    104(%rsp), %rdx
mulx    %rdx, %r8, %rax
addq    %rax, %r9

movq    %rbp, %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r10
adcq    %rbx, %r11

movq    %rsi, %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r12
adcq    %rbx, %r13

movq    %rdi, %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r14
adcq    %rbx, %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

movq    %r8, 168(%rsp) 
movq    %r9, 176(%rsp)
movq    %r10, 184(%rsp)
movq    %r11, 192(%rsp)

// X3 ← X3^2
movq    136(%rsp), %rdx
    
mulx    144(%rsp), %r9, %r10
mulx    152(%rsp), %rcx, %r11
addq    %rcx, %r10

mulx    160(%rsp), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    144(%rsp), %rdx

mulx    152(%rsp), %rax, %rbx
mulx    160(%rsp), %rcx, %r13
addq    %rcx, %rbx
adcq    $0, %r13

addq    %rax, %r11
adcq    %rbx, %r12
adcq    $0, %r13

movq    152(%rsp), %rdx

mulx    160(%rsp), %rax, %r14

addq    %rax, %r13
adcq    $0, %r14

movq    $0, %r15
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shlq    $1, %r9

movq    136(%rsp), %rdx
mulx    %rdx, %r8, %rax
addq    %rax, %r9

movq    144(%rsp), %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r10
adcq    %rbx, %r11

movq    152(%rsp), %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r12
adcq    %rbx, %r13

movq    160(%rsp), %rdx
mulx    %rdx, %rax, %rbx
adcq    %rax, %r14
adcq    %rbx, %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

// update X3
movq    %r8, 136(%rsp) 
movq    %r9, 144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)

// T3 ← T1 - T2
movq    216(%rsp), %rbx
movq    224(%rsp), %rbp
movq    232(%rsp), %rcx
movq    240(%rsp), %rsi

addq    _4p0,  %rbx
adcq    _4p12, %rbp
adcq    _4p12, %rcx
adcq    _4p3,  %rsi

subq    248(%rsp), %rbx
sbbq    256(%rsp), %rbp
sbbq    264(%rsp), %rcx
sbbq    272(%rsp), %rsi

movq    %rbx, 280(%rsp)
movq    %rbp, 288(%rsp)
movq    %rcx, 296(%rsp)
movq    %rsi, 304(%rsp)

// T4 ← ((A + 2)/4) · T3
movq    a24, %rdx

mulx    %rbx, %rbx, %r9
mulx    %rbp, %rbp, %r10
addq    %r9, %rbp

mulx    %rcx, %rcx, %r9
adcq    %r10, %rcx

mulx    %rsi, %rsi, %r10
adcq    %r9, %rsi
adcq    $0, %r10

shld    $5, %rsi, %r10
andq    mask59, %rsi

imul    $9, %r10, %r10
addq    %r10, %rbx
adcq    $0, %rbp
adcq    $0, %rcx
adcq    $0, %rsi

// T4 ← T4 + T2
addq    248(%rsp), %rbx
adcq    256(%rsp), %rbp
adcq    264(%rsp), %rcx
adcq    272(%rsp), %rsi

movq    %rbx, 312(%rsp)
movq    %rbp, 320(%rsp)
movq    %rcx, 328(%rsp)
movq    %rsi, 336(%rsp)

// X2 ← T1 · T2
movq    216(%rsp), %rdx

mulx    248(%rsp), %r8, %r9
mulx    256(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    264(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    272(%rsp), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    224(%rsp), %rdx    

mulx    248(%rsp), %rax, %rbx
mulx    256(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    264(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    272(%rsp), %rcx, %r13
adcq    %rcx, %rsi
adcq    $0, %r13

addq    %rax, %r9
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    $0,   %r13

movq    232(%rsp), %rdx

mulx    248(%rsp), %rax, %rbx
mulx    256(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    264(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    272(%rsp), %rcx, %r14
adcq    %rcx, %rsi
adcq    $0, %r14

addq    %rax, %r10
adcq    %rbx, %r11
adcq    %rbp, %r12
adcq    %rsi, %r13
adcq    $0,   %r14

movq    240(%rsp), %rdx

mulx    248(%rsp), %rax, %rbx
mulx    256(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    264(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    272(%rsp), %rcx, %r15
adcq    %rcx, %rsi
adcq    $0, %r15

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    $0,   %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

// update X2
movq    %r8,  72(%rsp) 
movq    %r9,  80(%rsp)
movq    %r10, 88(%rsp)
movq    %r11, 96(%rsp)

// Z2 ← T1 · T4
movq    312(%rsp), %rdx    

mulx    280(%rsp), %r8, %r9
mulx    288(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    296(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    304(%rsp), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    320(%rsp), %rdx    

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    296(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    304(%rsp), %rcx, %r13
adcq    %rcx, %rsi
adcq    $0, %r13

addq    %rax, %r9
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    $0,   %r13

movq    328(%rsp), %rdx

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    296(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    304(%rsp), %rcx, %r14
adcq    %rcx, %rsi
adcq    $0, %r14

addq    %rax, %r10
adcq    %rbx, %r11
adcq    %rbp, %r12
adcq    %rsi, %r13
adcq    $0,   %r14

movq    336(%rsp), %rdx

mulx    280(%rsp), %rax, %rbx
mulx    288(%rsp), %rcx, %rbp
addq    %rcx, %rbx

mulx    296(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    304(%rsp), %rcx, %r15
adcq    %rcx, %rsi
adcq    $0, %r15

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    $0,   %r15

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %r15, %r15, %rcx
adcq    %rbx, %r15
adcq    $0, %rcx

addq    %r12, %r8
adcq    %r13, %r9
adcq    %r14, %r10
adcq    %r15, %r11
adcq    $0,   %rcx

shld    $5, %r11, %rcx
andq	mask59, %r11

imul    $9, %rcx, %rcx
addq    %rcx, %r8
adcq    $0,   %r9
adcq    $0,   %r10
adcq    $0,   %r11

// update Z2
movq    %r8,  104(%rsp) 
movq    %r9,  112(%rsp)
movq    %r10, 120(%rsp)
movq    %r11, 128(%rsp)

// Z3 ← Z3 · X1
movq    $3, %rdx

mulx    168(%rsp), %rbx, %r9
mulx    176(%rsp), %rbp, %r10
addq    %r9, %rbp

mulx    184(%rsp), %rcx, %r9
adcq    %r10, %rcx

mulx    192(%rsp), %rsi, %r10
adcq    %r9, %rsi
adcq    $0, %r10

shld    $5, %rsi, %r10
andq    mask59, %rsi

imul    $9, %r10, %r10
addq    %r10, %rbx
adcq    $0, %rbp
adcq    $0, %rcx
adcq    $0, %rsi

// update Z3
movq    %rbx, 168(%rsp) 
movq    %rbp, 176(%rsp)
movq    %rcx, 184(%rsp)
movq    %rsi, 192(%rsp)

movb    200(%rsp), %cl
subb    $1, %cl
movb    %cl, 200(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 200(%rsp)
movq    64(%rsp), %rax
movq    208(%rsp), %r15
subq    $1, %r15
movq    %r15, 208(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    72(%rsp), %r8 
movq    80(%rsp), %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)

movq    104(%rsp), %r8 
movq    112(%rsp), %r9
movq    120(%rsp), %r10
movq    128(%rsp), %r11

// store final value of Z2
movq    %r8,  32(%rdi) 
movq    %r9,  40(%rdi)
movq    %r10, 48(%rdi)
movq    %r11, 56(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
