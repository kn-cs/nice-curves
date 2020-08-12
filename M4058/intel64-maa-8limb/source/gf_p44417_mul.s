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
.globl gfp44417mul
gfp44417mul:

movq 	%rsp, %r11
subq 	$160, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbp, 40(%rsp)
movq 	%rbx, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq	%rdx, %rcx

movq    8(%rsi), %rax
mulq	56(%rcx)		
movq    %rax, %r8
movq    %rdx, %r9

movq    16(%rsi), %rax
mulq    48(%rcx)
addq    %rax, %r8
adcq    %rdx, %r9

movq    24(%rsi), %rax
mulq    40(%rcx)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    32(%rsi), %rax
mulq    32(%rcx)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    40(%rsi), %rax
mulq    24(%rcx)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    48(%rsi), %rax
mulq    16(%rcx)
addq    %rax, %r8
adcq    %rdx, %r9 

movq    56(%rsi), %rax
mulq    8(%rcx)
addq    %rax, %r8
adcq    %rdx, %r9 

movq	$272, %rax
mulq	%r8
movq	%rax, %r8
imul 	$272, %r9, %r9
addq	%rdx, %r9

movq    0(%rsi), %rax
mulq	0(%rcx)		
addq    %rax, %r8
adcq    %rdx, %r9

movq    32(%rsi), %rax		
mulq    56(%rcx)		
movq    %rax, %r10
movq    %rdx, %r11

movq    40(%rsi), %rax		
mulq    48(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    48(%rsi), %rax		
mulq    40(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    56(%rsi), %rax		
mulq    32(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    0(%rsi), %rax
mulq	24(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    8(%rsi), %rax
mulq	16(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    16(%rsi), %rax
mulq	8(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    24(%rsi), %rax
mulq	0(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 112(%rsp)		
movq	%r11, 120(%rsp)		

movq    40(%rsi), %rax		
mulq    56(%rcx)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    48(%rsi), %rax		
mulq    48(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    56(%rsi), %rax		
mulq    40(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    0(%rsi), %rax
mulq	32(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    8(%rsi), %rax
mulq	24(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    16(%rsi), %rax
mulq	16(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    24(%rsi), %rax
mulq	8(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    32(%rsi), %rax
mulq	0(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 128(%rsp)
movq	%r11, 136(%rsp)

movq    48(%rsi), %rax		
mulq    56(%rcx)		
movq    %rax, %r10
movq    %rdx, %r11   

movq    56(%rsi), %rax		
mulq    48(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    0(%rsi), %rax
mulq	40(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    8(%rsi), %rax
mulq	32(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    16(%rsi), %rax
mulq	24(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    24(%rsi), %rax
mulq	16(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    32(%rsi), %rax
mulq	8(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq    40(%rsi), %rax
mulq	0(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11

movq	%r10, 144(%rsp)		
movq	%r11, 152(%rsp)		

movq    16(%rsi), %rax
mulq	56(%rcx)		
movq    %rax, %r10
movq    %rdx, %r11

movq    24(%rsi), %rax
mulq    48(%rcx)		
addq    %rax, %r10
adcq    %rdx, %r11    

movq    32(%rsi), %rax
mulq    40(%rcx)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    40(%rsi), %rax
mulq    32(%rcx)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    48(%rsi), %rax
mulq    24(%rcx)	
addq    %rax, %r10
adcq    %rdx, %r11 

movq    56(%rsi), %rax
mulq    16(%rcx)	
addq    %rax, %r10
adcq    %rdx, %r11

movq	$272, %rax
mulq	%r10
movq	%rax, %r10
imul 	$272, %r11, %r11
addq	%rdx, %r11

movq    0(%rsi), %rax
mulq	8(%rcx)
addq    %rax, %r10
adcq    %rdx, %r11

movq    8(%rsi), %rax
mulq	0(%rcx)
addq    %rax, %r10
adcq   	%rdx, %r11

movq    24(%rsi), %rax
mulq	56(%rcx)		
movq    %rax, %r12
movq    %rdx, %r13

movq    32(%rsi), %rax
mulq    48(%rcx)		
addq    %rax, %r12
adcq    %rdx, %r13    

movq    40(%rsi), %rax
mulq    40(%rcx)	
addq    %rax, %r12
adcq    %rdx, %r13

movq    48(%rsi), %rax
mulq    32(%rcx)	
addq    %rax, %r12
adcq    %rdx, %r13 

movq    56(%rsi), %rax
mulq    24(%rcx)	
addq    %rax, %r12
adcq    %rdx, %r13

movq	$272, %rax
mulq	%r12
movq	%rax, %r12
imul 	$272, %r13, %r13
addq	%rdx, %r13

movq    0(%rsi), %rax
mulq	16(%rcx)
addq    %rax, %r12
adcq    %rdx, %r13

movq    8(%rsi), %rax
mulq	8(%rcx)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    16(%rsi), %rax
mulq	0(%rcx)
addq    %rax, %r12
adcq   	%rdx, %r13

movq    56(%rsi), %rax		
mulq    56(%rcx)		
movq    %rax, %r14
movq    %rdx, %r15

movq	$272, %rax
mulq	%r14
movq	%rax, %r14
imul 	$272, %r15, %r15
addq	%rdx, %r15

movq    0(%rsi), %rax
mulq	48(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    8(%rsi), %rax
mulq	40(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    16(%rsi), %rax
mulq	32(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    24(%rsi), %rax
mulq	24(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    32(%rsi), %rax
mulq	16(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    40(%rsi), %rax
mulq	8(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    48(%rsi), %rax
mulq	0(%rcx)		
addq    %rax, %r14
adcq    %rdx, %r15

movq    0(%rsi), %rax
mulq	56(%rcx)		
movq    %rax, %rbp
movq    %rdx, %rbx

movq    8(%rsi), %rax
mulq	48(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    16(%rsi), %rax
mulq	40(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    24(%rsi), %rax
mulq	32(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    32(%rsi), %rax
mulq	24(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    40(%rsi), %rax
mulq	16(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    48(%rsi), %rax
mulq	8(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq    56(%rsi), %rax
mulq	0(%rcx)		
addq    %rax, %rbp
adcq    %rdx, %rbx

movq	112(%rsp), %rax
movq	120(%rsp), %rdx
movq	128(%rsp), %rcx

movq	mask56, %rdi

movq    %r8, %rsi
shrd    $56, %r9, %rsi
shrq    $56, %r9
addq    %rsi, %r10
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
addq    %r12, %rax
adcq    %r13, %rdx
andq    %rdi, %r10

movq    %rax, %r11
shrd    $56, %rdx, %rax
shrq    $56, %rdx
addq    %rcx, %rax
adcq    136(%rsp), %rdx
andq    %rdi, %r11

movq    %rax, %r12
shrd    $56, %rdx, %rax
shrq    $56, %rdx
addq    144(%rsp), %rax
adcq    152(%rsp), %rdx
andq    %rdi, %r12

movq    %rax, %r13
shrd    $56, %rdx, %rax
shrq    $56, %rdx
addq    %r14, %rax
adcq    %r15, %rdx
andq    %rdi, %r13

movq    %rax, %r14
shrd    $56, %rdx, %rax
shrq    $56, %rdx
addq    %rax, %rbp
adcq    %rdx, %rbx
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

movq   	56(%rsp), %rdi

movq   	%r8,  0(%rdi)
movq   	%r9,  8(%rdi)
movq   	%r10, 16(%rdi)
movq   	%r11, 24(%rdi)
movq   	%r12, 32(%rdi)
movq   	%r13, 40(%rdi)
movq   	%r14, 48(%rdi)
movq   	%r15, 56(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbp
movq 	48(%rsp), %rbx

movq 	%r11, %rsp

ret


.p2align 5
.globl gfp44417reduce
gfp44417reduce:

movq 	%rsp, %r11
subq 	$16, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)

movq    0(%rdi),   %r8
movq    8(%rdi),   %r9
movq    16(%rdi), %r10
movq    24(%rdi), %r11
movq    32(%rdi), %rax
movq    40(%rdi), %rcx
movq    48(%rdi), %rdx
movq    56(%rdi), %r12

movq	%r8, %rsi
shrq 	$56, %rsi
addq	%r9, %rsi
andq	mask56, %r8

movq	%rsi, %r9
shrq 	$56, %rsi
addq	%r10, %rsi
andq	mask56, %r9

movq	%rsi, %r10
shrq 	$56, %rsi
addq	%r11, %rsi
andq	mask56, %r10

movq	%rsi, %r11
shrq 	$56, %rsi
addq	%rax, %rsi
andq	mask56, %r11

movq	%rsi, %rax
shrq 	$56, %rsi
addq	%rcx, %rsi
andq	mask56, %rax

movq	%rsi, %rcx
shrq 	$56, %rsi
addq	%rdx, %rsi
andq	mask56, %rcx

movq	%rsi, %rdx
shrq 	$56, %rsi
addq	%r12, %rsi
andq	mask56, %rdx

movq	%rsi, %r12
shrq 	$52, %rsi
imul 	$17, %rsi, %rsi
addq	%rsi, %r8
andq	mask52, %r12

movq	%r8, %rsi
shrq 	$56, %rsi
addq	%rsi, %r9
andq	mask56, %r8

movq    %r8,   0(%rdi)
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %rax, 32(%rdi)
movq    %rcx, 40(%rdi)
movq    %rdx, 48(%rdi)
movq    %r12, 56(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12

movq 	%r11, %rsp

ret
