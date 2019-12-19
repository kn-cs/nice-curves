/*
+-----------------------------------------------------------------------------+
| This code corresponds to the the paper "Nice curves" authored by	      |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2019, Kaushik Nath and Palash Sarkar.                         |
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
.globl M4698_ladder
M4698_ladder:

movq 	%rsp, %r11
subq 	$376, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X1 ← XP, X3 ← XP
movq	0(%rsi), %r8
movq	%r8, 72(%rsp)
movq	%r8, 168(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 176(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 184(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 192(%rsp)

// X2 ← 1
movq	$1, 104(%rsp)
movq	$0, 112(%rsp)
movq	$0, 120(%rsp)
movq	$0, 128(%rsp)

// Z2 ← 0
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)

// Z3 ← 1
movq	$1, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)

movq    $31, 240(%rsp)
movb	$2, 232(%rsp)
movb    $0, 234(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop.

.L1:

addq    240(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 236(%rsp)

.L2:

/* 
 * Montgomery ladder step. 
 *
 * T1 ← X2 + Z2
 * T2 ← X2 - Z2
 * T3 ← X3 + Z3
 * T4 ← X3 - Z3
 * Z2 ← T2 · T3
 * T5 ← T1 · T4
 * T6 ← T5
 * X2 ← T5 - Z2
 * T6 ← T6 + Z2
 * X3 ← T6^2
 * T5 ← X2^2
 * Z3 ← T5 · X1
 *
 * bit ← n[i]
 * swap ← bit ⊕ prevbit
 * prevbit ← bit
 * CSelect(T1,T2,T3,T4,swap)
 *
 * T2 ← T2^2
 * T1 ← T1^2
 * T3 ← T1 - T2
 * X2 ← T1 · T2
 * T1 ← ((A + 2)/4) · T3
 * T1 ← T1 + T2
 * Z2 ← T1 · T3
 *
 */

// X2
movq    104(%rsp), %r8  
movq    112(%rsp), %r9
movq    120(%rsp), %r10
movq    128(%rsp), %r11

// copy X2
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

// T1 ← X2 + Z2
addq    136(%rsp), %r8
adcq    144(%rsp), %r9
adcq    152(%rsp), %r10
adcq    160(%rsp), %r11

movq    %r8,  248(%rsp)
movq    %r9,  256(%rsp)
movq    %r10, 264(%rsp)
movq    %r11, 272(%rsp)

// T2 ← X2 - Z2
addq    _4p0,  %rax
adcq    _4p12, %rbx
adcq    _4p12, %rbp
adcq    _4p3,  %rsi

subq    136(%rsp), %rax
sbbq    144(%rsp), %rbx
sbbq    152(%rsp), %rbp
sbbq    160(%rsp), %rsi

movq    %rax, 280(%rsp)
movq    %rbx, 288(%rsp)
movq    %rbp, 296(%rsp)
movq    %rsi, 304(%rsp)

// X3
movq    168(%rsp), %r8
movq    176(%rsp), %r9
movq    184(%rsp), %r10
movq    192(%rsp), %r11

// copy X3 
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

// T3 ← X3 + Z3
addq    200(%rsp), %r8
adcq    208(%rsp), %r9
adcq    216(%rsp), %r10
adcq    224(%rsp), %r11

movq    %r8,  312(%rsp)
movq    %r9,  320(%rsp)
movq    %r10, 328(%rsp)
movq    %r11, 336(%rsp)

// T4 ← X3 - Z3
addq    _4p0,  %rax
adcq    _4p12, %rbx
adcq    _4p12, %rbp
adcq    _4p3,  %rsi

subq    200(%rsp), %rax
sbbq    208(%rsp), %rbx
sbbq    216(%rsp), %rbp
sbbq    224(%rsp), %rsi

movq    %rax, 344(%rsp)
movq    %rbx, 352(%rsp)
movq    %rbp, 360(%rsp)
movq    %rsi, 368(%rsp)

// Z2 ← T2 · T3
xorq    %r13, %r13
movq    280(%rsp), %rdx    

mulx    312(%rsp), %r8, %r9
mulx    320(%rsp), %rcx, %r10
adcx    %rcx, %r9     

mulx    328(%rsp), %rcx, %r11
adcx    %rcx, %r10    

mulx    336(%rsp), %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

xorq    %r14, %r14
movq    288(%rsp), %rdx
   
mulx    312(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    320(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    328(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    296(%rsp), %rdx
    
mulx    312(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    320(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    328(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
adcx    %r15, %r14

xorq    %rax, %rax
movq    304(%rsp), %rdx
    
mulx    312(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    320(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    328(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    336(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15			
adcx    %rax, %r15

xorq    %rbp, %rbp
movq    $288, %rdx

mulx    %r12, %rax, %r12 
adcx    %rax, %r8
adox    %r12, %r9

mulx    %r13, %rcx, %r13
adcx    %rcx, %r9
adox    %r13, %r10

mulx    %r14, %rcx, %r14
adcx    %rcx, %r10
adox    %r14, %r11

mulx    %r15, %rcx, %r15
adcx    %rcx, %r11
adox    zero, %r15
adcx    zero, %r15

shld    $5, %r11, %r15
andq    mask59, %r11

imul    $9, %r15, %r15
addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11

movq    %r8,  136(%rsp)
movq    %r9,  144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)

// T5 ← T1 · T4
xorq    %r13, %r13
movq    248(%rsp), %rdx    

mulx    344(%rsp), %r8, %r9
mulx    352(%rsp), %rcx, %r10
adcx    %rcx, %r9     

mulx    360(%rsp), %rcx, %r11
adcx    %rcx, %r10    

mulx    368(%rsp), %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

xorq    %r14, %r14
movq    256(%rsp), %rdx
   
mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    352(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    360(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    264(%rsp), %rdx
    
mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    352(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    360(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
adcx    %r15, %r14

xorq    %rax, %rax
movq    272(%rsp), %rdx
    
mulx    344(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    352(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    360(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15			
adcx    %rax, %r15

xorq    %rbp, %rbp
movq    $288, %rdx

mulx    %r12, %rax, %r12 
adcx    %rax, %r8
adox    %r12, %r9

mulx    %r13, %rcx, %r13
adcx    %rcx, %r9
adox    %r13, %r10

mulx    %r14, %rcx, %r14
adcx    %rcx, %r10
adox    %r14, %r11

mulx    %r15, %rcx, %r15
adcx    %rcx, %r11
adox    zero, %r15
adcx    zero, %r15

shld    $5, %r11, %r15
andq    mask59, %r11

imul    $9, %r15, %r15
addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11

// T6 ← T5
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

// X2 ← T5 - Z2
addq    _4p0,  %r8
adcq    _4p12, %r9
adcq    _4p12, %r10
adcq    _4p3,  %r11

subq    136(%rsp), %r8
sbbq    144(%rsp), %r9
sbbq    152(%rsp), %r10
sbbq    160(%rsp), %r11

movq    %r8,  104(%rsp)
movq    %r9,  112(%rsp)
movq    %r10, 120(%rsp)
movq    %r11, 128(%rsp)

// T6 ← T6 + Z2
addq    136(%rsp), %rax
adcq    144(%rsp), %rbx
adcq    152(%rsp), %rbp
adcq    160(%rsp), %rsi

// X3 ← T6^2
xorq    %r13, %r13
movq    %rax, %rdx
    
mulx    %rbx, %r9, %r10

mulx    %rbp, %rcx, %r11
adcx    %rcx, %r10
    
mulx    %rsi, %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

movq    %rbx, %rdx
xorq    %r14, %r14
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    %rbp, %rdx
    
mulx    %rsi, %rcx, %r14
adcx    %rcx, %r13
adcx    %r15, %r14

shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9, %r10
shlq    $1, %r9
    
xorq    %rdx, %rdx
movq    %rax, %rdx
mulx    %rdx, %r8, %rdx
adcx    %rdx, %r9

movq    %rbx, %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r10
adcx    %rdx, %r11

movq    %rbp, %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r12
adcx    %rdx, %r13

movq    %rsi, %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r14
adcx    %rdx, %r15

xorq    %rbp, %rbp
movq    $288, %rdx    		

mulx    %r12, %rbx, %rbp
adcx    %r8, %rbx
adox    %r9, %rbp

mulx    %r13, %rcx, %rax
adcx    %rcx, %rbp
adox    %r10, %rax

mulx    %r14, %rcx, %rsi
adcx    %rcx, %rax
adox    %r11, %rsi

mulx    %r15, %rcx, %r15
adcx    %rcx, %rsi
adox    zero, %r15
adcx    zero, %r15

shld    $5, %rsi, %r15
andq    mask59, %rsi

imul    $9, %r15, %r15
addq    %r15, %rbx
adcq    $0, %rbp
adcq    $0, %rax
adcq    $0, %rsi

// update X3
movq    %rbx, 168(%rsp) 
movq    %rbp, 176(%rsp)
movq    %rax, 184(%rsp)
movq    %rsi, 192(%rsp)

// T5 ← X2^2
xorq    %r13, %r13
movq    104(%rsp), %rdx
    
mulx    112(%rsp), %r9, %r10

mulx    120(%rsp), %rcx, %r11
adcx    %rcx, %r10
    
mulx    128(%rsp), %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

movq    112(%rsp), %rdx
xorq    %r14, %r14
    
mulx    120(%rsp), %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    128(%rsp), %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    120(%rsp), %rdx
    
mulx    128(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcx    %r15, %r14

shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9, %r10
shlq    $1, %r9
    
xorq    %rdx, %rdx
movq    104(%rsp), %rdx
mulx    %rdx, %r8, %rdx
adcx    %rdx, %r9

movq    112(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r10
adcx    %rdx, %r11

movq    120(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r12
adcx    %rdx, %r13

movq    128(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r14
adcx    %rdx, %r15

xorq    %rbp, %rbp
movq    $288, %rdx    		

mulx    %r12, %rbx, %rbp
adcx    %r8, %rbx
adox    %r9, %rbp

mulx    %r13, %rcx, %rax
adcx    %rcx, %rbp
adox    %r10, %rax

mulx    %r14, %rcx, %rsi
adcx    %rcx, %rax
adox    %r11, %rsi

mulx    %r15, %rcx, %r15
adcx    %rcx, %rsi
adox    zero, %r15
adcx    zero, %r15

shld    $5, %rsi, %r15
andq    mask59, %rsi

imul    $9, %r15, %r15
addq    %r15, %rbx
adcq    $0, %rbp
adcq    $0, %rax
adcq    $0, %rsi

// Z3 ← T5 · X1
xorq    %r13, %r13
movq    72(%rsp), %rdx    

mulx    %rbx, %r8, %r9
mulx    %rbp, %rcx, %r10
adcx    %rcx, %r9     

mulx    %rax, %rcx, %r11
adcx    %rcx, %r10    

mulx    %rsi, %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

xorq    %r14, %r14
movq    80(%rsp), %rdx
   
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r9
adox    %rdi, %r10
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r10
adox    %rdi, %r11
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    88(%rsp), %rdx
    
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r10
adox    %rdi, %r11
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r13
adox    %rdi, %r14
adcx    %r15, %r14

movq    96(%rsp), %rdx
    
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r13
adox    %rdi, %r14
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r14
adox    %rdi, %r15			
adcq    $0, %r15

xorq    %rbp, %rbp
movq    $288, %rdx

mulx    %r12, %rax, %r12 
adcx    %rax, %r8
adox    %r12, %r9

mulx    %r13, %rcx, %r13
adcx    %rcx, %r9
adox    %r13, %r10

mulx    %r14, %rcx, %r14
adcx    %rcx, %r10
adox    %r14, %r11

mulx    %r15, %rcx, %r15
adcx    %rcx, %r11
adox    zero, %r15
adcx    zero, %r15

shld    $5, %r11, %r15
andq    mask59, %r11

imul    $9, %r15, %r15
addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11

// update Z3
movq    %r8,  200(%rsp) 
movq    %r9,  208(%rsp)
movq    %r10, 216(%rsp)
movq    %r11, 224(%rsp)

movb	232(%rsp), %cl
movb	236(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    234(%rsp), %bl
movb    %cl, 234(%rsp)

cmpb    $1, %bl 

// cselect(T1,T2,T3,T4,swap)
movq    248(%rsp), %r8
movq    256(%rsp), %r9
movq    264(%rsp), %r10
movq    272(%rsp), %r11

movq    312(%rsp), %r12
movq    320(%rsp), %r13
movq    328(%rsp), %r14
movq    336(%rsp), %r15

cmove   %r12, %r8
cmove   %r13, %r9
cmove   %r14, %r10
cmove   %r15, %r11

movq    %r8,  248(%rsp)
movq    %r9,  256(%rsp)
movq    %r10, 264(%rsp)
movq    %r11, 272(%rsp)

movq    280(%rsp), %r8
movq    288(%rsp), %r9
movq    296(%rsp), %r10
movq    304(%rsp), %r11

movq    344(%rsp), %r12
movq    352(%rsp), %r13
movq    360(%rsp), %r14
movq    368(%rsp), %r15

cmove   %r12, %r8
cmove   %r13, %r9
cmove   %r14, %r10
cmove   %r15, %r11

movq    %r8,  280(%rsp)
movq    %r9,  288(%rsp)
movq    %r10, 296(%rsp)
movq    %r11, 304(%rsp)

// T2 ← T2^2
xorq    %r13, %r13
movq    280(%rsp), %rdx
    
mulx    288(%rsp), %r9, %r10

mulx    296(%rsp), %rcx, %r11
adcx    %rcx, %r10
    
mulx    304(%rsp), %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

movq    288(%rsp), %rdx
xorq    %r14, %r14
    
mulx    296(%rsp), %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    304(%rsp), %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    296(%rsp), %rdx
    
mulx    304(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcx    %r15, %r14

shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9, %r10
shlq    $1, %r9
    
xorq    %rdx, %rdx
movq    280(%rsp), %rdx
mulx    %rdx, %r8, %rdx
adcx    %rdx, %r9

movq    288(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r10
adcx    %rdx, %r11

movq    296(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r12
adcx    %rdx, %r13

movq    304(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r14
adcx    %rdx, %r15

xorq    %rbp, %rbp
movq    $288, %rdx    		

mulx    %r12, %rbx, %rbp
adcx    %r8, %rbx
adox    %r9, %rbp

mulx    %r13, %rcx, %rax
adcx    %rcx, %rbp
adox    %r10, %rax

mulx    %r14, %rcx, %rsi
adcx    %rcx, %rax
adox    %r11, %rsi

mulx    %r15, %rcx, %r15
adcx    %rcx, %rsi
adox    zero, %r15
adcx    zero, %r15

shld    $5, %rsi, %r15
andq    mask59, %rsi

imul    $9, %r15, %r15
addq    %r15, %rbx
adcq    $0, %rbp
adcq    $0, %rax
adcq    $0, %rsi

movq    %rbx, 280(%rsp)
movq    %rbp, 288(%rsp)
movq    %rax, 296(%rsp)
movq    %rsi, 304(%rsp)

// T1 ← T1^2
xorq    %r13, %r13
movq    248(%rsp), %rdx
    
mulx    256(%rsp), %r9, %r10

mulx    264(%rsp), %rcx, %r11
adcx    %rcx, %r10
    
mulx    272(%rsp), %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

movq    256(%rsp), %rdx
xorq    %r14, %r14
    
mulx    264(%rsp), %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    272(%rsp), %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    264(%rsp), %rdx
    
mulx    272(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcx    %r15, %r14

shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9, %r10
shlq    $1, %r9
    
xorq    %rdx, %rdx
movq    248(%rsp), %rdx
mulx    %rdx, %r8, %rdx
adcx    %rdx, %r9

movq    256(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r10
adcx    %rdx, %r11

movq    264(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r12
adcx    %rdx, %r13

movq    272(%rsp), %rdx
mulx    %rdx, %rcx, %rdx
adcx    %rcx, %r14
adcx    %rdx, %r15

xorq    %rbp, %rbp
movq    $288, %rdx    		

mulx    %r12, %rbx, %rbp
adcx    %r8, %rbx
adox    %r9, %rbp

mulx    %r13, %rcx, %rax
adcx    %rcx, %rbp
adox    %r10, %rax

mulx    %r14, %rcx, %rsi
adcx    %rcx, %rax
adox    %r11, %rsi

mulx    %r15, %rcx, %r15
adcx    %rcx, %rsi
adox    zero, %r15
adcx    zero, %r15

shld    $5, %rsi, %r15
andq    mask59, %rsi

imul    $9, %r15, %r15
addq    %r15, %rbx
adcq    $0, %rbp
adcq    $0, %rax
adcq    $0, %rsi

// T3 ← T1 - T2
movq    %rbx, %r8
movq    %rbp, %r9
movq    %rax, %r10
movq    %rsi, %r11

addq    _4p0,  %r8
adcq    _4p12, %r9
adcq    _4p12, %r10
adcq    _4p3,  %r11

subq    280(%rsp), %r8
sbbq    288(%rsp), %r9
sbbq    296(%rsp), %r10
sbbq    304(%rsp), %r11

movq    %r8,  312(%rsp)
movq    %r9,  320(%rsp)
movq    %r10, 328(%rsp)
movq    %r11, 336(%rsp)

// X2 ← T1 · T2
xorq    %r13, %r13
movq    280(%rsp), %rdx    

mulx    %rbx, %r8, %r9
mulx    %rbp, %rcx, %r10
adcx    %rcx, %r9     

mulx    %rax, %rcx, %r11
adcx    %rcx, %r10    

mulx    %rsi, %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

xorq    %r14, %r14
movq    288(%rsp), %rdx
   
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r9
adox    %rdi, %r10
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r10
adox    %rdi, %r11
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    296(%rsp), %rdx
    
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r10
adox    %rdi, %r11
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r13
adox    %rdi, %r14
adcx    %r15, %r14

movq    304(%rsp), %rdx
    
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r13
adox    %rdi, %r14
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r14
adox    %rdi, %r15			
adcq    $0, %r15

xorq    %rbp, %rbp
movq    $288, %rdx

mulx    %r12, %rax, %r12 
adcx    %rax, %r8
adox    %r12, %r9

mulx    %r13, %rcx, %r13
adcx    %rcx, %r9
adox    %r13, %r10

mulx    %r14, %rcx, %r14
adcx    %rcx, %r10
adox    %r14, %r11

mulx    %r15, %rcx, %r15
adcx    %rcx, %r11
adox    zero, %r15
adcx    zero, %r15

shld    $5, %r11, %r15
andq    mask59, %r11

imul    $9, %r15, %r15
addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11

// update X2
movq    %r8,  104(%rsp) 
movq    %r9,  112(%rsp)
movq    %r10, 120(%rsp)
movq    %r11, 128(%rsp)

// T1 ← ((A + 2)/4) · T3
xorq    %r13, %r13
movq    a24, %rdx

mulx    312(%rsp), %rbx, %r9
mulx    320(%rsp), %rbp, %r10
adcx    %r9, %rbp

mulx    328(%rsp), %rax, %r9
adcx    %r10, %rax

mulx    336(%rsp), %rsi, %r10
adcx    %r9, %rsi
adcx    %r13, %r10

shld    $5, %rsi, %r10
andq    mask59, %rsi

imul    $9, %r10, %r10
addq    %r10, %rbx
adcq    $0, %rbp
adcq    $0, %rax
adcq    $0, %rsi

// T1 ← T1 + T2
addq    280(%rsp), %rbx
adcq    288(%rsp), %rbp
adcq    296(%rsp), %rax
adcq    304(%rsp), %rsi

// Z2 ← T1 · T3
xorq    %r13, %r13
movq    312(%rsp), %rdx    

mulx    %rbx, %r8, %r9
mulx    %rbp, %rcx, %r10
adcx    %rcx, %r9     

mulx    %rax, %rcx, %r11
adcx    %rcx, %r10    

mulx    %rsi, %rcx, %r12
adcx    %rcx, %r11
adcx    %r13, %r12

xorq    %r14, %r14
movq    320(%rsp), %rdx
   
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r9
adox    %rdi, %r10
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r10
adox    %rdi, %r11
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
adcx    %r14, %r13

xorq    %r15, %r15
movq    328(%rsp), %rdx
    
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r10
adox    %rdi, %r11
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r13
adox    %rdi, %r14
adcx    %r15, %r14

movq    336(%rsp), %rdx
    
mulx    %rbx, %rcx, %rdi
adcx    %rcx, %r11
adox    %rdi, %r12
    
mulx    %rbp, %rcx, %rdi
adcx    %rcx, %r12
adox    %rdi, %r13
    
mulx    %rax, %rcx, %rdi
adcx    %rcx, %r13
adox    %rdi, %r14
    
mulx    %rsi, %rcx, %rdi
adcx    %rcx, %r14
adox    %rdi, %r15			
adcq    $0, %r15

xorq    %rbp, %rbp
movq    $288, %rdx

mulx    %r12, %rax, %r12 
adcx    %rax, %r8
adox    %r12, %r9

mulx    %r13, %rcx, %r13
adcx    %rcx, %r9
adox    %r13, %r10

mulx    %r14, %rcx, %r14
adcx    %rcx, %r10
adox    %r14, %r11

mulx    %r15, %rcx, %r15
adcx    %rcx, %r11
adox    zero, %r15
adcx    zero, %r15

shld    $5, %r11, %r15
andq    mask59, %r11

imul    $9, %r15, %r15
addq    %r15, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11

// update Z2
movq    %r8,  136(%rsp) 
movq    %r9,  144(%rsp)
movq    %r10, 152(%rsp)
movq    %r11, 160(%rsp)

movb    232(%rsp), %cl
subb    $1, %cl
movb    %cl, 232(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 232(%rsp)
movq    64(%rsp), %rax
movq    240(%rsp), %r15
subq    $1, %r15
movq    %r15, 240(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    104(%rsp), %r8 
movq    112(%rsp), %r9
movq    120(%rsp), %r10
movq    128(%rsp), %r11

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)

movq    136(%rsp), %r8 
movq    144(%rsp), %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11

// store final value of Z2
movq    %r8,  32(%rdi) 
movq    %r9,  40(%rdi)
movq    %r10, 48(%rdi)
movq    %r11, 56(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
