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

#ifndef __P2519_ARITH_H__
#define __P2519_ARITH_H__

#include "basic_types.h"
#include "gf_p2519_type.h"

#define p0  	0xFFFFFFFFFFFFFFF7
#define p12 	0xFFFFFFFFFFFFFFFF
#define p3  	0x07FFFFFFFFFFFFFF
#define _2p0	0x000FFFFFFFFFFFEE
#define _2p123  0x000FFFFFFFFFFFFE
#define _2p4 	0x0000FFFFFFFFFFFE
#define mask51 	0x0007FFFFFFFFFFFF
#define mask47 	0x00007FFFFFFFFFFF

#define gfp2519nsqr(x,y,n) do { gfp2519sqr(x,y); for(i=1;i<n;++i) gfp2519sqr(x,x); } while(0);

void gfp2519mul(gfe_p2519_5L *,const gfe_p2519_5L *,const gfe_p2519_5L *);
void gfp2519sqr(gfe_p2519_5L *,const gfe_p2519_5L *);
void gfp2519mulc(gfe_p2519_5L *,const gfe_p2519_5L *,const gfe_p2519_5L *);
void gfp2519reduce(gfe_p2519_5L *);
void gfp2519inv(gfe_p2519_5L *,const gfe_p2519_5L *);
void gfp2519add(gfe_p2519_5L *,const gfe_p2519_5L *,const gfe_p2519_5L *);
void gfp2519sub(gfe_p2519_5L *,const gfe_p2519_5L *,const gfe_p2519_5L *);
void gfp2519makeunique(gfe_p2519_4L *);

#endif
