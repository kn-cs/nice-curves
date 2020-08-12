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
subq 	$232, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbp, 40(%rsp)
movq 	%rbx, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq    0(%rsi),   %r8
movq    8(%rsi),   %r9
movq    16(%rsi), %r10
movq    24(%rsi), %r11
movq    32(%rsi), %r12
movq    40(%rsi), %r13
movq    48(%rsi), %r14

movq    %r8,  64(%rsp)
movq    %r9,  72(%rsp)
movq    %r10, 80(%rsp)
movq    %r11, 88(%rsp)
movq    %r12, 96(%rsp)
movq    %r13, 104(%rsp)
movq    %r14, 112(%rsp)

movq    0(%rdx),   %r8
movq    8(%rdx),   %r9
movq    16(%rdx), %r10
movq    24(%rdx), %r11
movq    32(%rdx), %r12
movq    40(%rdx), %r13
movq    48(%rdx), %r14

movq    %r8,  120(%rsp)
movq    %r9,  128(%rsp)
movq    %r10, 136(%rsp)
movq    %r11, 144(%rsp)
movq    %r12, 152(%rsp)
movq    %r13, 160(%rsp)
movq    %r14, 168(%rsp)
 
movq    120(%rsp), %rdx    

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %rcx, %r10
addq    %rcx, %r9

mulx    80(%rsp), %rcx, %r11
adcq    %rcx, %r10

mulx    88(%rsp), %rcx, %r12
adcq    %rcx, %r11

mulx    96(%rsp), %rcx, %r13
adcq    %rcx, %r12

mulx    104(%rsp), %rcx, %r14
adcq    %rcx, %r13

mulx    112(%rsp), %rcx, %r15
adcq    %rcx, %r14
adcq    $0, %r15

movq    %r8, 176(%rsp)
movq    %r9, 184(%rsp)

movq    128(%rsp), %rdx

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %rcx, %rax
addq    %rcx, %r9

mulx    80(%rsp), %rcx, %rbx
adcq    %rcx, %rax

mulx    88(%rsp), %rcx, %rbp
adcq    %rcx, %rbx

mulx    96(%rsp), %rcx, %rsi
adcq    %rcx, %rbp

mulx    104(%rsp), %rcx, %rdi
adcq    %rcx, %rsi

mulx    112(%rsp), %rdx, %rcx
adcq    %rdx, %rdi
adcq    $0, %rcx

addq    184(%rsp), %r8
adcq    %r10, %r9
adcq    %rax, %r11
adcq    %rbx, %r12
adcq    %rbp, %r13
adcq    %rsi, %r14
adcq    %rdi, %r15
adcq    $0,   %rcx

movq    %r8, 184(%rsp)
movq    %r9, 192(%rsp)

movq    136(%rsp), %rdx

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %r10, %rax
addq    %r10, %r9

mulx    80(%rsp), %r10, %rbx
adcq    %r10, %rax

mulx    88(%rsp), %r10, %rbp
adcq    %r10, %rbx

mulx    96(%rsp), %r10, %rsi
adcq    %r10, %rbp

mulx    104(%rsp), %r10, %rdi
adcq    %r10, %rsi

mulx    112(%rsp), %rdx, %r10
adcq    %rdx, %rdi
adcq    $0, %r10

addq    192(%rsp), %r8
adcq    %r11,  %r9
adcq    %rax, %r12
adcq    %rbx, %r13
adcq    %rbp, %r14
adcq    %rsi, %r15
adcq    %rdi, %rcx
adcq    $0,   %r10

movq    %r8, 192(%rsp)
movq    %r9, 200(%rsp)

movq    144(%rsp), %rdx

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %r11, %rax
addq    %r11, %r9

mulx    80(%rsp), %r11, %rbx
adcq    %r11, %rax

mulx    88(%rsp), %r11, %rbp
adcq    %r11, %rbx

mulx    96(%rsp), %r11, %rsi
adcq    %r11, %rbp

mulx    104(%rsp), %r11, %rdi
adcq    %r11, %rsi

mulx    112(%rsp), %rdx, %r11
adcq    %rdx, %rdi
adcq    $0, %r11

addq    200(%rsp), %r8
adcq    %r12,  %r9
adcq    %rax, %r13
adcq    %rbx, %r14
adcq    %rbp, %r15
adcq    %rsi, %rcx
adcq    %rdi, %r10
adcq    $0,   %r11

movq    %r8, 200(%rsp)
movq    %r9, 208(%rsp)

movq    152(%rsp), %rdx

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %r12, %rax
addq    %r12, %r9

mulx    80(%rsp), %r12, %rbx
adcq    %r12, %rax

mulx    88(%rsp), %r12, %rbp
adcq    %r12, %rbx

mulx    96(%rsp), %r12, %rsi
adcq    %r12, %rbp

mulx    104(%rsp), %r12, %rdi
adcq    %r12, %rsi

mulx    112(%rsp), %rdx, %r12
adcq    %rdx, %rdi
adcq    $0, %r12

addq    208(%rsp), %r8
adcq    %r13,  %r9
adcq    %rax, %r14
adcq    %rbx, %r15
adcq    %rbp, %rcx
adcq    %rsi, %r10
adcq    %rdi, %r11
adcq    $0,   %r12

movq    %r8, 208(%rsp)
movq    %r9, 216(%rsp)

movq    160(%rsp), %rdx

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %r13, %rax
addq    %r13, %r9

mulx    80(%rsp), %r13, %rbx
adcq    %r13, %rax

mulx    88(%rsp), %r13, %rbp
adcq    %r13, %rbx

mulx    96(%rsp), %r13, %rsi
adcq    %r13, %rbp

mulx    104(%rsp), %r13, %rdi
adcq    %r13, %rsi

mulx    112(%rsp), %rdx, %r13
adcq    %rdx, %rdi
adcq    $0, %r13

addq    216(%rsp), %r8
adcq    %r14,  %r9
adcq    %rax, %r15
adcq    %rbx, %rcx
adcq    %rbp, %r10
adcq    %rsi, %r11
adcq    %rdi, %r12
adcq    $0,   %r13

movq    %r8, 216(%rsp)
movq    %r9, 224(%rsp)

movq    168(%rsp), %rdx

mulx    64(%rsp), %r8, %r9
mulx    72(%rsp), %r14, %rax
addq    %r14, %r9

mulx    80(%rsp), %r14, %rbx
adcq    %r14, %rax

mulx    88(%rsp), %r14, %rbp
adcq    %r14, %rbx

mulx    96(%rsp), %r14, %rsi
adcq    %r14, %rbp

mulx    104(%rsp), %r14, %rdi
adcq    %r14, %rsi

mulx    112(%rsp), %rdx, %r14
adcq    %rdx, %rdi
adcq    $0, %r14

addq    224(%rsp), %r8
adcq    %r15,  %r9
adcq    %rax, %rcx
adcq    %rbx, %r10
adcq    %rbp, %r11
adcq    %rsi, %r12
adcq    %rdi, %r13
adcq    $0,   %r14

movq    $272, %rdx

mulx    %r9,  %r9, %rbx
mulx    %rcx, %rcx, %r15
addq    %rbx, %rcx

mulx    %r10, %r10, %rbx
adcq    %r15, %r10

mulx    %r11, %r11, %r15
adcq    %rbx, %r11

mulx    %r12, %r12, %rbx
adcq    %r15, %r12

mulx    %r13, %r13, %r15
adcq    %rbx, %r13

mulx    %r14, %r14, %rbx
adcq    %r15, %r14
adcq    $0, %rbx

addq    176(%rsp), %r9
adcq    184(%rsp), %rcx
adcq    192(%rsp), %r10
adcq    200(%rsp), %r11
adcq    208(%rsp), %r12
adcq    216(%rsp), %r13
adcq    %r8, %r14
adcq    $0,  %rbx

shld    $4, %r14, %rbx
andq	mask60, %r14

imul    $17, %rbx, %rbx
addq    %rbx, %r9
adcq    $0, %rcx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14

movq   	56(%rsp), %rdi

movq   	%r9,   0(%rdi)
movq   	%rcx,  8(%rdi)
movq   	%r10, 16(%rdi)
movq   	%r11, 24(%rdi)
movq   	%r12, 32(%rdi)
movq   	%r13, 40(%rdi)
movq   	%r14, 48(%rdi)

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

movq    0(%rdi),  %r8
movq    8(%rdi),  %r9
movq    48(%rdi), %r10

movq    %r10, %r11
shrq    $60, %r11
andq	mask60, %r10

imul    $17, %r11, %r11
addq    %r11, %r8
adcq    $0, %r9

movq    %r8,   0(%rdi)
movq    %r9,   8(%rdi)
movq    %r10, 48(%rdi)

ret
