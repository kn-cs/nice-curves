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
subq 	$744, %rsp

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
movq	%r8, 264(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 272(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 280(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 288(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 296(%rsp)
movq	40(%rsi), %r8
movq	%r8, 112(%rsp)
movq	%r8, 304(%rsp)
movq	48(%rsi), %r8
movq	%r8, 120(%rsp)
movq	%r8, 312(%rsp)
movq	56(%rsi), %r8
movq	%r8, 128(%rsp)
movq	%r8, 320(%rsp) 

// X2 ← 1
movq	$1, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)  

// Z2 ← 0
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)
movq	$0, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)  

// Z3 ← 1
movq	$1, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp)
movq	$0, 352(%rsp)
movq	$0, 360(%rsp)
movq	$0, 368(%rsp)
movq	$0, 376(%rsp)
movq	$0, 384(%rsp)

movq    $55, 400(%rsp)
movb	$3, 392(%rsp)
movb    $0, 394(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:

addq    400(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 396(%rsp)

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
movq    136(%rsp), %r8  
movq    144(%rsp), %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11
movq    168(%rsp), %r12
movq    176(%rsp), %r13
movq    184(%rsp), %r14
movq    192(%rsp), %r15

// copy X2
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi
movq    %r14, %rdi

// T1 ← X2 + Z2
addq    200(%rsp), %r8
addq    208(%rsp), %r9
addq    216(%rsp), %r10
addq    224(%rsp), %r11
addq    232(%rsp), %r12
addq    240(%rsp), %r13
addq    248(%rsp), %r14
addq    256(%rsp), %r15

movq    %r8,  408(%rsp) 
movq    %r9,  416(%rsp)
movq    %r10, 424(%rsp)
movq    %r11, 432(%rsp)
movq    %r12, 440(%rsp)
movq    %r13, 448(%rsp)
movq    %r14, 456(%rsp)
movq    %r15, 464(%rsp)

movq    192(%rsp), %r15

// T2 ← X2 - Z2
addq    _2p0,   %rax
addq    _2p1_6, %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rdx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p7,   %r15

subq    200(%rsp), %rax
subq    208(%rsp), %rbx
subq    216(%rsp), %rcx
subq    224(%rsp), %rdx
subq    232(%rsp), %rbp
subq    240(%rsp), %rsi
subq    248(%rsp), %rdi
subq    256(%rsp), %r15

movq    %rax, 472(%rsp) 
movq    %rbx, 480(%rsp)
movq    %rcx, 488(%rsp)
movq    %rdx, 496(%rsp)
movq    %rbp, 504(%rsp)
movq    %rsi, 512(%rsp)
movq    %rdi, 520(%rsp)
movq    %r15, 528(%rsp)

// X3
movq    264(%rsp), %r8  
movq    272(%rsp), %r9
movq    280(%rsp), %r10
movq    288(%rsp), %r11
movq    296(%rsp), %r12
movq    304(%rsp), %r13
movq    312(%rsp), %r14
movq    320(%rsp), %r15

// copy X3
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi
movq    %r14, %rdi

// T3 ← X3 + Z3
addq    328(%rsp), %r8
addq    336(%rsp), %r9
addq    344(%rsp), %r10
addq    352(%rsp), %r11
addq    360(%rsp), %r12
addq    368(%rsp), %r13
addq    376(%rsp), %r14
addq    384(%rsp), %r15

movq    %r8,  536(%rsp) 
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)
movq    %r11, 560(%rsp)
movq    %r12, 568(%rsp)
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)
movq    %r15, 592(%rsp)

movq    320(%rsp), %r15

// T4 ← X3 - Z3
addq    _2p0,   %rax
addq    _2p1_6, %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rdx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p7,   %r15

subq    328(%rsp), %rax
subq    336(%rsp), %rbx
subq    344(%rsp), %rcx
subq    352(%rsp), %rdx
subq    360(%rsp), %rbp
subq    368(%rsp), %rsi
subq    376(%rsp), %rdi
subq    384(%rsp), %r15

movq    %rax, 600(%rsp) 
movq    %rbx, 608(%rsp)
movq    %rcx, 616(%rsp)
movq    %rdx, 624(%rsp)
movq    %rbp, 632(%rsp)
movq    %rsi, 640(%rsp)
movq    %rdi, 648(%rsp)
movq    %r15, 656(%rsp)

// Z3 ← T2 · T3
movq    480(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    488(%rsp), %rax
mulq	584(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    496(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    504(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    512(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    520(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    528(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    472(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    504(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    512(%rsp), %rax		
mulq	584(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    520(%rsp), %rax		
mulq	576(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    528(%rsp), %rax		
mulq	568(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    472(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    480(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    488(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    496(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    512(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    520(%rsp), %rax		
mulq	584(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    528(%rsp), %rax		
mulq	576(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    472(%rsp), %rax
mulq	568(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    480(%rsp), %rax
mulq	560(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    488(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    496(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    504(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 664(%rsp)
movq	%r11, 672(%rsp)

movq    520(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    528(%rsp), %rax		
mulq	584(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    472(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    480(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    488(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    496(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    504(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    512(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 680(%rsp)		
movq	%r11, 688(%rsp)		

movq    488(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    496(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    504(%rsp), %rax
mulq	576(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    512(%rsp), %rax
mulq	568(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    520(%rsp), %rax
mulq	560(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    528(%rsp), %rax
mulq	552(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    472(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    480(%rsp), %rax
mulq	536(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    496(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    504(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    512(%rsp), %rax
mulq	576(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    520(%rsp), %rax
mulq	568(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    528(%rsp), %rax
mulq	560(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    472(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    480(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    488(%rsp), %rax
mulq	536(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    528(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    472(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    480(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    488(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    496(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    504(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    512(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    520(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    472(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    480(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    488(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    496(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    504(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    512(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    520(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    528(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	664(%rsp), %rdx

movq	mask56, %rdi

movq    %r8, %rax
shrd    $56, %r9, %rax
shrq    $56, %r9
addq    %rax, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %rsi
adcq    %r13, %rcx
andq    %rdi, %r10

movq    %rsi, %r11
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rdx, %rsi
adcq    672(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    680(%rsp), %rsi
adcq    688(%rsp), %rcx
andq    %rdi, %r12

movq    %rsi, %r13
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %r14, %rsi
adcq    %r15, %rcx
andq    %rdi, %r13

movq    %rsi, %r14
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rsi, %rbp
adcq    %rcx, %rbx
andq    %rdi, %r14

movq    %rbp, %r15
shrd    $52, %rbx, %rbp
shrq    $52, %rbx

movq	$17, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$17, %rbx, %rbx
addq	%rdx, %rbx

addq    %rbp, %r8
adcq    $0, %rbx
andq    mask52, %r15

shld    $8, %r8, %rbx
addq    %rbx, %r9
andq    %rdi, %r8

movq    %r8,  328(%rsp)  	
movq    %r9,  336(%rsp)
movq    %r10, 344(%rsp)
movq    %r11, 352(%rsp)
movq    %r12, 360(%rsp)
movq    %r13, 368(%rsp)
movq    %r14, 376(%rsp)
movq    %r15, 384(%rsp)

// X3 ← T1 · T4
movq    416(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    424(%rsp), %rax
mulq	648(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    432(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    440(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    448(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    456(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    464(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    408(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    440(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    448(%rsp), %rax		
mulq	648(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    456(%rsp), %rax		
mulq	640(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    464(%rsp), %rax		
mulq	632(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    408(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    416(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    424(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    432(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    448(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    456(%rsp), %rax		
mulq	648(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    464(%rsp), %rax		
mulq	640(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    408(%rsp), %rax
mulq	632(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    416(%rsp), %rax
mulq	624(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    424(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    432(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    440(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 664(%rsp)
movq	%r11, 672(%rsp)

movq    456(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    464(%rsp), %rax		
mulq	648(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    408(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    416(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    424(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    432(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    440(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    448(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 680(%rsp)		
movq	%r11, 688(%rsp)		

movq    424(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    432(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    440(%rsp), %rax
mulq	640(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    448(%rsp), %rax
mulq	632(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    456(%rsp), %rax
mulq	624(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    464(%rsp), %rax
mulq	616(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    408(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    416(%rsp), %rax
mulq	600(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    432(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    440(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    448(%rsp), %rax
mulq	640(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    456(%rsp), %rax
mulq	632(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    464(%rsp), %rax
mulq	624(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    408(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    416(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    424(%rsp), %rax
mulq	600(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    464(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    408(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    416(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    424(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    432(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    440(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    448(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    456(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    408(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    416(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    424(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    432(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    440(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    448(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    456(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    464(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	664(%rsp), %rdx

movq	mask56, %rdi

movq    %r8, %rax
shrd    $56, %r9, %rax
shrq    $56, %r9
addq    %rax, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %rsi
adcq    %r13, %rcx
andq    %rdi, %r10

movq    %rsi, %r11
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rdx, %rsi
adcq    672(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    680(%rsp), %rsi
adcq    688(%rsp), %rcx
andq    %rdi, %r12

movq    %rsi, %r13
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %r14, %rsi
adcq    %r15, %rcx
andq    %rdi, %r13

movq    %rsi, %r14
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rsi, %rbp
adcq    %rcx, %rbx
andq    %rdi, %r14

movq    %rbp, %r15
shrd    $52, %rbx, %rbp
shrq    $52, %rbx

movq	$17, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$17, %rbx, %rbx
addq	%rdx, %rbx

addq    %rbp, %r8
adcq    $0, %rbx
andq    mask52, %r15

shld    $8, %r8, %rbx
addq    %rbx, %r9
andq    %rdi, %r8

movq    %r8,  264(%rsp)
movq    %r9,  272(%rsp)
movq    %r10, 280(%rsp)
movq    %r11, 288(%rsp)
movq    %r12, 296(%rsp)
movq    %r13, 304(%rsp)
movq    %r14, 312(%rsp)
movq    %r15, 320(%rsp)

movb	392(%rsp), %cl
movb	396(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    394(%rsp), %bl
movb    %cl, 394(%rsp)

cmpb    $1, %bl

// CSelect(T1,T3,select)
movq    408(%rsp), %r8
movq    416(%rsp), %r9
movq    424(%rsp), %r10
movq    432(%rsp), %r11
movq    440(%rsp), %r12
movq    448(%rsp), %r13
movq    456(%rsp), %r14
movq    464(%rsp), %r15

movq    536(%rsp), %rax
movq    544(%rsp), %rbx
movq    552(%rsp), %rcx
movq    560(%rsp), %rdx
movq    568(%rsp), %rbp
movq    576(%rsp), %rsi
movq    584(%rsp), %rdi

cmove   %rax, %r8
cmove   %rbx, %r9
cmove   %rcx, %r10
cmove   %rdx, %r11
cmove   %rbp, %r12
cmove   %rsi, %r13
cmove   %rdi, %r14
movq    592(%rsp), %rdi
cmove   %rdi, %r15

movq    %r8,  408(%rsp)
movq    %r9,  416(%rsp)
movq    %r10, 424(%rsp)
movq    %r11, 432(%rsp)
movq    %r12, 440(%rsp)
movq    %r13, 448(%rsp)
movq    %r14, 456(%rsp)
movq    %r15, 464(%rsp)

// CSelect(T2,T4,select)
movq    472(%rsp), %r8
movq    480(%rsp), %r9
movq    488(%rsp), %r10
movq    496(%rsp), %r11
movq    504(%rsp), %r12
movq    512(%rsp), %r13
movq    520(%rsp), %r14
movq    528(%rsp), %r15

movq    600(%rsp), %rax
movq    608(%rsp), %rbx
movq    616(%rsp), %rcx
movq    624(%rsp), %rdx
movq    632(%rsp), %rbp
movq    640(%rsp), %rsi
movq    648(%rsp), %rdi

cmove   %rax, %r8
cmove   %rbx, %r9
cmove   %rcx, %r10
cmove   %rdx, %r11
cmove   %rbp, %r12
cmove   %rsi, %r13
cmove   %rdi, %r14
movq    656(%rsp), %rdi
cmove   %rdi, %r15

movq    %r8,  472(%rsp)
movq    %r9,  480(%rsp)
movq    %r10, 488(%rsp)
movq    %r11, 496(%rsp)
movq    %r12, 504(%rsp)
movq    %r13, 512(%rsp)
movq    %r14, 520(%rsp)
movq    %r15, 528(%rsp)

// T2 ← T2^2
movq    528(%rsp), %rax
shlq    $1, %rax
movq	%rax, 664(%rsp)
mulq	480(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    520(%rsp), %rax
shlq    $1, %rax
movq	%rax, 672(%rsp)
mulq    488(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    512(%rsp), %rax
shlq    $1, %rax
movq	%rax, 680(%rsp)
mulq    496(%rsp)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    504(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    472(%rsp), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    664(%rsp), %rax
mulq	488(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    672(%rsp), %rax
mulq    496(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    680(%rsp), %rax
mulq    504(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    480(%rsp), %rax
shlq	$1, %rax
mulq	472(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    664(%rsp), %rax
mulq	496(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    672(%rsp), %rax
mulq    504(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    512(%rsp), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    488(%rsp), %rax
shlq    $1, %rax
movq    %rax, 688(%rsp)
mulq	472(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    480(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    664(%rsp), %rax
mulq    504(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    672(%rsp), %rax
mulq    512(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    496(%rsp), %rax
shlq    $1, %rax
movq    %rax, 696(%rsp)
mulq	472(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    688(%rsp), %rax
mulq	480(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    664(%rsp), %rax		
mulq    512(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    520(%rsp), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    504(%rsp), %rax
shlq    $1, %rax
movq    %rax, 704(%rsp)
mulq	472(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	480(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    488(%rsp), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 712(%rsp)		
movq	%rbx, 720(%rsp)		

movq    664(%rsp), %rax
mulq    520(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    680(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	480(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	488(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 728(%rsp)		
movq	%rbx, 736(%rsp)		

movq    528(%rsp), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    672(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    680(%rsp), %rax
mulq	480(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    704(%rsp), %rax
mulq	488(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    496(%rsp), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    664(%rsp), %rax
mulq	472(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    672(%rsp), %rax
mulq	480(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    680(%rsp), %rax
mulq	488(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	496(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	712(%rsp), %rax

movq	mask56, %rdi

movq    %r8, %rdx
shrd    $56, %r9, %rdx
shrq    $56, %r9
addq    %rdx, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %r14
adcq    %r13, %r15
andq    %rdi, %r10

movq    %r14, %r11
shrd    $56, %r15, %r14
shrq    $56, %r15
addq    %r14, %rax
adcq    720(%rsp), %r15
andq    %rdi, %r11

movq    %rax, %r12
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    728(%rsp), %rax
adcq    736(%rsp), %r15
andq    %rdi, %r12

movq    %rax, %r13
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    %rax, %rcx
adcq    %r15, %rsi
andq    %rdi, %r13

movq    %rcx, %r14
shrd    $56, %rsi, %rcx
shrq    $56, %rsi
addq    %rbp, %rcx
adcq    %rbx, %rsi
andq    %rdi, %r14

movq    %rcx, %r15
shrd    $52, %rsi, %rcx
shrq    $52, %rsi

movq	$17, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$17, %rsi, %rsi
addq	%rdx, %rsi

addq    %rcx, %r8
adcq    $0, %rsi
andq    mask52, %r15

shld    $8, %r8, %rsi
addq    %rsi, %r9
andq    %rdi, %r8

movq    %r8,  472(%rsp) 
movq    %r9,  480(%rsp)
movq    %r10, 488(%rsp)
movq    %r11, 496(%rsp)
movq    %r12, 504(%rsp)
movq    %r13, 512(%rsp)
movq    %r14, 520(%rsp)
movq    %r15, 528(%rsp)

// T1 ← T1^2
movq    464(%rsp), %rax
shlq    $1, %rax
movq	%rax, 664(%rsp)
mulq	416(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    456(%rsp), %rax
shlq    $1, %rax
movq	%rax, 672(%rsp)
mulq    424(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    448(%rsp), %rax
shlq    $1, %rax
movq	%rax, 680(%rsp)
mulq    432(%rsp)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    440(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    408(%rsp), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    664(%rsp), %rax
mulq	424(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    672(%rsp), %rax
mulq    432(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    680(%rsp), %rax
mulq    440(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    416(%rsp), %rax
shlq	$1, %rax
mulq	408(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    664(%rsp), %rax
mulq	432(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    672(%rsp), %rax
mulq    440(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    448(%rsp), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    424(%rsp), %rax
shlq    $1, %rax
movq    %rax, 688(%rsp)
mulq	408(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    416(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    664(%rsp), %rax
mulq    440(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    672(%rsp), %rax
mulq    448(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    432(%rsp), %rax
shlq    $1, %rax
movq    %rax, 696(%rsp)
mulq	408(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    688(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    664(%rsp), %rax		
mulq    448(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    456(%rsp), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    440(%rsp), %rax
shlq    $1, %rax
movq    %rax, 704(%rsp)
mulq	408(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    424(%rsp), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 712(%rsp)		
movq	%rbx, 720(%rsp)		

movq    664(%rsp), %rax
mulq    456(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    680(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	424(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 728(%rsp)		
movq	%rbx, 736(%rsp)		

movq    464(%rsp), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    672(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    680(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    704(%rsp), %rax
mulq	424(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    432(%rsp), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    664(%rsp), %rax
mulq	408(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    672(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    680(%rsp), %rax
mulq	424(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	432(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	712(%rsp), %rax

movq	mask56, %rdi

movq    %r8, %rdx
shrd    $56, %r9, %rdx
shrq    $56, %r9
addq    %rdx, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %r14
adcq    %r13, %r15
andq    %rdi, %r10

movq    %r14, %r11
shrd    $56, %r15, %r14
shrq    $56, %r15
addq    %r14, %rax
adcq    720(%rsp), %r15
andq    %rdi, %r11

movq    %rax, %r12
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    728(%rsp), %rax
adcq    736(%rsp), %r15
andq    %rdi, %r12

movq    %rax, %r13
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    %rax, %rcx
adcq    %r15, %rsi
andq    %rdi, %r13

movq    %rcx, %r14
shrd    $56, %rsi, %rcx
shrq    $56, %rsi
addq    %rbp, %rcx
adcq    %rbx, %rsi
andq    %rdi, %r14

movq    %rcx, %r15
shrd    $52, %rsi, %rcx
shrq    $52, %rsi

movq	$17, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$17, %rsi, %rsi
addq	%rdx, %rsi

addq    %rcx, %r8
adcq    $0, %rsi
andq    mask52, %r15

shld    $8, %r8, %rsi
addq    %rsi, %r9
andq    %rdi, %r8

movq    %r8,  408(%rsp) 
movq    %r9,  416(%rsp)
movq    %r10, 424(%rsp)
movq    %r11, 432(%rsp)
movq    %r12, 440(%rsp)
movq    %r13, 448(%rsp)
movq    %r14, 456(%rsp)
movq    %r15, 464(%rsp)

// X3
movq    264(%rsp), %r8  
movq    272(%rsp), %r9
movq    280(%rsp), %r10
movq    288(%rsp), %r11
movq    296(%rsp), %r12
movq    304(%rsp), %r13
movq    312(%rsp), %r14
movq    320(%rsp), %r15

// copy X3
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi
movq    %r14, %rdi

// X3 ← X3 + Z3
addq    328(%rsp), %r8
addq    336(%rsp), %r9
addq    344(%rsp), %r10
addq    352(%rsp), %r11
addq    360(%rsp), %r12
addq    368(%rsp), %r13
addq    376(%rsp), %r14
addq    384(%rsp), %r15

movq    %r8,  264(%rsp) 
movq    %r9,  272(%rsp)
movq    %r10, 280(%rsp)
movq    %r11, 288(%rsp)
movq    %r12, 296(%rsp)
movq    %r13, 304(%rsp)
movq    %r14, 312(%rsp)
movq    320(%rsp), %r14
movq    %r15, 320(%rsp)

// Z3 ← X3 - Z3
addq    _2p0,   %rax
addq    _2p1_6, %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rdx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p7,   %r14

subq    328(%rsp), %rax
subq    336(%rsp), %rbx
subq    344(%rsp), %rcx
subq    352(%rsp), %rdx
subq    360(%rsp), %rbp
subq    368(%rsp), %rsi
subq    376(%rsp), %rdi
subq    384(%rsp), %r14

movq    %rax, 328(%rsp) 
movq    %rbx, 336(%rsp)
movq    %rcx, 344(%rsp)
movq    %rdx, 352(%rsp)
movq    %rbp, 360(%rsp)
movq    %rsi, 368(%rsp)
movq    %rdi, 376(%rsp)
movq    %r14, 384(%rsp)

// Z3 ← Z3^2
movq    384(%rsp), %rax
shlq    $1, %rax
movq	%rax, 664(%rsp)
mulq	336(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    376(%rsp), %rax
shlq    $1, %rax
movq	%rax, 672(%rsp)
mulq    344(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    368(%rsp), %rax
shlq    $1, %rax
movq	%rax, 680(%rsp)
mulq    352(%rsp)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    360(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    328(%rsp), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    664(%rsp), %rax
mulq	344(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    672(%rsp), %rax
mulq    352(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    680(%rsp), %rax
mulq    360(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    336(%rsp), %rax
shlq	$1, %rax
mulq	328(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    664(%rsp), %rax
mulq	352(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    672(%rsp), %rax
mulq    360(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    368(%rsp), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    344(%rsp), %rax
shlq    $1, %rax
movq    %rax, 688(%rsp)
mulq	328(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    336(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    664(%rsp), %rax
mulq    360(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    672(%rsp), %rax
mulq    368(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    352(%rsp), %rax
shlq    $1, %rax
movq    %rax, 696(%rsp)
mulq	328(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    688(%rsp), %rax
mulq	336(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    664(%rsp), %rax		
mulq    368(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    376(%rsp), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    360(%rsp), %rax
shlq    $1, %rax
movq    %rax, 704(%rsp)
mulq	328(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	336(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    344(%rsp), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 712(%rsp)		
movq	%rbx, 720(%rsp)		

movq    664(%rsp), %rax
mulq    376(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    680(%rsp), %rax
mulq	328(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	336(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	344(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 728(%rsp)		
movq	%rbx, 736(%rsp)		

movq    384(%rsp), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    672(%rsp), %rax
mulq	328(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    680(%rsp), %rax
mulq	336(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    704(%rsp), %rax
mulq	344(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    352(%rsp), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    664(%rsp), %rax
mulq	328(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    672(%rsp), %rax
mulq	336(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    680(%rsp), %rax
mulq	344(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	352(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	712(%rsp), %rax

movq	mask56, %rdi

movq    %r8, %rdx
shrd    $56, %r9, %rdx
shrq    $56, %r9
addq    %rdx, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %r14
adcq    %r13, %r15
andq    %rdi, %r10

movq    %r14, %r11
shrd    $56, %r15, %r14
shrq    $56, %r15
addq    %r14, %rax
adcq    720(%rsp), %r15
andq    %rdi, %r11

movq    %rax, %r12
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    728(%rsp), %rax
adcq    736(%rsp), %r15
andq    %rdi, %r12

movq    %rax, %r13
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    %rax, %rcx
adcq    %r15, %rsi
andq    %rdi, %r13

movq    %rcx, %r14
shrd    $56, %rsi, %rcx
shrq    $56, %rsi
addq    %rbp, %rcx
adcq    %rbx, %rsi
andq    %rdi, %r14

movq    %rcx, %r15
shrd    $52, %rsi, %rcx
shrq    $52, %rsi

movq	$17, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$17, %rsi, %rsi
addq	%rdx, %rsi

addq    %rcx, %r8
adcq    $0, %rsi
andq    mask52, %r15

shld    $8, %r8, %rsi
addq    %rsi, %r9
andq    %rdi, %r8

movq    %r8,  328(%rsp) 
movq    %r9,  336(%rsp)
movq    %r10, 344(%rsp)
movq    %r11, 352(%rsp)
movq    %r12, 360(%rsp)
movq    %r13, 368(%rsp)
movq    %r14, 376(%rsp)
movq    %r15, 384(%rsp)

// X3 ← X3^2
movq    320(%rsp), %rax
shlq    $1, %rax
movq	%rax, 664(%rsp)
mulq	272(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    312(%rsp), %rax
shlq    $1, %rax
movq	%rax, 672(%rsp)
mulq    280(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    304(%rsp), %rax
shlq    $1, %rax
movq	%rax, 680(%rsp)
mulq    288(%rsp)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    296(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    264(%rsp), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    664(%rsp), %rax
mulq	280(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    672(%rsp), %rax
mulq    288(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    680(%rsp), %rax
mulq    296(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    272(%rsp), %rax
shlq	$1, %rax
mulq	264(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    664(%rsp), %rax
mulq	288(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    672(%rsp), %rax
mulq    296(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    304(%rsp), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    280(%rsp), %rax
shlq    $1, %rax
movq    %rax, 688(%rsp)
mulq	264(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    272(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    664(%rsp), %rax
mulq    296(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    672(%rsp), %rax
mulq    304(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    288(%rsp), %rax
shlq    $1, %rax
movq    %rax, 696(%rsp)
mulq	264(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    688(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    664(%rsp), %rax		
mulq    304(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    312(%rsp), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    296(%rsp), %rax
shlq    $1, %rax
movq    %rax, 704(%rsp)
mulq	264(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    280(%rsp), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 712(%rsp)		
movq	%rbx, 720(%rsp)		

movq    664(%rsp), %rax
mulq    312(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    680(%rsp), %rax
mulq	264(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	280(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 728(%rsp)		
movq	%rbx, 736(%rsp)		

movq    320(%rsp), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    672(%rsp), %rax
mulq	264(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    680(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    704(%rsp), %rax
mulq	280(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    288(%rsp), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    664(%rsp), %rax
mulq	264(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    672(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    680(%rsp), %rax
mulq	280(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	288(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	712(%rsp), %rax

movq	mask56, %rdi

movq    %r8, %rdx
shrd    $56, %r9, %rdx
shrq    $56, %r9
addq    %rdx, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %r14
adcq    %r13, %r15
andq    %rdi, %r10

movq    %r14, %r11
shrd    $56, %r15, %r14
shrq    $56, %r15
addq    %r14, %rax
adcq    720(%rsp), %r15
andq    %rdi, %r11

movq    %rax, %r12
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    728(%rsp), %rax
adcq    736(%rsp), %r15
andq    %rdi, %r12

movq    %rax, %r13
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    %rax, %rcx
adcq    %r15, %rsi
andq    %rdi, %r13

movq    %rcx, %r14
shrd    $56, %rsi, %rcx
shrq    $56, %rsi
addq    %rbp, %rcx
adcq    %rbx, %rsi
andq    %rdi, %r14

movq    %rcx, %r15
shrd    $52, %rsi, %rcx
shrq    $52, %rsi

movq	$17, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$17, %rsi, %rsi
addq	%rdx, %rsi

addq    %rcx, %r8
adcq    $0, %rsi
andq    mask52, %r15

shld    $8, %r8, %rsi
addq    %rsi, %r9
andq    %rdi, %r8

// update X3
movq    %r8,  264(%rsp) 
movq    %r9,  272(%rsp)
movq    %r10, 280(%rsp)
movq    %r11, 288(%rsp)
movq    %r12, 296(%rsp)
movq    %r13, 304(%rsp)
movq    %r14, 312(%rsp)
movq    %r15, 320(%rsp)

// T3 ← T1 - T2
movq    408(%rsp), %rbx
movq    416(%rsp), %rcx
movq    424(%rsp), %rbp
movq    432(%rsp), %rsi
movq    440(%rsp), %rdi
movq    448(%rsp), %r13
movq    456(%rsp), %r14
movq    464(%rsp), %r15

addq    _2p0,   %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p1_6, %r13
addq    _2p1_6, %r14
addq    _2p7,   %r15

subq    472(%rsp), %rbx
subq    480(%rsp), %rcx
subq    488(%rsp), %rbp
subq    496(%rsp), %rsi
subq    504(%rsp), %rdi
subq    512(%rsp), %r13
subq    520(%rsp), %r14
subq    528(%rsp), %r15

movq    %rbx, 536(%rsp) 
movq    %rcx, 544(%rsp)
movq    %rbp, 552(%rsp)
movq    %rsi, 560(%rsp)
movq    %rdi, 568(%rsp)
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)
movq    %r15, 592(%rsp)

// T4 ← ((A + 2)/4) · T3
movq    %rbx,  %rax
mulq    a24x2e8
shrq    $8,  %rax
movq    %rax, %r8
movq    %rdx, %r9

movq    %rcx,  %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r9
movq    %rdx, %r10

movq    %rbp,  %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r10
movq    %rdx, %r11

movq    %rsi,  %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r11
movq    %rdx, %r12

movq    %rdi,  %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r12
movq    %rdx, %r13

movq    576(%rsp), %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r13
movq    %rdx, %r14

movq    584(%rsp), %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r14
movq    %rdx, %r15

movq    592(%rsp), %rax
mulq    a24x2e12
shrq    $12,  %rax
addq    %rax, %r15
imul    $17, %rdx, %rdx
addq    %rdx, %r8

// T4 ← T4 + T2
addq    472(%rsp), %r8
addq    480(%rsp), %r9
addq    488(%rsp), %r10
addq    496(%rsp), %r11
addq    504(%rsp), %r12
addq    512(%rsp), %r13
addq    520(%rsp), %r14
addq    528(%rsp), %r15

// update Z2
movq    %r8,  600(%rsp) 
movq    %r9,  608(%rsp)
movq    %r10, 616(%rsp)
movq    %r11, 624(%rsp)
movq    %r12, 632(%rsp)
movq    %r13, 640(%rsp)
movq    %r14, 648(%rsp)
movq    %r15, 656(%rsp)

// X2 ← T1 · T2
movq    416(%rsp), %rax
mulq	528(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    424(%rsp), %rax
mulq	520(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    432(%rsp), %rax
mulq	512(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    440(%rsp), %rax
mulq	504(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    448(%rsp), %rax
mulq	496(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    456(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    464(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    408(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    440(%rsp), %rax		
mulq	528(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    448(%rsp), %rax		
mulq	520(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    456(%rsp), %rax		
mulq	512(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    464(%rsp), %rax		
mulq	504(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    408(%rsp), %rax
mulq	496(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    416(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    424(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    432(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    448(%rsp), %rax		
mulq	528(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    456(%rsp), %rax		
mulq	520(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    464(%rsp), %rax		
mulq	512(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    408(%rsp), %rax
mulq	504(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    416(%rsp), %rax
mulq	496(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    424(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    432(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    440(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 664(%rsp)
movq	%r11, 672(%rsp)

movq    456(%rsp), %rax		
mulq	528(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    464(%rsp), %rax		
mulq	520(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    408(%rsp), %rax
mulq	512(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    416(%rsp), %rax
mulq	504(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    424(%rsp), %rax
mulq	496(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    432(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    440(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    448(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 680(%rsp)		
movq	%r11, 688(%rsp)		

movq    424(%rsp), %rax
mulq	528(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    432(%rsp), %rax
mulq	520(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    440(%rsp), %rax
mulq	512(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    448(%rsp), %rax
mulq	504(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    456(%rsp), %rax
mulq	496(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    464(%rsp), %rax
mulq	488(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    408(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    416(%rsp), %rax
mulq	472(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    432(%rsp), %rax
mulq	528(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    440(%rsp), %rax
mulq	520(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    448(%rsp), %rax
mulq	512(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    456(%rsp), %rax
mulq	504(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    464(%rsp), %rax
mulq	496(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    408(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    416(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    424(%rsp), %rax
mulq	472(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    464(%rsp), %rax		
mulq	528(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    408(%rsp), %rax
mulq	520(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    416(%rsp), %rax
mulq	512(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    424(%rsp), %rax
mulq	504(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    432(%rsp), %rax
mulq	496(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    440(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    448(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    456(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    408(%rsp), %rax
mulq	528(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    416(%rsp), %rax
mulq	520(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    424(%rsp), %rax
mulq	512(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    432(%rsp), %rax
mulq	504(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    440(%rsp), %rax
mulq	496(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    448(%rsp), %rax
mulq	488(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    456(%rsp), %rax
mulq	480(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    464(%rsp), %rax
mulq	472(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	664(%rsp), %rdx

movq	mask56, %rdi

movq    %r8, %rax
shrd    $56, %r9, %rax
shrq    $56, %r9
addq    %rax, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %rsi
adcq    %r13, %rcx
andq    %rdi, %r10

movq    %rsi, %r11
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rdx, %rsi
adcq    672(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    680(%rsp), %rsi
adcq    688(%rsp), %rcx
andq    %rdi, %r12

movq    %rsi, %r13
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %r14, %rsi
adcq    %r15, %rcx
andq    %rdi, %r13

movq    %rsi, %r14
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rsi, %rbp
adcq    %rcx, %rbx
andq    %rdi, %r14

movq    %rbp, %r15
shrd    $52, %rbx, %rbp
shrq    $52, %rbx

movq	$17, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$17, %rbx, %rbx
addq	%rdx, %rbx

addq    %rbp, %r8
adcq    $0, %rbx
andq    mask52, %r15

shld    $8, %r8, %rbx
addq    %rbx, %r9
andq    %rdi, %r8

// update X2
movq    %r8,  136(%rsp) 
movq    %r9,  144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)
movq    %r12, 168(%rsp)
movq    %r13, 176(%rsp)
movq    %r14, 184(%rsp)
movq    %r15, 192(%rsp)

// Z2 ← T3 · T4
movq    544(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    552(%rsp), %rax
mulq	648(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    560(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    568(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    576(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    584(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    592(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    536(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    568(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    576(%rsp), %rax		
mulq	648(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    584(%rsp), %rax		
mulq	640(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    592(%rsp), %rax		
mulq	632(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    536(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    544(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    552(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    560(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    576(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    584(%rsp), %rax		
mulq	648(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    592(%rsp), %rax		
mulq	640(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    536(%rsp), %rax
mulq	632(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    544(%rsp), %rax
mulq	624(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    552(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    560(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    568(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 664(%rsp)
movq	%r11, 672(%rsp)

movq    584(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    592(%rsp), %rax		
mulq	648(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    536(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    544(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    552(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    560(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    568(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    576(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 680(%rsp)		
movq	%r11, 688(%rsp)		

movq    552(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    560(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    568(%rsp), %rax
mulq	640(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    576(%rsp), %rax
mulq	632(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    584(%rsp), %rax
mulq	624(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    592(%rsp), %rax
mulq	616(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    536(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    544(%rsp), %rax
mulq	600(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    560(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    568(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    576(%rsp), %rax
mulq	640(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    584(%rsp), %rax
mulq	632(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    592(%rsp), %rax
mulq	624(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    536(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    544(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    552(%rsp), %rax
mulq	600(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    592(%rsp), %rax		
mulq	656(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    536(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    544(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    552(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    560(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    568(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    576(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    584(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    536(%rsp), %rax
mulq	656(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    544(%rsp), %rax
mulq	648(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    552(%rsp), %rax
mulq	640(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    560(%rsp), %rax
mulq	632(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    568(%rsp), %rax
mulq	624(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    576(%rsp), %rax
mulq	616(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    584(%rsp), %rax
mulq	608(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    592(%rsp), %rax
mulq	600(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	664(%rsp), %rdx

movq	mask56, %rdi

movq    %r8, %rax
shrd    $56, %r9, %rax
shrq    $56, %r9
addq    %rax, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %rsi
adcq    %r13, %rcx
andq    %rdi, %r10

movq    %rsi, %r11
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rdx, %rsi
adcq    672(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    680(%rsp), %rsi
adcq    688(%rsp), %rcx
andq    %rdi, %r12

movq    %rsi, %r13
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %r14, %rsi
adcq    %r15, %rcx
andq    %rdi, %r13

movq    %rsi, %r14
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rsi, %rbp
adcq    %rcx, %rbx
andq    %rdi, %r14

movq    %rbp, %r15
shrd    $52, %rbx, %rbp
shrq    $52, %rbx

movq	$17, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$17, %rbx, %rbx
addq	%rdx, %rbx

addq    %rbp, %r8
adcq    $0, %rbx
andq    mask52, %r15

shld    $8, %r8, %rbx
addq    %rbx, %r9
andq    %rdi, %r8

movq    %r8,  200(%rsp) 
movq    %r9,  208(%rsp)
movq    %r10, 216(%rsp)
movq    %r11, 224(%rsp)
movq    %r12, 232(%rsp)
movq    %r13, 240(%rsp)
movq    %r14, 248(%rsp)
movq    %r15, 256(%rsp)

// Z3 ← Z3 · X1
movq    336(%rsp), %rax
mulq	128(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    344(%rsp), %rax
mulq	120(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    352(%rsp), %rax
mulq	112(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    360(%rsp), %rax
mulq	104(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    368(%rsp), %rax
mulq	96(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    376(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    384(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    328(%rsp), %rax
mulq	72(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    360(%rsp), %rax		
mulq	128(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    368(%rsp), %rax		
mulq	120(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    376(%rsp), %rax		
mulq	112(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    384(%rsp), %rax		
mulq	104(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    328(%rsp), %rax
mulq	96(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    336(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    344(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    352(%rsp), %rax
mulq	72(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    368(%rsp), %rax		
mulq	128(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    376(%rsp), %rax		
mulq	120(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    384(%rsp), %rax		
mulq	112(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    328(%rsp), %rax
mulq	104(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    336(%rsp), %rax
mulq	96(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    344(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    360(%rsp), %rax
mulq	72(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 664(%rsp)
movq	%r11, 672(%rsp)

movq    376(%rsp), %rax		
mulq	128(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    384(%rsp), %rax		
mulq	120(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    328(%rsp), %rax
mulq	112(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    336(%rsp), %rax
mulq	104(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    344(%rsp), %rax
mulq	96(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    360(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    368(%rsp), %rax
mulq	72(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 680(%rsp)		
movq	%r11, 688(%rsp)		

movq    344(%rsp), %rax
mulq	128(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    352(%rsp), %rax
mulq	120(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    360(%rsp), %rax
mulq	112(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    368(%rsp), %rax
mulq	104(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    376(%rsp), %rax
mulq	96(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    384(%rsp), %rax
mulq	88(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    328(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    336(%rsp), %rax
mulq	72(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    352(%rsp), %rax
mulq	128(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    360(%rsp), %rax
mulq	120(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    368(%rsp), %rax
mulq	112(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    376(%rsp), %rax
mulq	104(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    384(%rsp), %rax
mulq	96(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    328(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    336(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    344(%rsp), %rax
mulq	72(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    384(%rsp), %rax		
mulq	128(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    328(%rsp), %rax
mulq	120(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    336(%rsp), %rax
mulq	112(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    344(%rsp), %rax
mulq	104(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    352(%rsp), %rax
mulq	96(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    360(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    368(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    376(%rsp), %rax
mulq	72(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    328(%rsp), %rax
mulq	128(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    336(%rsp), %rax
mulq	120(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    344(%rsp), %rax
mulq	112(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    352(%rsp), %rax
mulq	104(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    360(%rsp), %rax
mulq	96(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    368(%rsp), %rax
mulq	88(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    376(%rsp), %rax
mulq	80(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    384(%rsp), %rax
mulq	72(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	664(%rsp), %rdx

movq	mask56, %rdi

movq    %r8, %rax
shrd    $56, %r9, %rax
shrq    $56, %r9
addq    %rax, %r10
adcq    %r9, %r11
andq    %rdi, %r8

movq    %r10, %r9
shrd    $56, %r11, %r10
shrq    $56, %r11
addq    %r10, %r12
adcq    %r11, %r13
andq    %rdi, %r9

movq    %r12, %r10
shrd    $56, %r13, %r12
shrq    $56, %r13
addq    %r12, %rsi
adcq    %r13, %rcx
andq    %rdi, %r10

movq    %rsi, %r11
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rdx, %rsi
adcq    672(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    680(%rsp), %rsi
adcq    688(%rsp), %rcx
andq    %rdi, %r12

movq    %rsi, %r13
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %r14, %rsi
adcq    %r15, %rcx
andq    %rdi, %r13

movq    %rsi, %r14
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    %rsi, %rbp
adcq    %rcx, %rbx
andq    %rdi, %r14

movq    %rbp, %r15
shrd    $52, %rbx, %rbp
shrq    $52, %rbx

movq	$17, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$17, %rbx, %rbx
addq	%rdx, %rbx

addq    %rbp, %r8
adcq    $0, %rbx
andq    mask52, %r15

shld    $8, %r8, %rbx
addq    %rbx, %r9
andq    %rdi, %r8

// update Z3
movq    %r8,  328(%rsp) 
movq    %r9,  336(%rsp)
movq    %r10, 344(%rsp)
movq    %r11, 352(%rsp)
movq    %r12, 360(%rsp)
movq    %r13, 368(%rsp)
movq    %r14, 376(%rsp)
movq    %r15, 384(%rsp)

movb    392(%rsp),%cl
subb    $1,%cl
movb    %cl,392(%rsp)
cmpb	$0,%cl
jge     .L2

movb    $7,392(%rsp)
movq    64(%rsp),%rax
movq    400(%rsp),%r15
subq    $1,%r15
movq    %r15,400(%rsp)
cmpq	$0,%r15
jge     .L1

movq    56(%rsp),  %rdi

movq    136(%rsp),  %r8 
movq    144(%rsp),  %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11
movq    168(%rsp), %r12
movq    176(%rsp), %r13
movq    184(%rsp), %r14
movq    192(%rsp), %r15

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)
movq    %r15, 56(%rdi)

movq    200(%rsp),  %r8 
movq    208(%rsp),  %r9
movq    216(%rsp), %r10
movq    224(%rsp), %r11
movq    232(%rsp), %r12
movq    240(%rsp), %r13
movq    248(%rsp), %r14
movq    256(%rsp), %r15

// store final value of Z2
movq    %r8,   64(%rdi) 
movq    %r9,   72(%rdi)
movq    %r10,  80(%rdi)
movq    %r11,  88(%rdi)
movq    %r12,  96(%rdi)
movq    %r13, 104(%rdi)
movq    %r14, 112(%rdi)
movq    %r15, 120(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
