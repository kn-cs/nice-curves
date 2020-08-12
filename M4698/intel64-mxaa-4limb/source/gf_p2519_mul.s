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
.globl gfp2519mul
gfp2519mul:

movq 	%rsp, %r11
subq 	$64, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbp, 40(%rsp)
movq 	%rbx, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq    %rdx, %rdi

movq    0(%rdi), %rdx    

mulx    0(%rsi), %r8, %r9
mulx    8(%rsi), %rcx, %r10
addq    %rcx, %r9

mulx    16(%rsi), %rcx, %r11
adcq    %rcx, %r10

mulx    24(%rsi), %rcx, %r12
adcq    %rcx, %r11
adcq    $0, %r12

movq    8(%rdi), %rdx    

mulx    0(%rsi), %rax, %rbx
mulx    8(%rsi), %rcx, %rbp
addq    %rcx, %rbx

mulx    16(%rsi), %rcx, %r15
adcq    %rcx, %rbp

mulx    24(%rsi), %rcx, %r13
adcq    %rcx, %r15
adcq    $0, %r13

addq    %rax, %r9
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %r15, %r12
adcq    $0,   %r13

movq    16(%rdi), %rdx

mulx    0(%rsi), %rax, %rbx
mulx    8(%rsi), %rcx, %rbp
addq    %rcx, %rbx

mulx    16(%rsi), %rcx, %r15
adcq    %rcx, %rbp

mulx    24(%rsi), %rcx, %r14
adcq    %rcx, %r15
adcq    $0, %r14

addq    %rax, %r10
adcq    %rbx, %r11
adcq    %rbp, %r12
adcq    %r15, %r13
adcq    $0,   %r14

movq    24(%rdi), %rdx

mulx    0(%rsi), %rax, %rbx
mulx    8(%rsi), %rcx, %rbp
addq    %rcx, %rbx

mulx    16(%rsi), %rcx, %r15
adcq    %rcx, %rbp

mulx    24(%rsi), %rcx, %rsi
adcq    %rcx, %r15
adcq    $0, %rsi

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %r15, %r14
adcq    $0,   %rsi

movq    $288, %rdx

mulx    %r12, %r12, %rbx
mulx    %r13, %r13, %rcx
addq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %rcx, %r14

mulx    %rsi, %r15, %rcx
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

movq 	56(%rsp), %rdi

movq   	%r8,  0(%rdi)
movq   	%r9,  8(%rdi)
movq   	%r10, 16(%rdi)
movq   	%r11, 24(%rdi)

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
.globl gfp2519reduce
gfp2519reduce:

movq    0(%rdi),   %r8
movq    8(%rdi),   %r9
movq    24(%rdi), %r10

movq    %r10, %r11
shrq    $59, %r11
andq	mask59, %r10

imul    $9, %r11, %r11
addq    %r11, %r8
adcq    $0, %r9

movq    %r8,   0(%rdi)
movq    %r9,   8(%rdi)
movq    %r10, 24(%rdi)

ret
