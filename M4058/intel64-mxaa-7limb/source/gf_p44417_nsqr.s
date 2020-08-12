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
subq 	$88, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbp, 40(%rsp)
movq 	%rbx, 48(%rsp)

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
movq 	%rcx, 80(%rsp)

movq    0(%rdi), %rdx
    
mulx    8(%rdi), %r9, %r10

mulx    16(%rdi), %rcx, %r11
addq    %rcx, %r10

mulx    24(%rdi), %rcx, %r12
adcq    %rcx, %r11

mulx    32(%rdi), %rcx, %r13
adcq    %rcx, %r12

mulx    40(%rdi), %rcx, %r14
adcq    %rcx, %r13

mulx    48(%rdi), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    8(%rdi), %rdx

mulx    16(%rdi), %rax, %rbx

mulx    24(%rdi), %rcx, %rbp
addq    %rcx, %rbx

mulx    32(%rdi), %rcx, %rsi
adcq    %rcx, %rbp

mulx    40(%rdi), %rcx, %r8
adcq    %rcx, %rsi

mulx    48(%rdi), %rdx, %rcx
adcq    %rdx, %r8
adcq    $0, %rcx

addq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %r8,  %r15
adcq    $0,   %rcx

movq    16(%rdi), %rdx

mulx    24(%rdi), %rax, %rbx

mulx    32(%rdi), %r8, %rbp
addq    %r8, %rbx

mulx    40(%rdi), %r8, %rsi
adcq    %r8, %rbp

mulx    48(%rdi), %rdx, %r8
adcq    %rdx, %rsi
adcq    $0, %r8

addq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    $0,    %r8

movq    24(%rdi), %rdx

mulx    32(%rdi), %rax, %rbx

mulx    40(%rdi), %rsi, %rbp
addq    %rsi, %rbx

mulx    48(%rdi), %rdx, %rsi
adcq    %rdx, %rbp
adcq    $0, %rsi

addq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp,  %r8
adcq    $0,   %rsi

movq    32(%rdi), %rdx

mulx    40(%rdi), %rax, %rbx

mulx    48(%rdi), %rdx, %rbp
addq    %rdx, %rbx
adcq    $0, %rbp

addq    %rax,  %r8
adcq    %rbx, %rsi
adcq    $0,   %rbp

movq    40(%rdi), %rdx

mulx    48(%rdi), %rax, %rbx

addq    %rax, %rbp
adcq    $0,   %rbx

mov     $0, %rax
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

movq    %r9,  56(%rsp)
movq    %r10, 64(%rsp)
movq    %r11, 72(%rsp)

movq    0(%rdi), %rdx
mulx    %rdx, %r11, %r10
addq    56(%rsp), %r10
movq    %r10, 56(%rsp)

movq    8(%rdi), %rdx
mulx    %rdx, %r9, %r10
adcq    64(%rsp), %r9
adcq    72(%rsp), %r10
movq    %r9,  64(%rsp)
movq    %r10, 72(%rsp)

movq    16(%rdi), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r12
adcq    %r10, %r13

movq    24(%rdi), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %r14
adcq    %r10, %r15

movq    32(%rdi), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rcx
adcq    %r10, %r8

movq    40(%rdi), %rdx
mulx    %rdx, %r9, %r10
adcq    %r9, %rsi
adcq    %r10, %rbp

movq    48(%rdi), %rdx
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

addq    %r15, %r11
adcq    56(%rsp), %rcx
adcq    64(%rsp), %r8
adcq    72(%rsp), %rsi
adcq    %rbp, %r12
adcq    %rbx, %r13
adcq    %rax, %r14
adcq    $0,   %r9

shld    $4, %r14, %r9
andq	mask60, %r14

imul    $17, %r9, %r9
addq    %r9, %r11
adcq    $0, %rcx
adcq    $0, %r8
adcq    $0, %rsi
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq   	%r11,  0(%rdi)
movq   	%rcx,  8(%rdi)
movq   	%r8,  16(%rdi)
movq   	%rsi, 24(%rdi)
movq   	%r12, 32(%rdi)
movq   	%r13, 40(%rdi)
movq   	%r14, 48(%rdi)

movq 	80(%rsp), %rcx
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
