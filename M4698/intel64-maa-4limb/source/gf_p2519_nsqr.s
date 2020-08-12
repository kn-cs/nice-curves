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
subq    $64, %rsp

movq    %r11,  0(%rsp)
movq    %r12,  8(%rsp)
movq    %r13, 16(%rsp)
movq    %r14, 24(%rsp)
movq    %r15, 32(%rsp)
movq    %rbx, 40(%rsp)
movq    %rbp, 48(%rsp)
movq    %rdi, 56(%rsp)

movq    0(%rsi),  %rbx
movq    8(%rsi),  %rbp
movq    16(%rsi), %rcx
movq    24(%rsi), %rsi

movq    %rdx, %rdi

.START:

subq    $1, %rdi

movq    %rsi, %rax
mulq    %rsi
movq    %rax, %r12
movq    $0, %r13

movq    $288, %rax
mulq    %rdx
movq    %rax, %r14
movq    %rdx, %r15

shlq    $1, %rsi

movq    %rbp, %rax
mulq    %rsi
movq    %rax, %r8
movq    $0, %r9
movq    %rdx, %r10
movq    $0, %r11

movq    %rcx, %rax
mulq    %rcx
addq    %rax, %r8
adcq    $0, %r9
addq    %rdx, %r10
adcq    $0, %r11

movq    %rcx, %rax
mulq    %rsi
addq    %rax, %r10
adcq    $0, %r11
addq    %rdx, %r12
adcq    $0, %r13

movq    $288, %rax
mulq    %r10
imul    $288, %r11, %r11
movq    %rax, %r10
addq    %rdx, %r11

movq    $288, %rax
mulq    %r12
imul    $288, %r13, %r13
movq    %rax, %r12
addq    %rdx, %r13

movq    %rbx, %rax
mulq    %rsi
addq    %rax, %r14
adcq    $0, %r15
addq    %rdx, %r8
adcq    $0, %r9

movq    %rbp, %rax
mulq    %rcx
addq    %rax, %r14
adcq    $0, %r15
addq    %rdx, %r8
adcq    $0, %r9

addq    %rax, %r14
adcq    $0, %r15
addq    %rdx, %r8
adcq    $0, %r9

movq    $288, %rax
mulq    %r8
imul    $288, %r9, %r9
movq    %rax, %r8
addq    %rdx, %r9

movq    %rbx, %rax
mulq    %rbx
addq    %rax, %r8
adcq    $0, %r9
addq    %rdx, %r10
adcq    $0, %r11

movq    %rbx, %rax
mulq    %rbp
addq    %rax, %r10
adcq    $0, %r11
addq    %rdx, %r12
adcq    $0, %r13

addq    %rax, %r10
adcq    $0, %r11
addq    %rdx, %r12
adcq    $0, %r13

movq    %rbx, %rax
mulq    %rcx
addq    %rax, %r12
adcq    $0, %r13
addq    %rdx, %r14
adcq    $0, %r15

addq    %rax, %r12
adcq    $0, %r13
addq    %rdx, %r14
adcq    $0, %r15

movq    %rbp, %rax
mulq    %rbp
addq    %rax, %r12
adcq    $0, %r13
addq    %rdx, %r14
adcq    $0, %r15

movq    %r10, %rbp
addq    %r9, %rbp
adcq    $0, %r11

movq    %r12, %rcx
addq    %r11, %rcx
adcq    $0, %r13

movq    %r14, %rsi
addq    %r13, %rsi
adcq    $0, %r15

shld    $5, %rsi, %r15
andq    mask59, %rsi

movq    %r15, %rbx
imul    $9, %rbx, %rbx

addq    %r8, %rbx
adcq    $0, %rbp
adcq    $0, %rcx
adcq    $0, %rsi

cmpq    $0, %rdi

jne     .START

movq    56(%rsp), %rdi

movq    %rbx,  0(%rdi)
movq    %rbp,  8(%rdi)
movq    %rcx, 16(%rdi)
movq    %rsi, 24(%rdi)

movq    0(%rsp),  %r11
movq    8(%rsp),  %r12
movq    16(%rsp), %r13
movq    24(%rsp), %r14
movq    32(%rsp), %r15
movq    40(%rsp), %rbx
movq    48(%rsp), %rbp

movq    %r11, %rsp

ret
