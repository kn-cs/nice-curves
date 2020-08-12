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
.globl M4698_mladder
M4698_mladder:

movq 	  %rsp,%r11
andq 	  $-32,%rsp
subq 	  $928,%rsp

movq 	  %r11,0(%rsp)
movq 	  %r12,8(%rsp)
movq 	  %r13,16(%rsp)
movq 	  %r14,24(%rsp)
movq 	  %r15,32(%rsp)
movq 	  %rbx,40(%rsp)
movq 	  %rbp,48(%rsp)

// load (0,0,1,X1)
vmovdqa   0(%rsi),  %ymm0
vmovdqa   32(%rsi), %ymm1
vmovdqa   64(%rsi), %ymm2
vmovdqa   96(%rsi), %ymm3
vmovdqa   128(%rsi),%ymm4
vmovdqa   160(%rsi),%ymm5
vmovdqa   192(%rsi),%ymm6
vmovdqa   224(%rsi),%ymm7
vmovdqa   256(%rsi),%ymm8

// <0',0',1',X1'> ← Pack-D2N(<0,0,1,X1>)
vpsllq    $32,%ymm4,%ymm4
vpor      %ymm4,%ymm0,%ymm0
vpsllq    $32,%ymm5,%ymm5
vpor      %ymm5,%ymm1,%ymm1
vpsllq    $32,%ymm6,%ymm6
vpor      %ymm6,%ymm2,%ymm2
vpsllq    $32,%ymm7,%ymm7
vpor      %ymm7,%ymm3,%ymm3

vmovdqa   %ymm0,0(%rsi)
vmovdqa   %ymm1,32(%rsi)
vmovdqa   %ymm2,64(%rsi)
vmovdqa   %ymm3,96(%rsi)
vmovdqa   %ymm8,128(%rsi)

// load <X2,Z2,X3,Z3>
vmovdqa   0(%rdi),  %ymm8
vmovdqa   32(%rdi), %ymm0
vmovdqa   64(%rdi), %ymm1
vmovdqa   96(%rdi), %ymm2
vmovdqa   128(%rdi),%ymm3
vmovdqa   160(%rdi),%ymm4
vmovdqa   192(%rdi),%ymm5
vmovdqa   224(%rdi),%ymm6
vmovdqa   256(%rdi),%ymm7

// <X2',Z2',X3',Z3'> ← Pack-D2N(<X2,Z2,X3,Z3>)
vpsllq    $32,%ymm3,%ymm3
vpor      %ymm3,%ymm8,%ymm8
vpsllq    $32,%ymm4,%ymm4
vpor      %ymm4,%ymm0,%ymm0
vpsllq    $32,%ymm5,%ymm5
vpor      %ymm5,%ymm1,%ymm1
vpsllq    $32,%ymm6,%ymm6
vpor      %ymm6,%ymm2,%ymm2

movq      $31,%r15
movq	  $2,%rcx

movb      $0,%r8b 
movq      %rdx,%rax

.L1:
addq      %r15,%rax
movb      0(%rax),%r14b
movq      %rdx,%rax

.L2:
movb	  %r14b,%bl
shrb      %cl,%bl
andb      $1,%bl
movb      %bl,%r9b
xorb      %r8b,%bl
movb      %r9b,%r8b

// <X2',Z2',X3',Z3'> ← Dense-Swap(<X2',Z2',X3',Z3'>,b)
movzbl    %bl,%ebx
imul	  $4,%ebx,%ebx
movl      %ebx,56(%rsp)
vpbroadcastd 56(%rsp),%ymm4
vpaddd	  swap_c,%ymm4,%ymm4
vpand     swap_mask,%ymm4,%ymm4

vpermd	  %ymm8,%ymm4,%ymm8
vpermd	  %ymm0,%ymm4,%ymm0
vpermd	  %ymm1,%ymm4,%ymm1
vpermd	  %ymm2,%ymm4,%ymm2
vpermd	  %ymm7,%ymm4,%ymm7

// <T1',T2',T4',T3'> ← Dense-H-H1(<X2',Z2',X3',Z3'>)
vpshufd	  $68,%ymm8,%ymm4
vpshufd	  $238,%ymm8,%ymm3
vpaddd    hh1_p1,%ymm4,%ymm4
vpxor     hh1_xor1,%ymm3,%ymm3
vpaddd    %ymm4,%ymm3,%ymm8

vpshufd	  $68,%ymm0,%ymm4
vpshufd	  $238,%ymm0,%ymm3
vpaddd    hh1_p2,%ymm4,%ymm4
vpxor     hh1_xor1,%ymm3,%ymm3
vpaddd    %ymm4,%ymm3,%ymm0

vpshufd	  $68,%ymm1,%ymm4
vpshufd	  $238,%ymm1,%ymm3
vpaddd    hh1_p2,%ymm4,%ymm4
vpxor     hh1_xor1,%ymm3,%ymm3
vpaddd    %ymm4,%ymm3,%ymm1

vpshufd	  $68,%ymm2,%ymm4
vpshufd	  $238,%ymm2,%ymm3
vpaddd    hh1_p2,%ymm4,%ymm4
vpxor     hh1_xor1,%ymm3,%ymm3
vpaddd    %ymm4,%ymm3,%ymm2

vpshufd	  $68,%ymm7,%ymm4
vpshufd	  $238,%ymm7,%ymm3
vpaddd    hh1_p3,%ymm4,%ymm4
vpxor     hh1_xor2,%ymm3,%ymm3
vpaddd    %ymm4,%ymm3,%ymm7

vpsrld    $28,%ymm8,%ymm15
vpaddd    %ymm15,%ymm0,%ymm0
vpand     vecmask28d,%ymm8,%ymm8

vpsrld    $28,%ymm0,%ymm15
vpaddd    %ymm15,%ymm1,%ymm1
vpand     vecmask28d,%ymm0,%ymm0

vpsrld    $28,%ymm1,%ymm15
vpaddd    %ymm15,%ymm2,%ymm2
vpand     vecmask28d,%ymm1,%ymm1

vpsrld    $28,%ymm2,%ymm15
vpsllq    $32,%ymm15,%ymm15
vpaddd    %ymm15,%ymm8,%ymm8
vpsrlq    $60,%ymm2,%ymm15
vpaddd    %ymm15,%ymm7,%ymm7
vpand     vecmask28d,%ymm2,%ymm2

// <T1,T2,T4,T3> ← Pack-N2D(<T1',T2',T4',T3'>)
vpsrlq    $32,%ymm8,%ymm3
vpsrlq    $32,%ymm0,%ymm4
vpsrlq    $32,%ymm1,%ymm5
vpsrlq    $32,%ymm2,%ymm6

vmovdqa   %ymm8,64(%rsp)
vmovdqa   %ymm0,96(%rsp)
vmovdqa   %ymm1,128(%rsp)
vmovdqa   %ymm2,160(%rsp)
vmovdqa   %ymm3,192(%rsp)
vmovdqa   %ymm4,224(%rsp)
vmovdqa   %ymm5,256(%rsp)
vmovdqa   %ymm6,288(%rsp)
vmovdqa   %ymm7,320(%rsp)

// <T1',T2',T1',T2'> ← Dense-Dup(<T1',T2',T4',T3'>)
vpermq	  $68,%ymm7,%ymm15
vpermq	  $68,%ymm8,%ymm7
vpermq	  $68,%ymm0,%ymm8
vpermq	  $68,%ymm1,%ymm9
vpermq	  $68,%ymm2,%ymm10

// <T1,T2,T1,T2> ← Pack-D2N(<T1',T2',T1',T2'>)
vpsrlq    $32,%ymm7,%ymm11
vpsrlq    $32,%ymm8,%ymm12
vpsrlq    $32,%ymm9,%ymm13
vpsrlq    $32,%ymm10,%ymm14

vmovdqa   %ymm7,352(%rsp)
vmovdqa   %ymm8,384(%rsp)
vmovdqa   %ymm9,416(%rsp)
vmovdqa   %ymm10,448(%rsp)
vmovdqa   %ymm11,480(%rsp)
vmovdqa   %ymm12,512(%rsp)
vmovdqa   %ymm13,544(%rsp)
vmovdqa   %ymm14,576(%rsp)
vmovdqa   %ymm15,608(%rsp)

// <T5,T6,T7,T8> ← Mul(<T1,T2,T4,T3>,<T1,T2,T1,T2>)
vpaddq    %ymm0,%ymm0,%ymm0
vpaddq    %ymm1,%ymm1,%ymm1
vpaddq    %ymm2,%ymm2,%ymm2
vpaddq    %ymm3,%ymm3,%ymm3
vpaddq    %ymm4,%ymm4,%ymm4
vpaddq    %ymm5,%ymm5,%ymm5
vpaddq    %ymm6,%ymm6,%ymm6

vpmuludq  vec9,%ymm8,%ymm8
vpmuludq  vec9,%ymm9,%ymm9
vpmuludq  vec9,%ymm10,%ymm10
vpmuludq  vec9,%ymm11,%ymm11
vpmuludq  vec9,%ymm12,%ymm12
vpmuludq  vec9,%ymm13,%ymm13
vpmuludq  vec9,%ymm14,%ymm14
vpmuludq  vec9,%ymm15,%ymm15

vpmuludq  %ymm0,%ymm15,%ymm0
vpmuludq  %ymm1,%ymm14,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm2,%ymm13,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm3,%ymm12,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm4,%ymm11,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm5,%ymm10,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm6,%ymm9,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0

vpmuludq  %ymm1,%ymm15,%ymm1
vpmuludq  %ymm2,%ymm14,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm3,%ymm13,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm4,%ymm12,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm5,%ymm11,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm6,%ymm10,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1

vpmuludq  %ymm2,%ymm15,%ymm2
vpmuludq  %ymm3,%ymm14,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2
vpmuludq  %ymm4,%ymm13,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2
vpmuludq  %ymm5,%ymm12,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2
vpmuludq  %ymm6,%ymm11,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2

vpmuludq  %ymm3,%ymm15,%ymm3
vpmuludq  %ymm4,%ymm14,%ymm7
vpaddq    %ymm7,%ymm3,%ymm3
vpmuludq  %ymm5,%ymm13,%ymm7
vpaddq    %ymm7,%ymm3,%ymm3
vpmuludq  %ymm6,%ymm12,%ymm7
vpaddq    %ymm7,%ymm3,%ymm3

vpmuludq  %ymm4,%ymm15,%ymm4
vpmuludq  %ymm5,%ymm14,%ymm7
vpaddq    %ymm7,%ymm4,%ymm4
vpmuludq  %ymm6,%ymm13,%ymm7
vpaddq    %ymm7,%ymm4,%ymm4

vpmuludq  %ymm5,%ymm15,%ymm5
vpmuludq  %ymm6,%ymm14,%ymm7
vpaddq    %ymm7,%ymm5,%ymm5

vpmuludq  %ymm6,%ymm15,%ymm6

vmovdqa   320(%rsp),%ymm7
vpaddq    %ymm7,%ymm7,%ymm7

vpmuludq  %ymm7,%ymm8,%ymm8
vpaddq    %ymm8,%ymm0,%ymm0

vpmuludq  %ymm7,%ymm9,%ymm8
vpaddq    %ymm8,%ymm1,%ymm1

vpmuludq  %ymm7,%ymm10,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2

vpmuludq  %ymm7,%ymm11,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3

vpmuludq  %ymm7,%ymm12,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4

vpmuludq  %ymm7,%ymm13,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5

vpmuludq  %ymm7,%ymm14,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6

vpmuludq  %ymm7,%ymm15,%ymm7

vmovdqa   64(%rsp),%ymm9
vmovdqa   96(%rsp),%ymm10
vmovdqa   128(%rsp),%ymm11
vmovdqa   160(%rsp),%ymm12
vmovdqa   192(%rsp),%ymm13
vmovdqa   224(%rsp),%ymm14
vmovdqa   256(%rsp),%ymm15

vpmuludq  352(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm0,%ymm0

vpmuludq  384(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm1,%ymm1
vpmuludq  352(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm1,%ymm1

vpmuludq  416(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2
vpmuludq  384(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2
vpmuludq  352(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2

vpmuludq  448(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3
vpmuludq  416(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3
vpmuludq  384(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3
vpmuludq  352(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3

vpmuludq  480(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  448(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  416(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  384(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  352(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4

vpmuludq  512(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  480(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  448(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  416(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  384(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  352(%rsp),%ymm14,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5

vpmuludq  544(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  512(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  480(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  448(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  416(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  384(%rsp),%ymm14,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  352(%rsp),%ymm15,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6

vpmuludq  576(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  544(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  512(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  480(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  448(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  416(%rsp),%ymm14,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  384(%rsp),%ymm15,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7

vpmuludq  608(%rsp),%ymm9,%ymm8
vpmuludq  576(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  544(%rsp),%ymm11,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  512(%rsp),%ymm12,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  480(%rsp),%ymm13,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  448(%rsp),%ymm14,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8

vmovdqa   256(%rsp),%ymm9
vmovdqa   288(%rsp),%ymm10
vmovdqa   320(%rsp),%ymm11

vpmuludq  352(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7

vpmuludq  416(%rsp),%ymm9,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  384(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  352(%rsp),%ymm11,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8

vpsrlq    $28,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask28,%ymm4,%ymm4

vpsrlq    $28,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand  	  vecmask28,%ymm0,%ymm0

vpsrlq    $28,%ymm5,%ymm10
vpaddq    %ymm10,%ymm6,%ymm6
vpand     vecmask28,%ymm5,%ymm5

vpsrlq    $28,%ymm1,%ymm10
vpaddq    %ymm10,%ymm2,%ymm2
vpand     vecmask28,%ymm1,%ymm1

vpsrlq    $28,%ymm6,%ymm10
vpaddq    %ymm10,%ymm7,%ymm7
vpand     vecmask28,%ymm6,%ymm6

vpsrlq    $28,%ymm2,%ymm10
vpaddq    %ymm10,%ymm3,%ymm3
vpand     vecmask28,%ymm2,%ymm2

vpsrlq    $28,%ymm7,%ymm10
vpaddq    %ymm10,%ymm8,%ymm8
vpand     vecmask28,%ymm7,%ymm7

vpsrlq    $28,%ymm3,%ymm10
vpaddq    %ymm10,%ymm4,%ymm4
vpand     vecmask28,%ymm3,%ymm3

vpsrlq    $27,%ymm8,%ymm10
vpsllq    $3,%ymm10,%ymm11
vpaddq    %ymm11,%ymm10,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask27,%ymm8,%ymm8

vpsrlq    $28,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask28,%ymm4,%ymm4

vpsrlq    $28,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand     vecmask28,%ymm0,%ymm0

vmovdqa   %ymm0,640(%rsp)
vmovdqa   %ymm1,672(%rsp)
vmovdqa   %ymm2,704(%rsp)
vmovdqa   %ymm3,736(%rsp)
vmovdqa   %ymm4,768(%rsp)
vmovdqa   %ymm5,800(%rsp)
vmovdqa   %ymm6,832(%rsp)
vmovdqa   %ymm7,864(%rsp)
vmovdqa   %ymm8,896(%rsp)

// <T5',T6',T7',T8'> ← Pack-N2D(<T5,T6,T7,T8>)
vpsllq    $32,%ymm4,%ymm4
vpor      %ymm4,%ymm0,%ymm0
vpsllq    $32,%ymm5,%ymm5
vpor      %ymm5,%ymm1,%ymm1
vpsllq    $32,%ymm6,%ymm6
vpor      %ymm6,%ymm2,%ymm2
vpsllq    $32,%ymm7,%ymm7
vpor      %ymm7,%ymm3,%ymm3

// <T9',T10',T11',T12'> ← Dense-H2-H(<T5',T6',T7',T8'>)
vpshufd	  $68,%ymm0,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm0,%ymm7
vpaddd    h2h_p1,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm7,%ymm7
vpaddd    %ymm9,%ymm7,%ymm0

vpshufd	  $68,%ymm2,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm2,%ymm7
vpaddd    h2h_p2,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm7,%ymm7
vpaddd    %ymm9,%ymm7,%ymm4

vpshufd	  $68,%ymm3,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm3,%ymm7
vpaddd    h2h_p2,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm7,%ymm7
vpaddd    %ymm9,%ymm7,%ymm6

vpshufd	  $68,%ymm1,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm1,%ymm7
vpaddd    h2h_p2,%ymm9,%ymm9
vpxor     h2h_xor1,%ymm7,%ymm7
vpaddd    %ymm9,%ymm7,%ymm2

vpshufd	  $68,%ymm8,%ymm9
vpand     h2h_mask,%ymm9,%ymm9
vpshufd	  $238,%ymm8,%ymm7
vpaddd    h2h_p3,%ymm9,%ymm9
vpxor     h2h_xor2,%ymm7,%ymm7
vpaddd    %ymm9,%ymm7,%ymm12

vpsrld    $28,%ymm0,%ymm1
vpaddd    %ymm1,%ymm2,%ymm2
vpand     vecmask28d,%ymm0,%ymm0

vpsrld    $28,%ymm2,%ymm1
vpaddd    %ymm1,%ymm4,%ymm4
vpand     vecmask28d,%ymm2,%ymm2

vpsrld    $28,%ymm4,%ymm1
vpaddd    %ymm1,%ymm6,%ymm6
vpand     vecmask28d,%ymm4,%ymm4

vpsrld    $28,%ymm6,%ymm1
vpsllq    $32,%ymm1,%ymm1
vpaddd    %ymm1,%ymm0,%ymm0
vpsrlq    $60,%ymm6,%ymm1
vpaddq    %ymm1,%ymm12,%ymm12
vpand     vecmask28d,%ymm6,%ymm6

// <T9',T10',1',X1'> ← Blend(<0',0',1',X1'>,<T9',T10',T11',T12'>,1100)
vpblendd  $240,0(%rsi),%ymm0,%ymm10
vpblendd  $240,32(%rsi),%ymm2,%ymm11
vpblendd  $240,64(%rsi),%ymm4,%ymm13
vpblendd  $240,96(%rsi),%ymm6,%ymm14
vpblendd  $240,128(%rsi),%ymm12,%ymm15

// <T9,T10,1,X1> ← Pack-D2N(<T9',T10',1',X1'>)
vmovdqa   %ymm10,352(%rsp)
vpsrlq    $32,%ymm10,%ymm10
vmovdqa   %ymm10,480(%rsp)
vmovdqa   %ymm11,384(%rsp)
vpsrlq    $32,%ymm11,%ymm11
vmovdqa   %ymm11,512(%rsp)
vmovdqa   %ymm13,416(%rsp)
vpsrlq    $32,%ymm13,%ymm13
vmovdqa   %ymm13,544(%rsp)
vmovdqa   %ymm14,448(%rsp)
vpsrlq    $32,%ymm14,%ymm14
vmovdqa   %ymm14,576(%rsp)
vmovdqa   %ymm15,608(%rsp)

// <T9,T10,T11,T12> ← Pack-D2N(<T9',T10',T11',T12'>)
vpsrlq    $32,%ymm0,%ymm8
vpsrlq    $32,%ymm2,%ymm9
vpsrlq    $32,%ymm4,%ymm10
vpsrlq    $32,%ymm6,%ymm11

// <0,T13,0,0> ← Unreduced-Mulc(<T9,T10,T11,T12>,<0,a24,0,0>)
// <T5,T14,T7,T8> ← Add(<0,T13,0,0>,<T5,T6,T7,T8>)
vpmuludq  a24,%ymm0,%ymm1
vpaddq    640(%rsp),%ymm1,%ymm1
vpmuludq  a24,%ymm2,%ymm3
vpaddq    672(%rsp),%ymm3,%ymm3
vpmuludq  a24,%ymm4,%ymm5
vpaddq    704(%rsp),%ymm5,%ymm5
vpmuludq  a24,%ymm8,%ymm13
vpaddq    768(%rsp),%ymm13,%ymm13
vpmuludq  a24,%ymm9,%ymm14
vpaddq    800(%rsp),%ymm14,%ymm14
vpmuludq  a24,%ymm10,%ymm7
vpaddq    832(%rsp),%ymm7,%ymm7

vpsrlq    $28,%ymm13,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpand     vecmask28,%ymm13,%ymm13

vpsrlq    $28,%ymm1,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3
vpand     vecmask28,%ymm1,%ymm1

vpsrlq    $28,%ymm14,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7
vpand     vecmask28,%ymm14,%ymm14
vmovdqa   %ymm14,800(%rsp)

vpsrlq    $28,%ymm3,%ymm15
vpaddq    %ymm15,%ymm5,%ymm5
vpand     vecmask28,%ymm3,%ymm3
vmovdqa   %ymm3,672(%rsp)

vpmuludq  a24,%ymm11,%ymm3
vpaddq    864(%rsp),%ymm3,%ymm3
vpsrlq    $28,%ymm7,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3
vpand     vecmask28,%ymm7,%ymm7
vmovdqa   %ymm7,832(%rsp)

vpmuludq  a24,%ymm6,%ymm7
vpaddq    736(%rsp),%ymm7,%ymm7
vpsrlq    $28,%ymm5,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7
vpand     vecmask28,%ymm5,%ymm5
vmovdqa   %ymm5,704(%rsp)

vpmuludq  a24,%ymm12,%ymm5
vpaddq    896(%rsp),%ymm5,%ymm5
vpsrlq    $28,%ymm3,%ymm15
vpaddq    %ymm15,%ymm5,%ymm5
vpand     vecmask28,%ymm3,%ymm3
vmovdqa   %ymm3,864(%rsp)

vpsrlq    $28,%ymm7,%ymm15
vpaddq    %ymm15,%ymm13,%ymm13
vpand     vecmask28,%ymm7,%ymm7
vmovdqa   %ymm7,736(%rsp)
vmovdqa   %ymm13,768(%rsp)

vpsrlq    $27,%ymm5,%ymm15
vpmuludq  vec9,%ymm15,%ymm15
vpaddq    %ymm15,%ymm1,%ymm1
vpand     vecmask27,%ymm5,%ymm5
vmovdqa   %ymm1,640(%rsp)
vmovdqa   %ymm5,896(%rsp)

// <*,*,T15,T16> ← Sqr(<T9,T10,T11,T12>)
vpaddq    %ymm0,%ymm0,%ymm13

vpaddq    %ymm2,%ymm2,%ymm7
vmovdqa   %ymm7,64(%rsp)

vpaddq    %ymm4,%ymm4,%ymm14
vmovdqa   %ymm14,96(%rsp)

vpaddq    %ymm6,%ymm6,%ymm14
vmovdqa   %ymm14,128(%rsp)

vpmuludq  %ymm2,%ymm12,%ymm14
vpmuludq  %ymm4,%ymm11,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm6,%ymm10,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm8,%ymm9,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm0,%ymm0,%ymm0
vpaddq    %ymm14,%ymm0,%ymm0

vpmuludq  %ymm4,%ymm12,%ymm14
vpmuludq  %ymm6,%ymm11,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm8,%ymm10,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm13,%ymm2,%ymm15
vpaddq    %ymm15,%ymm14,%ymm1
vpmuludq  %ymm9,%ymm9,%ymm15
vpsllq    $4,%ymm15,%ymm14
vpaddq    %ymm15,%ymm15,%ymm15
vpaddq    %ymm14,%ymm15,%ymm15
vpaddq    %ymm15,%ymm1,%ymm1

vpmuludq  %ymm6,%ymm12,%ymm14
vpmuludq  %ymm8,%ymm11,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm9,%ymm10,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm2,%ymm2,%ymm2
vpaddq    %ymm14,%ymm2,%ymm2
vpmuludq  %ymm13,%ymm4,%ymm15
vpaddq    %ymm15,%ymm2,%ymm2

vpmuludq  %ymm8,%ymm12,%ymm14
vpmuludq  %ymm9,%ymm11,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm13,%ymm6,%ymm15
vpaddq    %ymm15,%ymm14,%ymm3
vpmuludq  %ymm7,%ymm4,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3
vpmuludq  %ymm10,%ymm10,%ymm15
vpsllq    $4,%ymm15,%ymm14
vpaddq    %ymm15,%ymm15,%ymm15
vpaddq    %ymm14,%ymm15,%ymm15
vpaddq    %ymm15,%ymm3,%ymm3

vpmuludq  %ymm9,%ymm12,%ymm14
vpmuludq  %ymm10,%ymm11,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm4,%ymm4,%ymm4
vpaddq    %ymm14,%ymm4,%ymm4
vpmuludq  %ymm13,%ymm8,%ymm15
vpaddq    %ymm15,%ymm4,%ymm4
vpmuludq  %ymm7,%ymm6,%ymm15
vpaddq    %ymm15,%ymm4,%ymm4

vpmuludq  %ymm10,%ymm12,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm13,%ymm9,%ymm15
vpaddq    %ymm15,%ymm14,%ymm5
vpmuludq  %ymm7,%ymm8,%ymm15
vpaddq    %ymm15,%ymm5,%ymm5
vpmuludq  96(%rsp),%ymm6,%ymm15
vpaddq    %ymm15,%ymm5,%ymm5
vpmuludq  %ymm11,%ymm11,%ymm15
vpsllq    $4,%ymm15,%ymm14
vpaddq    %ymm15,%ymm15,%ymm15
vpaddq    %ymm14,%ymm15,%ymm15
vpaddq    %ymm15,%ymm5,%ymm5

vpmuludq  %ymm11,%ymm12,%ymm14
vpsllq    $2,%ymm14,%ymm15
vpsllq    $5,%ymm14,%ymm14
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm6,%ymm6,%ymm6
vpaddq    %ymm14,%ymm6,%ymm6
vpmuludq  %ymm13,%ymm10,%ymm15
vpaddq    %ymm15,%ymm6,%ymm6
vpmuludq  %ymm7,%ymm9,%ymm15
vpaddq    %ymm15,%ymm6,%ymm6
vpmuludq  96(%rsp),%ymm8,%ymm15
vpaddq    %ymm15,%ymm6,%ymm6

vpmuludq  %ymm13,%ymm11,%ymm14
vpmuludq  %ymm7,%ymm10,%ymm15
vpaddq    %ymm15,%ymm14,%ymm7
vpmuludq  96(%rsp),%ymm9,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7
vpmuludq  128(%rsp),%ymm8,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7
vpmuludq  %ymm12,%ymm12,%ymm15
vpsllq    $4,%ymm15,%ymm14
vpaddq    %ymm15,%ymm15,%ymm15
vpaddq    %ymm14,%ymm15,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7

vpmuludq  %ymm13,%ymm12,%ymm14
vpmuludq  64(%rsp),%ymm11,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14	
vpmuludq  96(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  128(%rsp),%ymm9,%ymm15
vpaddq    %ymm15,%ymm14,%ymm14
vpmuludq  %ymm8,%ymm8,%ymm8
vpaddq    %ymm14,%ymm8,%ymm8

vpsrlq    $28,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask28,%ymm4,%ymm12

vpsrlq    $28,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand  	  vecmask28,%ymm0,%ymm13

vpsrlq    $28,%ymm5,%ymm10
vpaddq    %ymm10,%ymm6,%ymm6
vpand     vecmask28,%ymm5,%ymm4

vpsrlq    $28,%ymm1,%ymm10
vpaddq    %ymm10,%ymm2,%ymm2
vpand     vecmask28,%ymm1,%ymm0

vpsrlq    $28,%ymm6,%ymm10
vpaddq    %ymm10,%ymm7,%ymm7
vpand     vecmask28,%ymm6,%ymm5

vpsrlq    $28,%ymm2,%ymm10
vpaddq    %ymm10,%ymm3,%ymm3
vpand     vecmask28,%ymm2,%ymm1

vpsrlq    $28,%ymm7,%ymm10
vpaddq    %ymm10,%ymm8,%ymm8
vpand     vecmask28,%ymm7,%ymm6

vpsrlq    $28,%ymm3,%ymm10
vpaddq    %ymm10,%ymm12,%ymm12
vpand     vecmask28,%ymm3,%ymm2

vpsrlq    $27,%ymm8,%ymm10
vpsllq    $3,%ymm10,%ymm11
vpaddq    %ymm11,%ymm10,%ymm10
vpaddq    %ymm10,%ymm13,%ymm13
vpand     vecmask27,%ymm8,%ymm7

vpsrlq    $28,%ymm12,%ymm10
vpaddq    %ymm10,%ymm4,%ymm4
vpand     vecmask28,%ymm12,%ymm3

vpsrlq    $28,%ymm13,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask28,%ymm13,%ymm8

// <T5,T14,T15,T16> ← Blend(<T5,T14,T7,T8>,<*,*,T15,T16>,0011)
vpblendd  $15,640(%rsp),%ymm8,%ymm8
vpblendd  $15,672(%rsp),%ymm0,%ymm0
vmovdqa   %ymm8,64(%rsp)
vmovdqa   %ymm0,96(%rsp)

vpblendd  $15,704(%rsp),%ymm1,%ymm1
vpblendd  $15,736(%rsp),%ymm2,%ymm2
vmovdqa   %ymm1,128(%rsp)
vmovdqa   %ymm2,160(%rsp)

vpblendd  $15,768(%rsp),%ymm3,%ymm3
vpblendd  $15,800(%rsp),%ymm4,%ymm4
vmovdqa   %ymm3,192(%rsp)
vmovdqa   %ymm4,224(%rsp)

vpblendd  $15,832(%rsp),%ymm5,%ymm5
vpblendd  $15,864(%rsp),%ymm6,%ymm6
vmovdqa   %ymm5,256(%rsp)
vmovdqa   %ymm6,288(%rsp)

vpblendd  $15,896(%rsp),%ymm7,%ymm7
vmovdqa   %ymm7,320(%rsp)

// <X2,Z2,X3,Z3> ← Mul(<T5,T14,T15,T16>,<T6,T10,1,X1>)
vmovdqa   384(%rsp),%ymm8
vmovdqa   416(%rsp),%ymm9
vmovdqa   448(%rsp),%ymm10
vmovdqa   480(%rsp),%ymm11
vmovdqa   512(%rsp),%ymm12
vmovdqa   544(%rsp),%ymm13
vmovdqa   576(%rsp),%ymm14
vmovdqa   608(%rsp),%ymm15

vpaddq    %ymm0,%ymm0,%ymm0
vpaddq    %ymm1,%ymm1,%ymm1
vpaddq    %ymm2,%ymm2,%ymm2
vpaddq    %ymm3,%ymm3,%ymm3
vpaddq    %ymm4,%ymm4,%ymm4
vpaddq    %ymm5,%ymm5,%ymm5
vpaddq    %ymm6,%ymm6,%ymm6

vpmuludq  vec9,%ymm8,%ymm8
vpmuludq  vec9,%ymm9,%ymm9
vpmuludq  vec9,%ymm10,%ymm10
vpmuludq  vec9,%ymm11,%ymm11
vpmuludq  vec9,%ymm12,%ymm12
vpmuludq  vec9,%ymm13,%ymm13
vpmuludq  vec9,%ymm14,%ymm14
vpmuludq  vec9,%ymm15,%ymm15

vpmuludq  %ymm0,%ymm15,%ymm0
vpmuludq  %ymm1,%ymm14,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm2,%ymm13,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm3,%ymm12,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm4,%ymm11,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm5,%ymm10,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0
vpmuludq  %ymm6,%ymm9,%ymm7
vpaddq    %ymm7,%ymm0,%ymm0

vpmuludq  %ymm1,%ymm15,%ymm1
vpmuludq  %ymm2,%ymm14,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm3,%ymm13,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm4,%ymm12,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm5,%ymm11,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1
vpmuludq  %ymm6,%ymm10,%ymm7
vpaddq    %ymm7,%ymm1,%ymm1

vpmuludq  %ymm2,%ymm15,%ymm2
vpmuludq  %ymm3,%ymm14,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2
vpmuludq  %ymm4,%ymm13,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2
vpmuludq  %ymm5,%ymm12,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2
vpmuludq  %ymm6,%ymm11,%ymm7
vpaddq    %ymm7,%ymm2,%ymm2

vpmuludq  %ymm3,%ymm15,%ymm3
vpmuludq  %ymm4,%ymm14,%ymm7
vpaddq    %ymm7,%ymm3,%ymm3
vpmuludq  %ymm5,%ymm13,%ymm7
vpaddq    %ymm7,%ymm3,%ymm3
vpmuludq  %ymm6,%ymm12,%ymm7
vpaddq    %ymm7,%ymm3,%ymm3

vpmuludq  %ymm4,%ymm15,%ymm4
vpmuludq  %ymm5,%ymm14,%ymm7
vpaddq    %ymm7,%ymm4,%ymm4
vpmuludq  %ymm6,%ymm13,%ymm7
vpaddq    %ymm7,%ymm4,%ymm4

vpmuludq  %ymm5,%ymm15,%ymm5
vpmuludq  %ymm6,%ymm14,%ymm7
vpaddq    %ymm7,%ymm5,%ymm5

vpmuludq  %ymm6,%ymm15,%ymm6

vmovdqa   320(%rsp),%ymm7
vpaddq    %ymm7,%ymm7,%ymm7

vpmuludq  %ymm7,%ymm8,%ymm8
vpaddq    %ymm8,%ymm0,%ymm0

vpmuludq  %ymm7,%ymm9,%ymm8
vpaddq    %ymm8,%ymm1,%ymm1

vpmuludq  %ymm7,%ymm10,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2

vpmuludq  %ymm7,%ymm11,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3

vpmuludq  %ymm7,%ymm12,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4

vpmuludq  %ymm7,%ymm13,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5

vpmuludq  %ymm7,%ymm14,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6

vpmuludq  %ymm7,%ymm15,%ymm7

vmovdqa   64(%rsp),%ymm9
vmovdqa   96(%rsp),%ymm10
vmovdqa   128(%rsp),%ymm11
vmovdqa   160(%rsp),%ymm12
vmovdqa   192(%rsp),%ymm13
vmovdqa   224(%rsp),%ymm14
vmovdqa   256(%rsp),%ymm15

vpmuludq  352(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm0,%ymm0

vpmuludq  384(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm1,%ymm1
vpmuludq  352(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm1,%ymm1

vpmuludq  416(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2
vpmuludq  384(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2
vpmuludq  352(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm2,%ymm2

vpmuludq  448(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3
vpmuludq  416(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3
vpmuludq  384(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3
vpmuludq  352(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm3,%ymm3

vpmuludq  480(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  448(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  416(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  384(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4
vpmuludq  352(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm4,%ymm4

vpmuludq  512(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  480(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  448(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  416(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  384(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5
vpmuludq  352(%rsp),%ymm14,%ymm8
vpaddq    %ymm8,%ymm5,%ymm5

vpmuludq  544(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  512(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  480(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  448(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  416(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  384(%rsp),%ymm14,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6
vpmuludq  352(%rsp),%ymm15,%ymm8
vpaddq    %ymm8,%ymm6,%ymm6

vpmuludq  576(%rsp),%ymm9,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  544(%rsp),%ymm10,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  512(%rsp),%ymm11,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  480(%rsp),%ymm12,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  448(%rsp),%ymm13,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  416(%rsp),%ymm14,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7
vpmuludq  384(%rsp),%ymm15,%ymm8
vpaddq    %ymm8,%ymm7,%ymm7

vpmuludq  608(%rsp),%ymm9,%ymm8
vpmuludq  576(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  544(%rsp),%ymm11,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  512(%rsp),%ymm12,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  480(%rsp),%ymm13,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  448(%rsp),%ymm14,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8

vmovdqa   256(%rsp),%ymm9
vmovdqa   288(%rsp),%ymm10
vmovdqa   320(%rsp),%ymm11

vpmuludq  352(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm7,%ymm7

vpmuludq  416(%rsp),%ymm9,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  384(%rsp),%ymm10,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8
vpmuludq  352(%rsp),%ymm11,%ymm15
vpaddq    %ymm15,%ymm8,%ymm8

vpsrlq    $28,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask28,%ymm4,%ymm12

vpsrlq    $28,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand  	  vecmask28,%ymm0,%ymm13

vpsrlq    $28,%ymm5,%ymm10
vpaddq    %ymm10,%ymm6,%ymm6
vpand     vecmask28,%ymm5,%ymm4

vpsrlq    $28,%ymm1,%ymm10
vpaddq    %ymm10,%ymm2,%ymm2
vpand     vecmask28,%ymm1,%ymm0

vpsrlq    $28,%ymm6,%ymm10
vpaddq    %ymm10,%ymm7,%ymm7
vpand     vecmask28,%ymm6,%ymm5

vpsrlq    $28,%ymm2,%ymm10
vpaddq    %ymm10,%ymm3,%ymm3
vpand     vecmask28,%ymm2,%ymm1

vpsrlq    $28,%ymm7,%ymm10
vpaddq    %ymm10,%ymm8,%ymm8
vpand     vecmask28,%ymm7,%ymm6

vpsrlq    $28,%ymm3,%ymm10
vpaddq    %ymm10,%ymm12,%ymm12
vpand     vecmask28,%ymm3,%ymm2

vpsrlq    $27,%ymm8,%ymm10
vpsllq    $3,%ymm10,%ymm11
vpaddq    %ymm11,%ymm10,%ymm10
vpaddq    %ymm10,%ymm13,%ymm13
vpand     vecmask27,%ymm8,%ymm7

vpsrlq    $28,%ymm12,%ymm10
vpaddq    %ymm10,%ymm4,%ymm4
vpand     vecmask28,%ymm12,%ymm3

vpsrlq    $28,%ymm13,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask28,%ymm13,%ymm8

// <X2',Z2',X3',Z3'> ← Pack-N2D(<X2,Z2,X3,Z3>)
vpsllq    $32,%ymm3,%ymm3
vpor      %ymm3,%ymm8,%ymm8
vpsllq    $32,%ymm4,%ymm4
vpor      %ymm4,%ymm0,%ymm0
vpsllq    $32,%ymm5,%ymm5
vpor      %ymm5,%ymm1,%ymm1
vpsllq    $32,%ymm6,%ymm6
vpor      %ymm6,%ymm2,%ymm2

subb      $1,%cl
cmpb	  $0,%cl
jge       .L2

movb	  $7,%cl
subq      $1,%r15
cmpq	  $0,%r15
jge       .L1

// <X2,Z2,X3,Z3> ← Pack-D2N(<X2',Z2',X3',Z3'>)
vpsrlq    $32,%ymm8,%ymm3
vpand     vecmask32,%ymm8,%ymm8
vpsrlq    $32,%ymm0,%ymm4
vpand     vecmask32,%ymm0,%ymm0
vpsrlq    $32,%ymm1,%ymm5
vpand     vecmask32,%ymm1,%ymm1
vpsrlq    $32,%ymm2,%ymm6
vpand     vecmask32,%ymm2,%ymm2

// <X2,Z2,X3,Z3> ← Reduce(<X2,Z2,X3,Z3>)
vpsrlq    $28,%ymm8,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask28,%ymm8,%ymm8

vpsrlq    $28,%ymm0,%ymm10
vpaddq    %ymm10,%ymm1,%ymm1
vpand     vecmask28,%ymm0,%ymm0

vpsrlq    $28,%ymm1,%ymm10
vpaddq 	  %ymm10,%ymm2,%ymm2
vpand     vecmask28,%ymm1,%ymm1

vpsrlq    $28,%ymm2,%ymm10
vpaddq    %ymm10,%ymm3,%ymm3
vpand     vecmask28,%ymm2,%ymm2

vpsrlq    $28,%ymm3,%ymm10
vpaddq    %ymm10,%ymm4,%ymm4
vpand     vecmask28,%ymm3,%ymm3

vpsrlq    $28,%ymm4,%ymm10
vpaddq    %ymm10,%ymm5,%ymm5
vpand     vecmask28,%ymm4,%ymm4

vpsrlq    $28,%ymm5,%ymm10
vpaddq    %ymm10,%ymm6,%ymm6
vpand     vecmask28,%ymm5,%ymm5

vpsrlq    $28,%ymm6,%ymm10
vpaddq    %ymm10,%ymm7,%ymm7
vpand     vecmask28,%ymm6,%ymm6

vpsrlq    $27,%ymm7,%ymm10
vpmuludq  vec9,%ymm10,%ymm10
vpaddq    %ymm10,%ymm8,%ymm8
vpand     vecmask27,%ymm7,%ymm7

vpsrlq    $28,%ymm8,%ymm10
vpaddq    %ymm10,%ymm0,%ymm0
vpand     vecmask28,%ymm8,%ymm8

vmovdqa   %ymm8,0(%rdi)
vmovdqa   %ymm0,32(%rdi)
vmovdqa   %ymm1,64(%rdi)
vmovdqa   %ymm2,96(%rdi)
vmovdqa   %ymm3,128(%rdi)
vmovdqa   %ymm4,160(%rdi)
vmovdqa   %ymm5,192(%rdi)
vmovdqa   %ymm6,224(%rdi)
vmovdqa   %ymm7,256(%rdi)

movq 	  0(%rsp), %r11
movq 	  8(%rsp), %r12
movq 	  16(%rsp),%r13
movq 	  24(%rsp),%r14
movq 	  32(%rsp),%r15
movq 	  40(%rsp),%rbx
movq 	  48(%rsp),%rbp

movq 	  %r11,%rsp

ret
