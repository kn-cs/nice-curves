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
.globl M4058_mladder_base
M4058_mladder_base:

movq 	%rsp, %r11
subq 	$680, %rsp

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
movq	$0, 104(%rsp)
movq	$0, 112(%rsp)
movq	$0, 120(%rsp)
movq	$0, 128(%rsp)  

// Z2 ← 0
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)

// X3 ← XP
movq	0(%rsi), %r8
movq	%r8, 200(%rsp)
movq	8(%rsi), %r8
movq	%r8, 208(%rsp)
movq	16(%rsi), %r8
movq	%r8, 216(%rsp)
movq	24(%rsi), %r8
movq	%r8, 224(%rsp)
movq	32(%rsi), %r8
movq	%r8, 232(%rsp)
movq	40(%rsi), %r8
movq	%r8, 240(%rsp)
movq	48(%rsi), %r8
movq	%r8, 248(%rsp)
movq	56(%rsi), %r8
movq	%r8, 256(%rsp)

// Z3 ← 1
movq	$1, 264(%rsp)
movq	$0, 272(%rsp)
movq	$0, 280(%rsp)
movq	$0, 288(%rsp)
movq	$0, 296(%rsp)
movq	$0, 304(%rsp)
movq	$0, 312(%rsp)
movq	$0, 320(%rsp)

movq    $55, 336(%rsp)
movb	$3, 328(%rsp)
movb    $0, 330(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:

addq    336(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 332(%rsp)

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
movq    72(%rsp), %r8  
movq    80(%rsp), %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11
movq    104(%rsp), %r12
movq    112(%rsp), %r13
movq    120(%rsp), %r14
movq    128(%rsp), %r15

// copy X2
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi
movq    %r14, %rdi

// T1 ← X2 + Z2
addq    136(%rsp), %r8
addq    144(%rsp), %r9
addq    152(%rsp), %r10
addq    160(%rsp), %r11
addq    168(%rsp), %r12
addq    176(%rsp), %r13
addq    184(%rsp), %r14
addq    192(%rsp), %r15

movq    %r8,  344(%rsp) 
movq    %r9,  352(%rsp)
movq    %r10, 360(%rsp)
movq    %r11, 368(%rsp)
movq    %r12, 376(%rsp)
movq    %r13, 384(%rsp)
movq    %r14, 392(%rsp)
movq    %r15, 400(%rsp)

movq    128(%rsp), %r15

// T2 ← X2 - Z2
addq    _2p0,   %rax
addq    _2p1_6, %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rdx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p7,   %r15

subq    136(%rsp), %rax
subq    144(%rsp), %rbx
subq    152(%rsp), %rcx
subq    160(%rsp), %rdx
subq    168(%rsp), %rbp
subq    176(%rsp), %rsi
subq    184(%rsp), %rdi
subq    192(%rsp), %r15

movq    %rax, 408(%rsp) 
movq    %rbx, 416(%rsp)
movq    %rcx, 424(%rsp)
movq    %rdx, 432(%rsp)
movq    %rbp, 440(%rsp)
movq    %rsi, 448(%rsp)
movq    %rdi, 456(%rsp)
movq    %r15, 464(%rsp)

// X3
movq    200(%rsp), %r8  
movq    208(%rsp), %r9
movq    216(%rsp), %r10
movq    224(%rsp), %r11
movq    232(%rsp), %r12
movq    240(%rsp), %r13
movq    248(%rsp), %r14
movq    256(%rsp), %r15

// copy X3
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi
movq    %r14, %rdi

// T3 ← X3 + Z3
addq    264(%rsp), %r8
addq    272(%rsp), %r9
addq    280(%rsp), %r10
addq    288(%rsp), %r11
addq    296(%rsp), %r12
addq    304(%rsp), %r13
addq    312(%rsp), %r14
addq    320(%rsp), %r15

movq    %r8,  472(%rsp) 
movq    %r9,  480(%rsp)
movq    %r10, 488(%rsp)
movq    %r11, 496(%rsp)
movq    %r12, 504(%rsp)
movq    %r13, 512(%rsp)
movq    %r14, 520(%rsp)
movq    %r15, 528(%rsp)

movq    256(%rsp), %r15

// T4 ← X3 - Z3
addq    _2p0,   %rax
addq    _2p1_6, %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rdx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p7,   %r15

subq    264(%rsp), %rax
subq    272(%rsp), %rbx
subq    280(%rsp), %rcx
subq    288(%rsp), %rdx
subq    296(%rsp), %rbp
subq    304(%rsp), %rsi
subq    312(%rsp), %rdi
subq    320(%rsp), %r15

movq    %rax, 536(%rsp) 
movq    %rbx, 544(%rsp)
movq    %rcx, 552(%rsp)
movq    %rdx, 560(%rsp)
movq    %rbp, 568(%rsp)
movq    %rsi, 576(%rsp)
movq    %rdi, 584(%rsp)
movq    %r15, 592(%rsp)

// Z3 ← T2 · T3
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

movq	%r10, 600(%rsp)
movq	%r11, 608(%rsp)

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

movq	%r10, 616(%rsp)		
movq	%r11, 624(%rsp)		

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

movq	600(%rsp), %rdx

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
adcq    608(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    616(%rsp), %rsi
adcq    624(%rsp), %rcx
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

// X3 ← T1 · T4
movq    352(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    360(%rsp), %rax
mulq	584(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    368(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    376(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    384(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    392(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    400(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    344(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    376(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    384(%rsp), %rax		
mulq	584(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    392(%rsp), %rax		
mulq	576(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    400(%rsp), %rax		
mulq	568(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    344(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    352(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    360(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    368(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    384(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    392(%rsp), %rax		
mulq	584(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    400(%rsp), %rax		
mulq	576(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    344(%rsp), %rax
mulq	568(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	560(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    360(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    368(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    376(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 600(%rsp)
movq	%r11, 608(%rsp)

movq    392(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    400(%rsp), %rax		
mulq	584(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    344(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    360(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    368(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    376(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    384(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 616(%rsp)		
movq	%r11, 624(%rsp)		

movq    360(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    368(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    376(%rsp), %rax
mulq	576(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    384(%rsp), %rax
mulq	568(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    392(%rsp), %rax
mulq	560(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    400(%rsp), %rax
mulq	552(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    344(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	536(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    368(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    376(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    384(%rsp), %rax
mulq	576(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    392(%rsp), %rax
mulq	568(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    400(%rsp), %rax
mulq	560(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    344(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    352(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    360(%rsp), %rax
mulq	536(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    400(%rsp), %rax		
mulq	592(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    344(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    352(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    360(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    368(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    376(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    384(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    392(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    344(%rsp), %rax
mulq	592(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    352(%rsp), %rax
mulq	584(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    360(%rsp), %rax
mulq	576(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    368(%rsp), %rax
mulq	568(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    376(%rsp), %rax
mulq	560(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    384(%rsp), %rax
mulq	552(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    392(%rsp), %rax
mulq	544(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    400(%rsp), %rax
mulq	536(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	600(%rsp), %rdx

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
adcq    608(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    616(%rsp), %rsi
adcq    624(%rsp), %rcx
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

movb	328(%rsp), %cl
movb	332(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    330(%rsp), %bl
movb    %cl, 330(%rsp)

cmpb    $1, %bl

// CSelect(T1,T3,select)
movq    344(%rsp), %r8
movq    352(%rsp), %r9
movq    360(%rsp), %r10
movq    368(%rsp), %r11
movq    376(%rsp), %r12
movq    384(%rsp), %r13
movq    392(%rsp), %r14
movq    400(%rsp), %r15

movq    472(%rsp), %rax
movq    480(%rsp), %rbx
movq    488(%rsp), %rcx
movq    496(%rsp), %rdx
movq    504(%rsp), %rbp
movq    512(%rsp), %rsi
movq    520(%rsp), %rdi

cmove   %rax, %r8
cmove   %rbx, %r9
cmove   %rcx, %r10
cmove   %rdx, %r11
cmove   %rbp, %r12
cmove   %rsi, %r13
cmove   %rdi, %r14
movq    528(%rsp), %rdi
cmove   %rdi, %r15

movq    %r8,  344(%rsp)
movq    %r9,  352(%rsp)
movq    %r10, 360(%rsp)
movq    %r11, 368(%rsp)
movq    %r12, 376(%rsp)
movq    %r13, 384(%rsp)
movq    %r14, 392(%rsp)
movq    %r15, 400(%rsp)

// CSelect(T2,T4,select)
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

// T2 ← T2^2
movq    464(%rsp), %rax
shlq    $1, %rax
movq	%rax, 600(%rsp)
mulq	416(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    456(%rsp), %rax
shlq    $1, %rax
movq	%rax, 608(%rsp)
mulq    424(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    448(%rsp), %rax
shlq    $1, %rax
movq	%rax, 616(%rsp)
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

movq    600(%rsp), %rax
mulq	424(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    608(%rsp), %rax
mulq    432(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    616(%rsp), %rax
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

movq    600(%rsp), %rax
mulq	432(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    608(%rsp), %rax
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
movq    %rax, 624(%rsp)
mulq	408(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    416(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    600(%rsp), %rax
mulq    440(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    608(%rsp), %rax
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

movq    624(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    600(%rsp), %rax		
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

movq    600(%rsp), %rax
mulq    456(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    616(%rsp), %rax
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

movq    608(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    616(%rsp), %rax
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

movq    600(%rsp), %rax
mulq	408(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    608(%rsp), %rax
mulq	416(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    616(%rsp), %rax
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

// T1 ← T1^2
movq    400(%rsp), %rax
shlq    $1, %rax
movq	%rax, 600(%rsp)
mulq	352(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    392(%rsp), %rax
shlq    $1, %rax
movq	%rax, 608(%rsp)
mulq    360(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    384(%rsp), %rax
shlq    $1, %rax
movq	%rax, 616(%rsp)
mulq    368(%rsp)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    376(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    344(%rsp), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    600(%rsp), %rax
mulq	360(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    608(%rsp), %rax
mulq    368(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    616(%rsp), %rax
mulq    376(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    352(%rsp), %rax
shlq	$1, %rax
mulq	344(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    600(%rsp), %rax
mulq	368(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    608(%rsp), %rax
mulq    376(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    384(%rsp), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    360(%rsp), %rax
shlq    $1, %rax
movq    %rax, 624(%rsp)
mulq	344(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    352(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    600(%rsp), %rax
mulq    376(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    608(%rsp), %rax
mulq    384(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    368(%rsp), %rax
shlq    $1, %rax
movq    %rax, 696(%rsp)
mulq	344(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    624(%rsp), %rax
mulq	352(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    600(%rsp), %rax		
mulq    384(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    392(%rsp), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    376(%rsp), %rax
shlq    $1, %rax
movq    %rax, 704(%rsp)
mulq	344(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	352(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    360(%rsp), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 712(%rsp)		
movq	%rbx, 720(%rsp)		

movq    600(%rsp), %rax
mulq    392(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    616(%rsp), %rax
mulq	344(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	352(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	360(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 728(%rsp)		
movq	%rbx, 736(%rsp)		

movq    400(%rsp), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    608(%rsp), %rax
mulq	344(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    616(%rsp), %rax
mulq	352(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    704(%rsp), %rax
mulq	360(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    368(%rsp), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    600(%rsp), %rax
mulq	344(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    608(%rsp), %rax
mulq	352(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    616(%rsp), %rax
mulq	360(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	368(%rsp)		
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

movq    %r8,  344(%rsp) 
movq    %r9,  352(%rsp)
movq    %r10, 360(%rsp)
movq    %r11, 368(%rsp)
movq    %r12, 376(%rsp)
movq    %r13, 384(%rsp)
movq    %r14, 392(%rsp)
movq    %r15, 400(%rsp)

// X3
movq    200(%rsp), %r8  
movq    208(%rsp), %r9
movq    216(%rsp), %r10
movq    224(%rsp), %r11
movq    232(%rsp), %r12
movq    240(%rsp), %r13
movq    248(%rsp), %r14
movq    256(%rsp), %r15

// copy X3
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi
movq    %r14, %rdi

// X3 ← X3 + Z3
addq    264(%rsp), %r8
addq    272(%rsp), %r9
addq    280(%rsp), %r10
addq    288(%rsp), %r11
addq    296(%rsp), %r12
addq    304(%rsp), %r13
addq    312(%rsp), %r14
addq    320(%rsp), %r15

movq    %r8,  200(%rsp) 
movq    %r9,  208(%rsp)
movq    %r10, 216(%rsp)
movq    %r11, 224(%rsp)
movq    %r12, 232(%rsp)
movq    %r13, 240(%rsp)
movq    %r14, 248(%rsp)
movq    256(%rsp), %r14
movq    %r15, 256(%rsp)

// Z3 ← X3 - Z3
addq    _2p0,   %rax
addq    _2p1_6, %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rdx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p7,   %r14

subq    264(%rsp), %rax
subq    272(%rsp), %rbx
subq    280(%rsp), %rcx
subq    288(%rsp), %rdx
subq    296(%rsp), %rbp
subq    304(%rsp), %rsi
subq    312(%rsp), %rdi
subq    320(%rsp), %r14

movq    %rax, 264(%rsp) 
movq    %rbx, 272(%rsp)
movq    %rcx, 280(%rsp)
movq    %rdx, 288(%rsp)
movq    %rbp, 296(%rsp)
movq    %rsi, 304(%rsp)
movq    %rdi, 312(%rsp)
movq    %r14, 320(%rsp)

// Z3 ← Z3^2
movq    320(%rsp), %rax
shlq    $1, %rax
movq	%rax, 600(%rsp)
mulq	272(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    312(%rsp), %rax
shlq    $1, %rax
movq	%rax, 608(%rsp)
mulq    280(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    304(%rsp), %rax
shlq    $1, %rax
movq	%rax, 616(%rsp)
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

movq    600(%rsp), %rax
mulq	280(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    608(%rsp), %rax
mulq    288(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    616(%rsp), %rax
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

movq    600(%rsp), %rax
mulq	288(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    608(%rsp), %rax
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
movq    %rax, 624(%rsp)
mulq	264(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    272(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    600(%rsp), %rax
mulq    296(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    608(%rsp), %rax
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

movq    624(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    600(%rsp), %rax		
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

movq    600(%rsp), %rax
mulq    312(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    616(%rsp), %rax
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

movq    608(%rsp), %rax
mulq	264(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    616(%rsp), %rax
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

movq    600(%rsp), %rax
mulq	264(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    608(%rsp), %rax
mulq	272(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    616(%rsp), %rax
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

movq    %r8,  264(%rsp) 
movq    %r9,  272(%rsp)
movq    %r10, 280(%rsp)
movq    %r11, 288(%rsp)
movq    %r12, 296(%rsp)
movq    %r13, 304(%rsp)
movq    %r14, 312(%rsp)
movq    %r15, 320(%rsp)

// X3 ← X3^2
movq    256(%rsp), %rax
shlq    $1, %rax
movq	%rax, 600(%rsp)
mulq	208(%rsp)
movq    %rax, %r8
movq    %rdx, %r9

movq    248(%rsp), %rax
shlq    $1, %rax
movq	%rax, 608(%rsp)
mulq    216(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    240(%rsp), %rax
shlq    $1, %rax
movq	%rax, 616(%rsp)
mulq    224(%rsp)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    232(%rsp), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    200(%rsp), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    600(%rsp), %rax
mulq	216(%rsp)
movq    %rax, %r10
movq    %rdx, %r11

movq    608(%rsp), %rax
mulq    224(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    616(%rsp), %rax
mulq    232(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    208(%rsp), %rax
shlq	$1, %rax
mulq	200(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    600(%rsp), %rax
mulq	224(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    608(%rsp), %rax
mulq    232(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    240(%rsp), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    216(%rsp), %rax
shlq    $1, %rax
movq    %rax, 624(%rsp)
mulq	200(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    208(%rsp), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    600(%rsp), %rax
mulq    232(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    608(%rsp), %rax
mulq    240(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    224(%rsp), %rax
shlq    $1, %rax
movq    %rax, 696(%rsp)
mulq	200(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    624(%rsp), %rax
mulq	208(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    600(%rsp), %rax		
mulq    240(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    248(%rsp), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    232(%rsp), %rax
shlq    $1, %rax
movq    %rax, 704(%rsp)
mulq	200(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	208(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    216(%rsp), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 712(%rsp)		
movq	%rbx, 720(%rsp)		

movq    600(%rsp), %rax
mulq    248(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    616(%rsp), %rax
mulq	200(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	208(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    696(%rsp), %rax
mulq	216(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 728(%rsp)		
movq	%rbx, 736(%rsp)		

movq    256(%rsp), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    608(%rsp), %rax
mulq	200(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    616(%rsp), %rax
mulq	208(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    704(%rsp), %rax
mulq	216(%rsp)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    224(%rsp), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    600(%rsp), %rax
mulq	200(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    608(%rsp), %rax
mulq	208(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    616(%rsp), %rax
mulq	216(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    704(%rsp), %rax
mulq	224(%rsp)		
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
movq    %r8,  200(%rsp) 
movq    %r9,  208(%rsp)
movq    %r10, 216(%rsp)
movq    %r11, 224(%rsp)
movq    %r12, 232(%rsp)
movq    %r13, 240(%rsp)
movq    %r14, 248(%rsp)
movq    %r15, 256(%rsp)

// T3 ← T1 - T2
movq    344(%rsp), %rbx
movq    352(%rsp), %rcx
movq    360(%rsp), %rbp
movq    368(%rsp), %rsi
movq    376(%rsp), %rdi
movq    384(%rsp), %r13
movq    392(%rsp), %r14
movq    400(%rsp), %r15

addq    _2p0,   %rbx
addq    _2p1_6, %rcx
addq    _2p1_6, %rbp
addq    _2p1_6, %rsi
addq    _2p1_6, %rdi
addq    _2p1_6, %r13
addq    _2p1_6, %r14
addq    _2p7,   %r15

subq    408(%rsp), %rbx
subq    416(%rsp), %rcx
subq    424(%rsp), %rbp
subq    432(%rsp), %rsi
subq    440(%rsp), %rdi
subq    448(%rsp), %r13
subq    456(%rsp), %r14
subq    464(%rsp), %r15

movq    %rbx, 472(%rsp) 
movq    %rcx, 480(%rsp)
movq    %rbp, 488(%rsp)
movq    %rsi, 496(%rsp)
movq    %rdi, 504(%rsp)
movq    %r13, 512(%rsp)
movq    %r14, 520(%rsp)
movq    %r15, 528(%rsp)

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

movq    512(%rsp), %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r13
movq    %rdx, %r14

movq    520(%rsp), %rax
mulq    a24x2e8
shrq    $8,  %rax
addq    %rax, %r14
movq    %rdx, %r15

movq    528(%rsp), %rax
mulq    a24x2e12
shrq    $12,  %rax
addq    %rax, %r15
imul    $17, %rdx, %rdx
addq    %rdx, %r8

// T4 ← T4 + T2
addq    408(%rsp), %r8
addq    416(%rsp), %r9
addq    424(%rsp), %r10
addq    432(%rsp), %r11
addq    440(%rsp), %r12
addq    448(%rsp), %r13
addq    456(%rsp), %r14
addq    464(%rsp), %r15

movq    %r8,  536(%rsp) 
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)
movq    %r11, 560(%rsp)
movq    %r12, 568(%rsp)
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)
movq    %r15, 592(%rsp)

// X2 ← T1 · T2
movq    352(%rsp), %rax
mulq	464(%rsp)		
movq    %rax, %r8
movq    %rdx, %r9

movq    360(%rsp), %rax
mulq	456(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9

movq    368(%rsp), %rax
mulq	448(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    376(%rsp), %rax
mulq	440(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    384(%rsp), %rax
mulq	432(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    392(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    400(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    344(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    376(%rsp), %rax		
mulq	464(%rsp)		
movq    %rax, %rsi
movq    %rdx, %rcx

movq    384(%rsp), %rax		
mulq	456(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    392(%rsp), %rax		
mulq	448(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    400(%rsp), %rax		
mulq	440(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq	$272, %rax
mulq	%rsi
movq	%rax, %rsi
imul 	$272, %rcx, %rcx
addq	%rdx, %rcx

movq    344(%rsp), %rax
mulq	432(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    352(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    360(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    368(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %rsi
adcq    %rdx, %rcx

movq    384(%rsp), %rax		
mulq	464(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    392(%rsp), %rax		
mulq	456(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    400(%rsp), %rax		
mulq	448(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    344(%rsp), %rax
mulq	440(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	432(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq    360(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    368(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    376(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 600(%rsp)
movq	%r11, 608(%rsp)

movq    392(%rsp), %rax		
mulq	464(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    400(%rsp), %rax		
mulq	456(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    344(%rsp), %rax
mulq	448(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	440(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    360(%rsp), %rax
mulq	432(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    368(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    376(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    384(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 616(%rsp)		
movq	%r11, 624(%rsp)		

movq    360(%rsp), %rax
mulq	464(%rsp)		
movq    %rax, %r10
movq    %rdx, %r11

movq    368(%rsp), %rax
mulq	456(%rsp)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    376(%rsp), %rax
mulq	448(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    384(%rsp), %rax
mulq	440(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    392(%rsp), %rax
mulq	432(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    400(%rsp), %rax
mulq	424(%rsp)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    344(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %r10
adcq    %rdx, %r11

movq    352(%rsp), %rax
mulq	408(%rsp)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    368(%rsp), %rax
mulq	464(%rsp)		
movq    %rax, %r12
movq    %rdx, %r13

movq    376(%rsp), %rax
mulq	456(%rsp)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    384(%rsp), %rax
mulq	448(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    392(%rsp), %rax
mulq	440(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    400(%rsp), %rax
mulq	432(%rsp)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    344(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %r12
adcq    %rdx, %r13

movq    352(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    360(%rsp), %rax
mulq	408(%rsp)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    400(%rsp), %rax		
mulq	464(%rsp)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    344(%rsp), %rax
mulq	456(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    352(%rsp), %rax
mulq	448(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    360(%rsp), %rax
mulq	440(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    368(%rsp), %rax
mulq	432(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    376(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    384(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %r14
adcq    %rdx, %r15

movq    392(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    344(%rsp), %rax
mulq	464(%rsp)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    352(%rsp), %rax
mulq	456(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    360(%rsp), %rax
mulq	448(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    368(%rsp), %rax
mulq	440(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    376(%rsp), %rax
mulq	432(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    384(%rsp), %rax
mulq	424(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    392(%rsp), %rax
mulq	416(%rsp)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    400(%rsp), %rax
mulq	408(%rsp)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	600(%rsp), %rdx

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
adcq    608(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    616(%rsp), %rsi
adcq    624(%rsp), %rcx
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
movq    %r8,  72(%rsp) 
movq    %r9,  80(%rsp)
movq    %r10, 88(%rsp)
movq    %r11, 96(%rsp)
movq    %r12, 104(%rsp)
movq    %r13, 112(%rsp)
movq    %r14, 120(%rsp)
movq    %r15, 128(%rsp)

// Z2 ← T3 · T4
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

movq	%r10, 600(%rsp)
movq	%r11, 608(%rsp)

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

movq	%r10, 616(%rsp)		
movq	%r11, 624(%rsp)		

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

movq	600(%rsp), %rdx

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
adcq    608(%rsp), %rcx
andq    %rdi, %r11

movq    %rsi, %r12
shrd    $56, %rcx, %rsi
shrq    $56, %rcx
addq    616(%rsp), %rsi
adcq    624(%rsp), %rcx
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

// update Z2
movq    %r8,  136(%rsp) 
movq    %r9,  144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)
movq    %r12, 168(%rsp)
movq    %r13, 176(%rsp)
movq    %r14, 184(%rsp)
movq    %r15, 192(%rsp)

// Z3 ← Z3 · X1
movq    264(%rsp),  %rax
mulq    bpx2e8
shrq    $8,  %rax
movq    %rax, %r8
movq    %rdx, %r9

movq    272(%rsp),  %rax
mulq    bpx2e8
shrq    $8,  %rax
addq    %rax, %r9
movq    %rdx, %r10

movq    280(%rsp),  %rax
mulq    bpx2e8
shrq    $8,  %rax
addq    %rax, %r10
movq    %rdx, %r11

movq    288(%rsp),  %rax
mulq    bpx2e8
shrq    $8,  %rax
addq    %rax, %r11
movq    %rdx, %r12

movq    296(%rsp),  %rax
mulq    bpx2e8
shrq    $8,  %rax
addq    %rax, %r12
movq    %rdx, %r13

movq    304(%rsp), %rax
mulq    bpx2e8
shrq    $8,  %rax
addq    %rax, %r13
movq    %rdx, %r14

movq    312(%rsp), %rax
mulq    bpx2e8
shrq    $8,  %rax
addq    %rax, %r14
movq    %rdx, %r15

movq    320(%rsp), %rax
mulq    bpx2e12
shrq    $12,  %rax
addq    %rax, %r15
imul    $17, %rdx, %rdx
addq    %rdx, %r8

// update Z3
movq    %r8,  264(%rsp) 
movq    %r9,  272(%rsp)
movq    %r10, 280(%rsp)
movq    %r11, 288(%rsp)
movq    %r12, 296(%rsp)
movq    %r13, 304(%rsp)
movq    %r14, 312(%rsp)
movq    %r15, 320(%rsp)

movb    328(%rsp),%cl
subb    $1,%cl
movb    %cl,328(%rsp)
cmpb	$0,%cl
jge     .L2

movb    $7,328(%rsp)
movq    64(%rsp),%rax
movq    336(%rsp),%r15
subq    $1,%r15
movq    %r15,336(%rsp)
cmpq	$0,%r15
jge     .L1

movq    56(%rsp),  %rdi

movq    72(%rsp),  %r8 
movq    80(%rsp),  %r9
movq    88(%rsp), %r10
movq    96(%rsp), %r11
movq    104(%rsp), %r12
movq    112(%rsp), %r13
movq    120(%rsp), %r14
movq    128(%rsp), %r15

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)
movq    %r15, 56(%rdi)

movq    136(%rsp),  %r8 
movq    144(%rsp),  %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11
movq    168(%rsp), %r12
movq    176(%rsp), %r13
movq    184(%rsp), %r14
movq    192(%rsp), %r15

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
