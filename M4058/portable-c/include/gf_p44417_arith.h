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

#ifndef __P44417_ARITH_H__
#define __P44417_ARITH_H__

#include "basic_types.h"
#include "gf_p44417_type.h"

#define p0  	0xFFFFFFFFFFFFFFEF
#define p1_5 	0xFFFFFFFFFFFFFFFF
#define p6  	0x0FFFFFFFFFFFFFFF
#define _2p0	0x01FFFFFFFFFFFFDE
#define _2p1_6  0x01FFFFFFFFFFFFFE
#define _2p7 	0x001FFFFFFFFFFFFE
#define mask52 	0x000FFFFFFFFFFFFF
#define mask56 	0x00FFFFFFFFFFFFFF

#define gfp44417nsqr(x,y,n) do { gfp44417sqr(x,y); for(i=1;i<n;++i) gfp44417sqr(x,x); } while(0);

void gfp44417mul(gfe_p44417_8L *,const gfe_p44417_8L *,const gfe_p44417_8L *);
void gfp44417sqr(gfe_p44417_8L *,const gfe_p44417_8L *);
void gfp44417mulc(gfe_p44417_8L *,const gfe_p44417_8L *,const gfe_p44417_8L *);
void gfp44417reduce(gfe_p44417_8L *);
void gfp44417inv(gfe_p44417_8L *,const gfe_p44417_8L *);
void gfp44417add(gfe_p44417_8L *,const gfe_p44417_8L *,const gfe_p44417_8L *);
void gfp44417sub(gfe_p44417_8L *,const gfe_p44417_8L *,const gfe_p44417_8L *);
void gfp44417makeunique(gfe_p44417_7L *);

#endif
