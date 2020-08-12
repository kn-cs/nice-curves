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
.global gfp2519nsqr
gfp2519nsqr:

movq    %rsp, %r11
subq    $72, %rsp

movq    %r11,  0(%rsp)
movq    %r12,  8(%rsp)
movq    %r13, 16(%rsp)
movq    %r14, 24(%rsp)
movq    %r15, 32(%rsp)
movq    %rbx, 40(%rsp)
movq    %rbp, 48(%rsp)

movq    0(%rsi),   %r8
movq    8(%rsi),   %r9
movq    16(%rsi), %r10
movq    24(%rsi), %r11
movq    32(%rsi), %r12

movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)

movq    %rdx, %rsi

.START:

subq    $1, %rsi

movq    %r8, %rax
mulq    %r8
movq    %rax, %r10
movq    %rdx, %r11

addq    %r8, %r8   
movq    %r8, %rax
mulq    %r9
movq    %rax, %r12
movq    %rdx, %r13

movq    %r8, %rax
mulq    16(%rdi)
movq    %rax, %r14
movq    %rdx, %r15

movq    %r9, %rax
mulq    %r9
addq    %rax, %r14
adcq    %rdx, %r15

movq    %r8, %rax
mulq    24(%rdi)
movq    %rax, %rbx
movq    %rdx, %rbp

addq    %r9, %r9
movq    %r9, %rax
mulq    16(%rdi)
addq    %rax, %rbx
adcq    %rdx, %rbp

movq    %r8, %rax
mulq    32(%rdi)
movq    %rax, %r8
movq    %rdx, %rcx

movq    %r9, %rax
mulq    24(%rdi)
addq    %rax, %r8
adcq    %rdx, %rcx

movq    16(%rdi), %rax
mulq    %rax
addq    %rax, %r8
adcq    %rdx, %rcx

shld    $17, %r8,  %rcx

imul    $144, 24(%rdi), %rax
movq    %rax, 56(%rsp)
mulq    24(%rdi)
addq    %rax, %r12
adcq    %rdx, %r13

imul    $144, 32(%rdi), %rax
movq    %rax, 64(%rsp)
mulq    32(%rdi)
addq    %rax, %rbx
adcq    %rdx, %rbp

shld    $13, %rbx, %rbp

movq    64(%rsp), %rax
mulq    %r9
addq    %rax, %r10
adcq    %rdx, %r11

movq    56(%rsp), %rax
addq    %rax, %rax
mulq    16(%rdi)
addq    %rax, %r10
adcq    %rdx, %r11

shld    $13, %r10, %r11

movq    64(%rsp), %rax
addq    %rax, %rax
movq    %rax, 64(%rsp)
mulq    24(%rdi)
addq    %rax, %r14
adcq    %rdx, %r15

shld    $13, %r14, %r15

movq    64(%rsp), %rax
mulq    16(%rdi)
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

addq    %r11, %r12
addq    %r13, %r14
addq    %r15, %rbx
addq    %rbp, %r8
addq    %rcx, %r10

movq    %r10, %r11
shrq    $51, %r10
addq    %r12, %r10
andq    %rdx, %r11

movq    %r10, %r9
shrq    $51, %r10
addq    %r14, %r10
andq    %rdx, %r9

movq    %r10, %rax
shrq    $51, %rax
addq    %rbx, %rax
andq    %rdx, %r10

movq    %r10, 16(%rdi)

movq    %rax, %r10
shrq    $51, %rax
addq    %r8, %rax
andq    %rdx, %r10

movq    %r10, 24(%rdi)

movq    %rax, %r8
shrq    $47, %r8
addq    %r8, %r11
shlq    $3, %r8
addq    %r11, %r8
andq    mask47, %rax

movq    %rax, 32(%rdi)

cmpq    $0, %rsi

jne     .START

movq    %r8, 0(%rdi)
movq    %r9, 8(%rdi)

movq    0(%rsp),  %r11
movq    8(%rsp),  %r12
movq    16(%rsp), %r13
movq    24(%rsp), %r14
movq    32(%rsp), %r15
movq    40(%rsp), %rbx
movq    48(%rsp), %rbp

movq    %r11, %rsp

ret
