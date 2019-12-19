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
.globl M4058_ladder
M4058_ladder:

movq 	%rsp, %r11
subq 	$608, %rsp

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
movq	%r8, 288(%rsp)  

// X2 ← 1
movq	$1, 128(%rsp)
movq	$0, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)  

// Z2 ← 0
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)  

// Z3 ← 1
movq	$1, 296(%rsp)
movq	$0, 304(%rsp)
movq	$0, 312(%rsp)
movq	$0, 320(%rsp)
movq	$0, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp) 

movq    $55, 360(%rsp)
movb	$3, 352(%rsp)
movb    $0, 354(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop.

.L1:

addq    360(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 356(%rsp)

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
 * X2 ← T5 + Z2
 * Z2 ← T6 - Z2
 * X3 ← X2^2
 * Z2 ← Z2^2
 * Z3 ← Z2 · X1
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
movq    128(%rsp), %r8
movq    136(%rsp), %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15
movq    %r14, %rcx

// T1 ← X2 + Z2
addq    184(%rsp), %r8
adcq    192(%rsp), %r9
adcq    200(%rsp), %r10
adcq    208(%rsp), %r11
adcq    216(%rsp), %r12
adcq    224(%rsp), %r13
adcq    232(%rsp), %r14

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

// T2 ← X2 - Z2
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %rcx

subq    184(%rsp), %rax
sbbq    192(%rsp), %rbx
sbbq    200(%rsp), %rbp
sbbq    208(%rsp), %rsi
sbbq    216(%rsp), %rdi
sbbq    224(%rsp), %r15
sbbq    232(%rsp), %rcx

movq    %rax, 424(%rsp)
movq    %rbx, 432(%rsp)
movq    %rbp, 440(%rsp)
movq    %rsi, 448(%rsp)
movq    %rdi, 456(%rsp)
movq    %r15, 464(%rsp)
movq    %rcx, 472(%rsp)

// X3
movq    240(%rsp), %r8
movq    248(%rsp), %r9
movq    256(%rsp), %r10
movq    264(%rsp), %r11
movq    272(%rsp), %r12
movq    280(%rsp), %r13
movq    288(%rsp), %r14

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %r15
movq    %r14, %rcx

// T3 ← X3 + Z3
addq    296(%rsp), %r8
adcq    304(%rsp), %r9
adcq    312(%rsp), %r10
adcq    320(%rsp), %r11
adcq    328(%rsp), %r12
adcq    336(%rsp), %r13
adcq    344(%rsp), %r14

movq    %r8,  480(%rsp)
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)

// T4 ← X3 - Z3
addq    _4p0,   %rax
adcq    _4p1_5, %rbx
adcq    _4p1_5, %rbp
adcq    _4p1_5, %rsi
adcq    _4p1_5, %rdi
adcq    _4p1_5, %r15
adcq    _4p6,   %rcx

subq    296(%rsp), %rax
sbbq    304(%rsp), %rbx
sbbq    312(%rsp), %rbp
sbbq    320(%rsp), %rsi
sbbq    328(%rsp), %rdi
sbbq    336(%rsp), %r15
sbbq    344(%rsp), %rcx

movq    %rax, 536(%rsp)
movq    %rbx, 544(%rsp)
movq    %rbp, 552(%rsp)
movq    %rsi, 560(%rsp)
movq    %rdi, 568(%rsp)
movq    %r15, 576(%rsp)
movq    %rcx, 584(%rsp)

// Z2 ← T2 · T3
xorq    %rdx, %rdx
movq    424(%rsp), %rdx    

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    496(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    504(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    512(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    520(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    528(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    432(%rsp), %rdx
   
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
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
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    440(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
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
adcq    $0, %rbx		

movq    %r10, 592(%rsp)

xorq    %r10, %r10
movq    448(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
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
adcq    $0, %r10			

movq    %r11, 600(%rsp)

xorq    %r11, %r11
movq    456(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
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
adcq    $0, %r11

xorq    %rax, %rax
movq    464(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    472(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    528(%rsp), %rcx, %rbp
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
adcq    592(%rsp), %rsi
adcq    600(%rsp), %rbx
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

movq    %rbp, 184(%rsp)
movq    %r15, 192(%rsp)
movq    %rsi, 200(%rsp)
movq    %rbx, 208(%rsp)
movq    %r10, 216(%rsp)
movq    %r11, 224(%rsp)
movq    %r14, 232(%rsp)

// T5 ← T1 · T4
xorq    %rdx, %rdx
movq    536(%rsp), %rdx    

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    384(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    392(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    400(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    408(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    416(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    544(%rsp), %rdx
   
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    552(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 592(%rsp)

xorq    %r10, %r10
movq    560(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 600(%rsp)

xorq    %r11, %r11
movq    568(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    576(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    584(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    416(%rsp), %rcx, %rbp
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
adcq    592(%rsp), %rsi
adcq    600(%rsp), %rbx
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

// T6 ←  T5
movq    %rbp, %r8
movq    %r15, %r9
movq    %rsi, %r12
movq    %rbx, %r13
movq    %r10, %rax
movq    %r11, %rcx
movq    %r14, %rdx

// X2 ← T5 + Z2
addq    184(%rsp), %rbp
adcq    192(%rsp), %r15
adcq    200(%rsp), %rsi
adcq    208(%rsp), %rbx
adcq    216(%rsp), %r10
adcq    224(%rsp), %r11
adcq    232(%rsp), %r14

movq    %rbp, 128(%rsp)
movq    %r15, 136(%rsp)
movq    %rsi, 144(%rsp)
movq    %rbx, 152(%rsp)
movq    %r10, 160(%rsp)
movq    %r11, 168(%rsp)
movq    %r14, 176(%rsp)

// Z2 ← T6 - Z2
addq    _4p0,   %r8
adcq    _4p1_5, %r9
adcq    _4p1_5, %r12
adcq    _4p1_5, %r13
adcq    _4p1_5, %rax
adcq    _4p1_5, %rcx
adcq    _4p6,   %rdx

subq    184(%rsp), %r8
sbbq    192(%rsp), %r9
sbbq    200(%rsp), %r12
sbbq    208(%rsp), %r13
sbbq    216(%rsp), %rax
sbbq    224(%rsp), %rcx
sbbq    232(%rsp), %rdx

movq    %r8,  184(%rsp)
movq    %r9,  192(%rsp)
movq    %r12, 200(%rsp)
movq    %r13, 208(%rsp)
movq    %rax, 216(%rsp)
movq    %rcx, 224(%rsp)
movq    %rdx, 232(%rsp)

// X3 ← X2^2
movq    128(%rsp), %rdx
xorq    %r8, %r8
    
mulx    136(%rsp), %r9, %r10

mulx    144(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    152(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    160(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    168(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    176(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    136(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    144(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    152(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    160(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    144(%rsp), %rdx
xorq    %rbx, %rbx

mulx    152(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    160(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    152(%rsp), %rdx
xorq    %r11, %r11

mulx    160(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    160(%rsp), %rdx
xorq    %rax, %rax

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    168(%rsp), %rdx

mulx    176(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

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

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    128(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    136(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    144(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    152(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    160(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    168(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    176(%rsp), %rdx
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
adcq    592(%rsp), %rdi
adcq    600(%rsp), %rbx
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

// update X3
movq    %rax, 240(%rsp) 
movq    %r15, 248(%rsp)
movq    %r8,  256(%rsp)
movq    %rdi, 264(%rsp)
movq    %rbx, 272(%rsp)
movq    %r11, 280(%rsp)
movq    %r14, 288(%rsp)

// Z2 ← Z2^2
movq    184(%rsp), %rdx
xorq    %r8, %r8
    
mulx    192(%rsp), %r9, %r10

mulx    200(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    208(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    216(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    224(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    232(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    192(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    216(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    224(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    200(%rsp), %rdx
xorq    %rbx, %rbx

mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    216(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    224(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    208(%rsp), %rdx
xorq    %r11, %r11

mulx    216(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    224(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    216(%rsp), %rdx
xorq    %rax, %rax

mulx    224(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    224(%rsp), %rdx

mulx    232(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

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

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    184(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    192(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    200(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    208(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    216(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    224(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    232(%rsp), %rdx
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
adcq    592(%rsp), %rdi
adcq    600(%rsp), %rbx
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

movq    %rax, 184(%rsp)
movq    %r15, 192(%rsp)
movq    %r8,  200(%rsp)
movq    %rdi, 208(%rsp)
movq    %rbx, 216(%rsp)
movq    %r11, 224(%rsp)
movq    %r14, 232(%rsp)

// Z3 ← Z2 · X1
xorq    %rdx, %rdx
movq    184(%rsp), %rdx    

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
movq    192(%rsp), %rdx
   
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
movq    200(%rsp), %rdx
    
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

movq    %r10, 592(%rsp)

xorq    %r10, %r10
movq    208(%rsp), %rdx
    
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

movq    %r11, 600(%rsp)

xorq    %r11, %r11
movq    216(%rsp), %rdx
    
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
movq    224(%rsp), %rdx
    
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
movq    232(%rsp), %rdx
    
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
adcq    592(%rsp), %rsi
adcq    600(%rsp), %rbx
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

// update Z3
movq    %rbp, 296(%rsp) 
movq    %r15, 304(%rsp)
movq    %rsi, 312(%rsp)
movq    %rbx, 320(%rsp)
movq    %r10, 328(%rsp)
movq    %r11, 336(%rsp)
movq    %r14, 344(%rsp)

movb	352(%rsp), %cl
movb	356(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    354(%rsp), %bl
movb    %cl, 354(%rsp)

cmpb    $1, %bl

// cselect(T1,T2,T3,T4,swap)
movq    368(%rsp), %r8
movq    376(%rsp), %r9
movq    384(%rsp), %r10
movq    392(%rsp), %r11
movq    400(%rsp), %r12
movq    408(%rsp), %r13
movq    416(%rsp), %r14

movq    480(%rsp), %r15
movq    488(%rsp), %rax
movq    496(%rsp), %rbx
movq    504(%rsp), %rcx
movq    512(%rsp), %rdx
movq    520(%rsp), %rbp
movq    528(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  368(%rsp)
movq    %r9,  376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)

movq    424(%rsp), %r8
movq    432(%rsp), %r9
movq    440(%rsp), %r10
movq    448(%rsp), %r11
movq    456(%rsp), %r12
movq    464(%rsp), %r13
movq    472(%rsp), %r14

movq    536(%rsp), %r15
movq    544(%rsp), %rax
movq    552(%rsp), %rbx
movq    560(%rsp), %rcx
movq    568(%rsp), %rdx
movq    576(%rsp), %rbp
movq    584(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  424(%rsp)
movq    %r9,  432(%rsp)
movq    %r10, 440(%rsp)
movq    %r11, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)
movq    %r14, 472(%rsp)

// T2 ← T2^2
movq    424(%rsp), %rdx
xorq    %r8, %r8
    
mulx    432(%rsp), %r9, %r10

mulx    440(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    448(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    456(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    464(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    472(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    432(%rsp), %rdx
xorq    %rdi, %rdi
    
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
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    440(%rsp), %rdx
xorq    %rbx, %rbx

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    448(%rsp), %rdx
xorq    %r11, %r11

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    456(%rsp), %rdx
xorq    %rax, %rax

mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    464(%rsp), %rdx

mulx    472(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

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

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    424(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    432(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    440(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    448(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    456(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    464(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    472(%rsp), %rdx
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
adcq    592(%rsp), %rdi
adcq    600(%rsp), %rbx
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

movq    %rax, 424(%rsp)
movq    %r15, 432(%rsp)
movq    %r8,  440(%rsp)
movq    %rdi, 448(%rsp)
movq    %rbx, 456(%rsp)
movq    %r11, 464(%rsp)
movq    %r14, 472(%rsp)

// T1 ← T1^2
movq    368(%rsp), %rdx
xorq    %r8, %r8
    
mulx    376(%rsp), %r9, %r10

mulx    384(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    392(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    400(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    408(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    416(%rsp), %rcx, %r15
adcx    %rcx, %r14
adcx    %r8, %r15
    
movq    376(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8
adcx    %rdi, %r8
    
movq    384(%rsp), %rdx
xorq    %rbx, %rbx

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 592(%rsp)

movq    392(%rsp), %rdx
xorq    %r11, %r11

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %r8

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    400(%rsp), %rdx
xorq    %rax, %rax

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %rax, %r11

movq    408(%rsp), %rdx

mulx    416(%rsp), %rcx, %rsi
adcx    %rcx, %r11
adcx    %rax, %rsi

movq    592(%rsp), %rdx

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

movq    %rdx, 592(%rsp)		
movq    %r12, 600(%rsp)
	  
xorq    %rdx, %rdx
movq    368(%rsp), %rdx
mulx    %rdx, %r12, %rax
adcx    %rax, %r9

movq    376(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r10
adcx    592(%rsp), %rax
movq    %rax, 592(%rsp)

movq    384(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    600(%rsp), %rcx
adcx    %rax, %r13
movq    %rcx, 600(%rsp)

movq    392(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    400(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r8
adcx    %rax, %rdi

movq    408(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rbx
adcx    %rax, %r11

movq    416(%rsp), %rdx
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
adcq    592(%rsp), %rdi
adcq    600(%rsp), %rbx
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

movq    %rax, 368(%rsp)
movq    %r15, 376(%rsp)
movq    %r8,  384(%rsp)
movq    %rdi, 392(%rsp)
movq    %rbx, 400(%rsp)
movq    %r11, 408(%rsp)
movq    %r14, 416(%rsp)

// T3 ← T1 - T2
addq    _4p0,   %rax
adcq    _4p1_5, %r15
adcq    _4p1_5, %r8
adcq    _4p1_5, %rdi
adcq    _4p1_5, %rbx
adcq    _4p1_5, %r11
adcq    _4p6,   %r14

subq    424(%rsp), %rax
sbbq    432(%rsp), %r15
sbbq    440(%rsp), %r8
sbbq    448(%rsp), %rdi
sbbq    456(%rsp), %rbx
sbbq    464(%rsp), %r11
sbbq    472(%rsp), %r14

movq    %rax, 480(%rsp) 
movq    %r15, 488(%rsp)
movq    %r8,  496(%rsp)
movq    %rdi, 504(%rsp)
movq    %rbx, 512(%rsp)
movq    %r11, 520(%rsp)
movq    %r14, 528(%rsp)

// X2 ← T1 · T2
xorq    %rdx, %rdx
movq    424(%rsp), %rdx    

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    384(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    392(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    400(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    408(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    416(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    432(%rsp), %rdx
   
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    440(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 592(%rsp)

xorq    %r10, %r10
movq    448(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 600(%rsp)

xorq    %r11, %r11
movq    456(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    464(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    472(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    416(%rsp), %rcx, %rbp
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
adcq    592(%rsp), %rsi
adcq    600(%rsp), %rbx
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

// update X2
movq    %rbp, 128(%rsp) 
movq    %r15, 136(%rsp)
movq    %rsi, 144(%rsp)
movq    %rbx, 152(%rsp)
movq    %r10, 160(%rsp)
movq    %r11, 168(%rsp)
movq    %r14, 176(%rsp)

// T1 ← ((A + 2)/4) · T3
xorq    %rdx, %rdx
movq    a24, %rdx

mulx    480(%rsp), %rsi, %rdi
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rdi

mulx    496(%rsp), %rcx, %r8
adcx    %rcx, %rbp

mulx    504(%rsp), %rcx, %r9
adcx    %rcx, %r8

mulx    512(%rsp), %rcx, %r10
adcx    %rcx, %r9

mulx    520(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    528(%rsp), %rcx, %r12
adcx    %rcx, %r11	
adcq    $0,   %r12

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

// T1 ← T1 + T2
addq    424(%rsp), %rsi
adcq    432(%rsp), %rdi
adcq    440(%rsp), %rbp
adcq    448(%rsp), %r8
adcq    456(%rsp), %r9
adcq    464(%rsp), %r10
adcq    472(%rsp), %r11

movq    %rsi, 368(%rsp) 
movq    %rdi, 376(%rsp)
movq    %rbp, 384(%rsp)
movq    %r8,  392(%rsp)
movq    %r9,  400(%rsp)
movq    %r10, 408(%rsp)
movq    %r11, 416(%rsp)

// Z2 ← T1 · T3
xorq    %rdx, %rdx
movq    480(%rsp), %rdx    

mulx    368(%rsp), %r8, %r9
mulx    376(%rsp), %rcx, %r10		
adcx    %rcx, %r9 

mulx    384(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    392(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    400(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    408(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    416(%rsp), %rcx, %r15	
adcx    %rcx, %r14
adcq    $0, %r15

xorq    %rsi, %rsi
movq    488(%rsp), %rdx
   
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    496(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 592(%rsp)

xorq    %r10, %r10
movq    504(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10		
adcq    $0, %r10			

movq    %r11, 600(%rsp)

xorq    %r11, %r11
movq    512(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11		
adcq    $0, %r11

xorq    %rax, %rax
movq    520(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax			
adcq    $0, %rax

xorq    %rdi, %rdi
movq    528(%rsp), %rdx
    
mulx    368(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    376(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    384(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    392(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    400(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %rax

mulx    416(%rsp), %rcx, %rbp
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
adcq    592(%rsp), %rsi
adcq    600(%rsp), %rbx
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

// update Z2
movq    %rbp, 184(%rsp) 
movq    %r15, 192(%rsp)
movq    %rsi, 200(%rsp)
movq    %rbx, 208(%rsp)
movq    %r10, 216(%rsp)
movq    %r11, 224(%rsp)
movq    %r14, 232(%rsp)

movb    352(%rsp), %cl
subb    $1, %cl
movb    %cl, 352(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 352(%rsp)
movq    64(%rsp), %rax
movq    360(%rsp), %r15
subq    $1, %r15
movq    %r15, 360(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    128(%rsp),  %r8 
movq    136(%rsp),  %r9
movq    144(%rsp), %r10
movq    152(%rsp), %r11
movq    160(%rsp), %r12
movq    168(%rsp), %r13
movq    176(%rsp), %r14

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)

movq    184(%rsp),  %r8 
movq    192(%rsp),  %r9
movq    200(%rsp), %r10
movq    208(%rsp), %r11
movq    216(%rsp), %r12
movq    224(%rsp), %r13
movq    232(%rsp), %r14

// store final value of Z2
movq    %r8,   56(%rdi) 
movq    %r9,   64(%rdi)
movq    %r10,  72(%rdi)
movq    %r11,  80(%rdi)
movq    %r12,  88(%rdi)
movq    %r13,  96(%rdi)
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
