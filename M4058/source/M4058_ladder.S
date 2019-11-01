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

// Montgomery ladder for the Montgomery curve M[4058]

.p2align 5
.globl M4058_ladder
M4058_ladder:

movq 	%rsp, %r11
subq 	$792, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq	0(%rsi), %r8
movq	%r8, 72(%rsp)
movq	%r8, 240(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 248(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 256(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 264(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 272(%rsp)
movq	40(%rsi), %r8
movq	%r8, 112(%rsp)
movq	%r8, 280(%rsp)
movq	48(%rsi), %r8
movq	%r8, 120(%rsp)
movq	%r8, 288(%rsp)  // X1 = XP, X3 = XP

movq	$1, 128(%rsp)
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)  // X2 = 1

movq	$0, 184(%rsp)
movq	$0, 192(%rsp)
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)  // Z2 = 0

movq	$1, 296(%rsp)
movq	$0, 304(%rsp)
movq	$0, 312(%rsp)
movq	$0, 320(%rsp)
movq	$0, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp) // Z3 = 1

// X1: rsp(72)-rsp(120),  
// X2: rsp(136)-rsp(192), Z2: rsp(200)-rsp(256),
// X3: rsp(264)-rsp(320), Z3: rsp(328)-rsp(384).

leaq	128(%rsp), %r11  // &X2
leaq	184(%rsp), %r12  // &Z2
leaq	240(%rsp), %r13  // &X3
leaq	296(%rsp), %r14  // &Z3

movq	%r11, 352(%rsp)  // &X2
movq	%r12, 360(%rsp)  // &Z2
movq	%r13, 368(%rsp)  // &X3
movq	%r14, 376(%rsp)  // &Z3

movq	%r13, 384(%rsp)  // &X3
movq	%r14, 392(%rsp)  // &Z3
movq	%r11, 400(%rsp)  // &X2
movq	%r12, 408(%rsp)  // &Z2

movq    $55, 424(%rsp)
movb	$3, 416(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop

.L1:
addq    424(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 418(%rsp)

.L2:
movb	416(%rsp), %cl
movb	418(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl    	// %bl = bit

leaq    352(%rsp), %rdx
leaq    384(%rsp), %rax
cmpb    $1, %bl
cmove   %rax, %rdx
movq    %rdx, 432(%rsp)

/* 
 * Montgomery ladder step
 *
 * T1 <- X2 + Z2
 * T2 <- X2 - Z2
 * T3 <- X3 + Z3
 * T4 <- X3 - Z3
 * T5 <- T1^2
 * T6 <- T2^2
 * T2 <- T2 · T3
 * T1 <- T1 · T4
 * T1 <- T1 + T2
 * T2 <- T1 - T2
 * X3 <- T1^2
 * T2 <- T2^2
 * Z3 <- T2 · X1
 * X2 <- T5 · T6
 * T5 <- T5 - T6
 * T1 <- ((A + 2)/4) · T5
 * T6 <- T6 + T1
 * Z2 <- T5 · T6
 *
 */

// X2
movq    0(%rdx), %rcx

movq    0(%rcx),   %r8  
movq    8(%rcx),   %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15

movq    8(%rdx), %rcx

// T1 <- X2 + Z2
addq    0(%rcx),  %r8
adcq    8(%rcx),  %r9
adcq    16(%rcx), %r10
adcq    24(%rcx), %r11
adcq    32(%rcx), %r12
adcq    40(%rcx), %r13
adcq    48(%rcx), %r14

movq    %r8,  440(%rsp)
movq    %r9,  448(%rsp)
movq    %r10, 456(%rsp)
movq    %r11, 464(%rsp)
movq    %r12, 472(%rsp)
movq    %r13, 480(%rsp)
movq    %r14, 488(%rsp)

movq    0(%rdx), %rcx
movq    48(%rcx), %r8

// T2 <- X2 - Z2
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %r8

movq    8(%rdx),  %rcx
subq    0(%rcx),  %rax
sbbq    8(%rcx),  %rbx
sbbq    16(%rcx), %rbp
sbbq    24(%rcx), %rsi
sbbq    32(%rcx), %rdi
sbbq    40(%rcx), %r15
sbbq    48(%rcx), %r8

movq    %rax, 496(%rsp) // T2
movq    %rbx, 504(%rsp)
movq    %rbp, 512(%rsp)
movq    %rsi, 520(%rsp)
movq    %rdi, 528(%rsp)
movq    %r15, 536(%rsp)
movq    %r8,  544(%rsp)

// X3
movq    16(%rdx), %rcx

movq    0(%rcx),   %r8
movq    8(%rcx),   %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15

movq    24(%rdx),  %rcx	

// T3 <- X3 + Z3
addq    0(%rcx),  %r8
adcq    8(%rcx),  %r9
adcq    16(%rcx), %r10
adcq    24(%rcx), %r11
adcq    32(%rcx), %r12
adcq    40(%rcx), %r13
adcq    48(%rcx), %r14

movq    %r8,  552(%rsp)
movq    %r9,  560(%rsp)
movq    %r10, 568(%rsp)
movq    %r11, 576(%rsp)
movq    %r12, 584(%rsp)
movq    %r13, 592(%rsp)
movq    %r14, 600(%rsp)

movq    16(%rdx), %rcx
movq    48(%rcx), %r8

// T4 <- X3 - Z3
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %r8

movq    24(%rdx), %rcx
subq    0(%rcx),  %rax
sbbq    8(%rcx),  %rbx
sbbq    16(%rcx), %rbp
sbbq    24(%rcx), %rsi
sbbq    32(%rcx), %rdi
sbbq    40(%rcx), %r15
sbbq    48(%rcx), %r8

movq    %rax, 608(%rsp)
movq    %rbx, 616(%rsp)
movq    %rbp, 624(%rsp)
movq    %rsi, 632(%rsp)
movq    %rdi, 640(%rsp)
movq    %r15, 648(%rsp)
movq    %r8,  656(%rsp)

// T5 <- T1^2
movq    440(%rsp), %rdx
xorq    %r8, %r8
    
mulx    448(%rsp), %r9, %r10

mulx    456(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    464(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    472(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    480(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    488(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    448(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    456(%rsp), %rdx
xorq    %rbx, %rbx

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 776(%rsp)

movq    464(%rsp), %rdx
xorq    %r11, %r11

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    472(%rsp), %rdx
xorq    %rax, %rax

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    480(%rsp), %rdx

mulx    488(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    776(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9 

movq    %rdx, 776(%rsp)		
movq    %r12, 784(%rsp)
	  
xorq    %rdx, %rdx
movq    440(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    448(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    776(%rsp), %rax
movq    %rax, 776(%rsp)

movq    456(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    784(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 784(%rsp)

movq    464(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    472(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    480(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    488(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    $272, %rdx    		

xorq    %rax, %rax
mulx    %r15, %rax, %r15 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %r15     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %rsi, %rcx, %rsi
adcx    %rcx, %r11

mulx    %rbp, %rcx, %rdx
adcx    %rcx, %rsi
adcq    $0, %rdx

xorq    %rcx, %rcx
addq    %r12, %rax
adcq    %r9,  %r15
adcq    %r10, %r8
adcq    776(%rsp), %rdi
adcq    784(%rsp), %rbx
adcq    %r13, %r11
adcq    %rsi, %r14
adcq    %rdx, %rcx
   
shld    $4, %r14, %rcx
andq    mask60, %r14

imul    $17, %rcx, %rcx
addq    %rcx, %rax
adcq    $0, %r15
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r14

movq    %rax, 664(%rsp)
movq    %r15, 672(%rsp)
movq    %r8,  680(%rsp)
movq    %rdi, 688(%rsp)
movq    %rbx, 696(%rsp)
movq    %r11, 704(%rsp)
movq    %r14, 712(%rsp)

// T6 <- T2^2
movq    496(%rsp), %rdx
xorq    %r8, %r8
    
mulx    504(%rsp), %r9, %r10

mulx    512(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    520(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    528(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    536(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    544(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    504(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    512(%rsp), %rdx
xorq    %rbx, %rbx

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 776(%rsp)

movq    520(%rsp), %rdx
xorq    %r11, %r11

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    528(%rsp), %rdx
xorq    %rax, %rax

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    536(%rsp), %rdx

mulx    544(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    776(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9 

movq    %rdx, 776(%rsp)		
movq    %r12, 784(%rsp)
	  
xorq    %rdx, %rdx
movq    496(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    504(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    776(%rsp), %rax
movq    %rax, 776(%rsp)

movq    512(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    784(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 784(%rsp)

movq    520(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    544(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    $272, %rdx    		

xorq    %rax, %rax
mulx    %r15, %rax, %r15 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %r15     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %rsi, %rcx, %rsi
adcx    %rcx, %r11

mulx    %rbp, %rcx, %rdx
adcx    %rcx, %rsi
adcq    $0, %rdx

xorq    %rcx, %rcx
addq    %r12, %rax
adcq    %r9,  %r15
adcq    %r10, %r8
adcq    776(%rsp), %rdi
adcq    784(%rsp), %rbx
adcq    %r13, %r11
adcq    %rsi, %r14
adcq    %rdx, %rcx
   
shld    $4, %r14, %rcx
andq    mask60, %r14

imul    $17, %rcx, %rcx
addq    %rcx, %rax
adcq    $0, %r15
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r14

movq    %rax, 720(%rsp)
movq    %r15, 728(%rsp)
movq    %r8,  736(%rsp)
movq    %rdi, 744(%rsp)
movq    %rbx, 752(%rsp)
movq    %r11, 760(%rsp)
movq    %r14, 768(%rsp)

// T1 <- T1 · T4
xorq    %rdx, %rdx
movq    552(%rsp), %rdx    

mulx    496(%rsp), %r8, %r9
mulx    504(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    512(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    520(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    528(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    536(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    544(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    560(%rsp), %rdx
   
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    568(%rsp), %rdx
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 776(%rsp)

xorq    %r10, %r10
movq    576(%rsp), %rdx
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 784(%rsp)

xorq    %r11, %r11
movq    584(%rsp), %rdx
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    592(%rsp), %rdx
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    600(%rsp), %rdx
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
adcq    $0, %rdi

movq    $272, %rdx    		

xorq    %rbp, %rbp
mulx    %r15, %rbp, %r15 

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %r15     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %rax, %rcx, %rax
adcx    %rcx, %r11

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi
  
xorq    %rdx, %rdx
addq    %r8, %rbp
adcq    %r9, %r15
adcq    776(%rsp), %rsi
adcq    784(%rsp), %rbx
adcq    %r12, %r10
adcq    %r13, %r11
adcq    %rax, %r14
adcq    %rdi, %rdx
   
shld    $4, %r14, %rdx
andq	mask60, %r14

imul    $17, %rdx, %rdx
addq    %rdx, %rbp
adcq    $0, %r15
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r14

movq    %rbp, 496(%rsp)
movq    %r15, 504(%rsp)
movq    %rsi, 512(%rsp)
movq    %rbx, 520(%rsp)
movq    %r10, 528(%rsp)
movq    %r11, 536(%rsp)
movq    %r14, 544(%rsp)

// T1 <- T1 · T4
xorq    %rdx, %rdx
movq    608(%rsp), %rdx    

mulx    440(%rsp), %r8, %r9
mulx    448(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    456(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    464(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    472(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    480(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    488(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    616(%rsp), %rdx
   
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    624(%rsp), %rdx
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 776(%rsp)

xorq    %r10, %r10
movq    632(%rsp), %rdx
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 784(%rsp)

xorq    %r11, %r11
movq    640(%rsp), %rdx
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    648(%rsp), %rdx
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    656(%rsp), %rdx
    
mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
adcq    $0, %rdi

movq    $272, %rdx    		

xorq    %rbp, %rbp
mulx    %r15, %rbp, %r15 

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %r15     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %rax, %rcx, %rax
adcx    %rcx, %r11

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi
  
xorq    %rdx, %rdx
addq    %r8, %rbp
adcq    %r9, %r15
adcq    776(%rsp), %rsi
adcq    784(%rsp), %rbx
adcq    %r12, %r10
adcq    %r13, %r11
adcq    %rax, %r14
adcq    %rdi, %rdx
   
shld    $4, %r14, %rdx
andq	mask60, %r14

imul    $17, %rdx, %rdx
addq    %rdx, %rbp
adcq    $0, %r15
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r14

// copy T1
movq    %rbp, %r8
movq    %r15, %r9
movq    %rsi, %r12
movq    %rbx, %r13
movq    %r10, %rax
movq    %r11, %rcx
movq    %r14, %rdx

// T1 <- T1 + T2
addq    496(%rsp), %rbp
adcq    504(%rsp), %r15
adcq    512(%rsp), %rsi
adcq    520(%rsp), %rbx
adcq    528(%rsp), %r10
adcq    536(%rsp), %r11
adcq    544(%rsp), %r14

movq    %rbp, 440(%rsp)
movq    %r15, 448(%rsp)
movq    %rsi, 456(%rsp)
movq    %rbx, 464(%rsp)
movq    %r10, 472(%rsp)
movq    %r11, 480(%rsp)
movq    %r14, 488(%rsp)

// T2 <- T1 - T2
addq    _4p0,   %r8
adcq    _4p1_5, %r9
adcq    _4p1_5, %r12
adcq    _4p1_5, %r13
adcq    _4p1_5, %rax
adcq    _4p1_5, %rcx
adcq    _4p6,   %rdx

subq    496(%rsp),  %r8
sbbq    504(%rsp),  %r9
sbbq    512(%rsp), %r12
sbbq    520(%rsp), %r13
sbbq    528(%rsp), %rax
sbbq    536(%rsp), %rcx
sbbq    544(%rsp), %rdx

movq    %r8,  496(%rsp)
movq    %r9,  504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %rax, 528(%rsp)
movq    %rcx, 536(%rsp)
movq    %rdx, 544(%rsp)

// X3 <- T1^2
movq    440(%rsp), %rdx
xorq    %r8, %r8
    
mulx    448(%rsp), %r9, %r10

mulx    456(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    464(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    472(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    480(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    488(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    448(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    456(%rsp), %rdx
xorq    %rbx, %rbx

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 776(%rsp)

movq    464(%rsp), %rdx
xorq    %r11, %r11

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    472(%rsp), %rdx
xorq    %rax, %rax

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    480(%rsp), %rdx

mulx    488(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    776(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9 

movq    %rdx, 776(%rsp)		
movq    %r12, 784(%rsp)
	  
xorq    %rdx, %rdx
movq    440(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    448(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    776(%rsp), %rax
movq    %rax, 776(%rsp)

movq    456(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    784(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 784(%rsp)

movq    464(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    472(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    480(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    488(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    $272, %rdx    		

xorq    %rax, %rax
mulx    %r15, %rax, %r15 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %r15     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %rsi, %rcx, %rsi
adcx    %rcx, %r11

mulx    %rbp, %rcx, %rdx
adcx    %rcx, %rsi
adcq    $0, %rdx

xorq    %rcx, %rcx
addq    %r12, %rax
adcq    %r9,  %r15
adcq    %r10, %r8
adcq    776(%rsp), %rdi
adcq    784(%rsp), %rbx
adcq    %r13, %r11
adcq    %rsi, %r14
adcq    %rdx, %rcx
   
shld    $4, %r14, %rcx
andq    mask60, %r14

imul    $17, %rcx, %rcx
addq    %rcx, %rax
adcq    $0, %r15
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r14

movq    432(%rsp), %rdx
movq    16(%rdx), %rcx

movq    %rax,  0(%rcx) // update X3
movq    %r15,  8(%rcx)
movq    %r8,  16(%rcx)
movq    %rdi, 24(%rcx)
movq    %rbx, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r14, 48(%rcx)

// T2 = T2^2
movq    496(%rsp), %rdx
xorq    %r8, %r8
    
mulx    504(%rsp), %r9, %r10

mulx    512(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    520(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    528(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    536(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    544(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    504(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    512(%rsp), %rdx
xorq    %rbx, %rbx

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 776(%rsp)

movq    520(%rsp), %rdx
xorq    %r11, %r11

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    528(%rsp), %rdx
xorq    %rax, %rax

mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    536(%rsp), %rdx

mulx    544(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    776(%rsp), %rdx

movq    $0, %rbp
shld    $1, %rsi, %rbp
shld    $1, %r11, %rsi
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %r15, %r8
shld    $1, %r14, %r15
shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %rdx, %r12
shld    $1, %r10, %rdx
shld    $1, %r9,  %r10
shlq    $1, %r9 

movq    %rdx, 776(%rsp)		
movq    %r12, 784(%rsp)
	  
xorq    %rdx, %rdx
movq    496(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    504(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    776(%rsp), %rax
movq    %rax, 776(%rsp)

movq    512(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    784(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 784(%rsp)

movq    520(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    544(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %rbp

movq    $272, %rdx    		

xorq    %rax, %rax
mulx    %r15, %rax, %r15 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %r15     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %rsi, %rcx, %rsi
adcx    %rcx, %r11

mulx    %rbp, %rcx, %rdx
adcx    %rcx, %rsi
adcq    $0, %rdx

xorq    %rcx, %rcx
addq    %r12, %rax
adcq    %r9,  %r15
adcq    %r10, %r8
adcq    776(%rsp), %rdi
adcq    784(%rsp), %rbx
adcq    %r13, %r11
adcq    %rsi, %r14
adcq    %rdx, %rcx
   
shld    $4, %r14, %rcx
andq    mask60, %r14

imul    $17, %rcx, %rcx
addq    %rcx, %rax
adcq    $0, %r15
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r14

movq    %rax, 496(%rsp)
movq    %r15, 504(%rsp)
movq    %r8,  512(%rsp)
movq    %rdi, 520(%rsp)
movq    %rbx, 528(%rsp)
movq    %r11, 536(%rsp)
movq    %r14, 544(%rsp)

// Z3 <- T2 · X1
xorq    %rdx, %rdx
movq    496(%rsp), %rdx    

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    88(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    96(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    104(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    112(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    120(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    504(%rsp), %rdx
   
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    512(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 776(%rsp)

xorq    %r10, %r10
movq    520(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 784(%rsp)

xorq    %r11, %r11
movq    528(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    536(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    544(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
adcq    $0, %rdi

movq    $272, %rdx    		

xorq    %rbp, %rbp
mulx    %r15, %rbp, %r15 

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %r15     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %rax, %rcx, %rax
adcx    %rcx, %r11

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi
  
xorq    %rdx, %rdx
addq    %r8, %rbp
adcq    %r9, %r15
adcq    776(%rsp), %rsi
adcq    784(%rsp), %rbx
adcq    %r12, %r10
adcq    %r13, %r11
adcq    %rax, %r14
adcq    %rdi, %rdx
   
shld    $4, %r14, %rdx
andq	mask60, %r14

imul    $17, %rdx, %rdx
addq    %rdx, %rbp
adcq    $0, %r15
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r14

movq    432(%rsp), %rdx
movq    24(%rdx), %rcx

movq    %rbp,  0(%rcx) // update Z3
movq    %r15,  8(%rcx)
movq    %rsi, 16(%rcx)
movq    %rbx, 24(%rcx)
movq    %r10, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r14, 48(%rcx)

// X2 <- T5 · T6
xorq    %rdx, %rdx
movq    720(%rsp), %rdx    

mulx    664(%rsp), %r8, %r9
mulx    672(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    680(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    688(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    696(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    704(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    712(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    728(%rsp), %rdx
   
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    736(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 776(%rsp)

xorq    %r10, %r10
movq    744(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 784(%rsp)

xorq    %r11, %r11
movq    752(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    760(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    768(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
adcq    $0, %rdi

movq    $272, %rdx    		

xorq    %rbp, %rbp
mulx    %r15, %rbp, %r15 

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %r15     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %rax, %rcx, %rax
adcx    %rcx, %r11

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi
  
xorq    %rdx, %rdx
addq    %r8, %rbp
adcq    %r9, %r15
adcq    776(%rsp), %rsi
adcq    784(%rsp), %rbx
adcq    %r12, %r10
adcq    %r13, %r11
adcq    %rax, %r14
adcq    %rdi, %rdx
   
shld    $4, %r14, %rdx
andq	mask60, %r14

imul    $17, %rdx, %rdx
addq    %rdx, %rbp
adcq    $0, %r15
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r14

movq    432(%rsp), %rdx
movq    0(%rdx), %rcx

movq    %rbp,  0(%rcx) // update X2
movq    %r15,  8(%rcx)
movq    %rsi, 16(%rcx)
movq    %rbx, 24(%rcx)
movq    %r10, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r14, 48(%rcx)

// T5 <- T5 - T6
movq    664(%rsp),  %r8
movq    672(%rsp),  %r9
movq    680(%rsp), %r10
movq    688(%rsp), %r11 
movq    696(%rsp), %r12
movq    704(%rsp), %r13
movq    712(%rsp), %r14

addq    _4p0,    %r8
adcq    _4p1_5,  %r9
adcq    _4p1_5, %r10
adcq    _4p1_5, %r11
adcq    _4p1_5, %r12
adcq    _4p1_5, %r13
adcq    _4p6,   %r14

subq    720(%rsp),  %r8
sbbq    728(%rsp),  %r9
sbbq    736(%rsp), %r10
sbbq    744(%rsp), %r11
sbbq    752(%rsp), %r12
sbbq    760(%rsp), %r13
sbbq    768(%rsp), %r14

movq    %r8,  664(%rsp)
movq    %r9,  672(%rsp)
movq    %r10, 680(%rsp)
movq    %r11, 688(%rsp)
movq    %r12, 696(%rsp)
movq    %r13, 704(%rsp)
movq    %r14, 712(%rsp)

// T1 <- ((A + 2)/4) · T5
xorq    %rdx, %rdx
movq    a24, %rdx

mulx    %r8, %rsi, %rdi
mulx    %r9, %rcx, %rbp
adcx    %rcx, %rdi

mulx    %r10, %rcx, %r8
adcx    %rcx, %rbp

mulx    %r11, %rcx, %r9
adcx    %rcx, %r8

mulx    %r12, %rcx, %r10
adcx    %rcx, %r9

mulx    %r13, %rcx, %r11
adcx    %rcx, %r10

mulx    %r14, %rcx, %r12
adcx    %rcx, %r11	
adcq    $0, %r12

shld    $4, %r11, %r12
andq    mask60, %r11

imul    $17, %r12, %r12
addq    %r12, %rsi
adcq    $0, %rdi
adcq    $0, %rbp
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11

// T6 <- T6 + T1
addq    720(%rsp), %rsi
adcq    728(%rsp), %rdi
adcq    736(%rsp), %rbp
adcq    744(%rsp),  %r8
adcq    752(%rsp),  %r9
adcq    760(%rsp), %r10
adcq    768(%rsp), %r11

movq    %rsi, 720(%rsp) 
movq    %rdi, 728(%rsp)
movq    %rbp, 736(%rsp)
movq    %r8,  744(%rsp)
movq    %r9,  752(%rsp)
movq    %r10, 760(%rsp)
movq    %r11, 768(%rsp)

// Z2 <- T5 · T6
xorq    %rdx, %rdx
movq    720(%rsp), %rdx    

mulx    664(%rsp), %r8, %r9
mulx    672(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    680(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    688(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    696(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    704(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    712(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    728(%rsp), %rdx
   
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    736(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 776(%rsp)

xorq    %r10, %r10
movq    744(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 784(%rsp)

xorq    %r11, %r11
movq    752(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    760(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    768(%rsp), %rdx
    
mulx    664(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    672(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    680(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    688(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    696(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    704(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    712(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
adcq    $0, %rdi

movq    $272, %rdx    		

xorq    %rbp, %rbp
mulx    %r15, %rbp, %r15 

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %r15     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %rax, %rcx, %rax
adcx    %rcx, %r11

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi
  
xorq    %rdx, %rdx
addq    %r8, %rbp
adcq    %r9, %r15
adcq    776(%rsp), %rsi
adcq    784(%rsp), %rbx
adcq    %r12, %r10
adcq    %r13, %r11
adcq    %rax, %r14
adcq    %rdi, %rdx
   
shld    $4, %r14, %rdx
andq	mask60, %r14

imul    $17, %rdx, %rdx
addq    %rdx, %rbp
adcq    $0, %r15
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r14

movq    432(%rsp), %rdx
movq    8(%rdx), %rcx

movq    %rbp,  0(%rcx) // update Z2
movq    %r15,  8(%rcx)
movq    %rsi, 16(%rcx)
movq    %rbx, 24(%rcx)
movq    %r10, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r14, 48(%rcx)

movb    416(%rsp), %cl
subb    $1, %cl
movb    %cl, 416(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 416(%rsp)
movq    64(%rsp), %rax
movq    424(%rsp), %r15
subq    $1, %r15
movq    %r15, 424(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    432(%rsp), %rdx
movq    0(%rdx), %rcx

movq     0(%rcx),  %r8 
movq     8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14

movq    %r8,   0(%rdi) // final value of X2
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)

movq    8(%rdx), %rcx

movq     0(%rcx),  %r8 
movq     8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14

movq    %r8,  56(%rdi) // final value of Z2
movq    %r9,  64(%rdi)
movq    %r10, 72(%rdi)
movq    %r11, 80(%rdi)
movq    %r12, 88(%rdi)
movq    %r13, 96(%rdi)
movq    %r14, 104(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
