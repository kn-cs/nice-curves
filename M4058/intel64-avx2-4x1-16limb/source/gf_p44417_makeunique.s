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

.globl gfp44417makeunique
gfp44417makeunique:

movq    %rsp, %r11
subq    $56, %rsp

movq    %r11,  0(%rsp)
movq    %r12,  8(%rsp)
movq    %r13, 16(%rsp)
movq    %r14, 24(%rsp)
movq    %r15, 32(%rsp)
movq    %rbp, 40(%rsp)
movq    %rbx, 48(%rsp)

movq    0(%rdi), %r8
movq    8(%rdi), %r9
movq    16(%rdi), %r10
movq    24(%rdi), %r11
movq    32(%rdi), %r12
movq    40(%rdi), %r13
movq    48(%rdi), %r14

movq    %r8, %rax
movq    %r9, %rbx
movq    %r10, %rcx
movq    %r11, %rdx
movq    %r12, %rbp
movq    %r13, %rsi

subq    p0, %r8
sbbq    p1_5, %r9
sbbq    p1_5, %r10
sbbq    p1_5, %r11
sbbq    p1_5, %r12
sbbq    p1_5, %r13
sbbq    p6, %r14

movq    %r14, %r15
shlq    $4, %r15

cmovc   %rax, %r8
cmovc   %rbx, %r9
cmovc   %rcx, %r10
cmovc   %rdx, %r11
cmovc   %rbp, %r12
cmovc   %rsi, %r13

movq   	%r8, 0(%rdi)
movq   	%r9, 8(%rdi)
movq   	%r10, 16(%rdi)
movq   	%r11, 24(%rdi)
movq   	%r12, 32(%rdi)
movq   	%r13, 40(%rdi)

movq    48(%rdi), %rax
cmovc   %rax, %r15
movq   	%r15, 48(%rdi)

movq    8(%rsp),  %r12
movq    16(%rsp), %r13
movq    24(%rsp), %r14
movq    32(%rsp), %r15
movq    40(%rsp), %rbp
movq    48(%rsp), %rbx
movq    0(%rsp),  %rsp

ret
