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

#include "basic_types.h"
#include "gf_p2519_type.h"
#include "gf_p2519_arith.h"

void gfp2519sqr(gfe_p2519_5L *h,const gfe_p2519_5L *f) {

	uchar8 i;
	uint64  t[9];
	uint128 r[NLIMBS+1];

	t[0] = f->l[0] << 1; t[1] = f->l[1] << 1; t[2] = f->l[2] << 1; t[3] = f->l[3] << 1;
	t[4] = 144*t[1]; t[5] = 144*t[2]; t[6] = 144*t[3]; t[7] = 144*f->l[3]; t[8] = 144*f->l[4];

	r[0] = (uint128)f->l[0]*(uint128)f->l[0] + (uint128)t[4]*(uint128)f->l[4] + (uint128)t[5]*(uint128)f->l[3];
	r[1] = (uint128)t[0]*(uint128)f->l[1] + (uint128)t[5]*(uint128)f->l[4] + (uint128)t[7]*(uint128)f->l[3];
	r[2] = (uint128)t[0]*(uint128)f->l[2] + (uint128)f->l[1]*(uint128)f->l[1] + (uint128)t[6]*(uint128)f->l[4];
	r[3] = (uint128)t[0]*(uint128)f->l[3] + (uint128)t[1]*(uint128)f->l[2] + (uint128)t[8]*(uint128)f->l[4];
	r[4] = (uint128)t[0]*(uint128)f->l[4] + (uint128)t[1]*(uint128)f->l[3] + (uint128)f->l[2]*(uint128)f->l[2];

	for (i=0; i<NLIMBS; ++i) {

		r[i+1] = r[i+1] + (r[i] >> 51); 
		r[i]   = r[i] & mask51;
	}

	r[0] = r[0] + (r[4] >> 47)*9; r[4] = r[4] & mask47;
	r[1] = r[1] + (r[0] >> 51);   r[0] = r[0] & mask51;

	for (i=0; i<NLIMBS+1; ++i) h->l[i] = r[i];
}
