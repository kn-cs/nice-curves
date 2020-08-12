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
.globl gfp44417nsqr
gfp44417nsqr:

movq 	%rsp, %r11
subq 	$152, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbp, 40(%rsp)
movq 	%rbx, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq 	 0(%rsi), %r8	
movq 	 8(%rsi), %r9	
movq 	16(%rsi), %r10	
movq 	24(%rsi), %r11
movq 	32(%rsi), %r12
movq 	40(%rsi), %r13
movq 	48(%rsi), %r14
movq 	56(%rsi), %r15

movq 	%r8,   0(%rdi)
movq 	%r9,   8(%rdi)
movq 	%r10, 16(%rdi)
movq 	%r11, 24(%rdi)
movq 	%r12, 32(%rdi)
movq 	%r13, 40(%rdi)
movq 	%r14, 48(%rdi)
movq 	%r15, 56(%rdi)

mov  	%rdx, %rcx

.START:

subq  	$1, %rcx
movq 	%rcx, 144(%rsp)

movq    56(%rdi), %rax
shlq    $1, %rax
movq	%rax, 64(%rsp)
mulq	8(%rdi)
movq    %rax, %r8
movq    %rdx, %r9

movq    48(%rdi), %rax
shlq    $1, %rax
movq	%rax, 72(%rsp)
mulq    16(%rdi)		
addq    %rax, %r8
adcq    %rdx, %r9    

movq    40(%rdi), %rax
shlq    $1, %rax
movq	%rax, 80(%rsp)
mulq    24(%rdi)	
addq    %rax, %r8
adcq    %rdx, %r9 

movq    32(%rdi), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %r9

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    0(%rdi), %rax
mulq	%rax
addq    %rax, %r8
adcq    %rdx, %r9

movq    64(%rsp), %rax
mulq	16(%rdi)
movq    %rax, %r10
movq    %rdx, %r11

movq    72(%rsp), %rax
mulq    24(%rdi)
addq    %rax, %r10
adcq    %rdx, %r11    

movq    80(%rsp), %rax
mulq    32(%rdi)
addq    %rax, %r10
adcq    %rdx, %r11 

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    8(%rdi), %rax
shlq	$1, %rax
mulq	0(%rdi)
addq    %rax, %r10
adcq    %rdx, %r11

movq    64(%rsp), %rax
mulq	24(%rdi)		
movq    %rax, %r12
movq    %rdx, %r13

movq    72(%rsp), %rax
mulq    32(%rdi)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    40(%rdi), %rax
mulq    %rax
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    16(%rdi), %rax
shlq    $1, %rax
movq    %rax, 88(%rsp)
mulq	0(%rdi)
addq    %rax, %r12
adcq    %rdx, %r13

movq    8(%rdi), %rax
mulq	%rax
addq    %rax, %r12
adcq   	%rdx, %r13

movq    64(%rsp), %rax
mulq    32(%rdi)		
movq    %rax, %r14
movq    %rdx, %r15   

movq    72(%rsp), %rax
mulq    40(%rdi)		
addq    %rax, %r14
adcq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    24(%rdi), %rax
shlq    $1, %rax
movq    %rax, 96(%rsp)
mulq	0(%rdi)
addq    %rax, %r14
adcq    %rdx, %r15

movq    88(%rsp), %rax
mulq	8(%rdi)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    64(%rsp), %rax		
mulq    40(%rdi)		
movq    %rax, %rbp
movq    %rdx, %rbx   

movq    48(%rdi), %rax
mulq    %rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    32(%rdi), %rax
shlq    $1, %rax
movq    %rax, 104(%rsp)
mulq	0(%rdi)
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    96(%rsp), %rax
mulq	8(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    16(%rdi), %rax
mulq	%rax
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 112(%rsp)		
movq	%rbx, 120(%rsp)		

movq    64(%rsp), %rax
mulq    48(%rdi)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq	$272, %rax
mulq	%rbp
movq	%rax, %rbp
imul 	$272, %rbx, %rbx
addq	%rdx, %rbx

movq    80(%rsp), %rax
mulq	0(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    104(%rsp), %rax
mulq	8(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    96(%rsp), %rax
mulq	16(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	%rbp, 128(%rsp)		
movq	%rbx, 136(%rsp)		

movq    56(%rdi), %rax
mulq    %rax
movq    %rax, %rcx
movq    %rdx, %rsi

movq	$272, %rax
mulq	%rcx
movq	%rax, %rcx
imul 	$272, %rsi, %rsi
addq	%rdx, %rsi

movq    72(%rsp), %rax
mulq	0(%rdi)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    80(%rsp), %rax
mulq	8(%rdi)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    104(%rsp), %rax
mulq	16(%rdi)		
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    24(%rdi), %rax
mulq	%rax
addq    %rax, %rcx
adcq    %rdx, %rsi

movq    64(%rsp), %rax
mulq	0(%rdi)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    72(%rsp), %rax
mulq	8(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    80(%rsp), %rax
mulq	16(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    104(%rsp), %rax
mulq	24(%rdi)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	112(%rsp), %rax

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
adcq    120(%rsp), %r15
andq    %rdi, %r11

movq    %rax, %r12
shrd    $56, %r15, %rax
shrq    $56, %r15
addq    128(%rsp), %rax
adcq    136(%rsp), %r15
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

movq   	56(%rsp), %rdi

movq   	%r8,  0(%rdi)
movq   	%r9,  8(%rdi)
movq   	%r10, 16(%rdi)
movq   	%r11, 24(%rdi)
movq   	%r12, 32(%rdi)
movq   	%r13, 40(%rdi)
movq   	%r14, 48(%rdi)
movq   	%r15, 56(%rdi)

movq 	144(%rsp), %rcx
cmpq    $0, %rcx

jne     .START

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbp
movq 	48(%rsp), %rbx

movq 	%r11, %rsp

ret
