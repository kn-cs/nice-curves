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
#include "gf_p44417_type.h"
#include "gf_p44417_arith.h"

void gfp44417mul(gfe_p44417_8L *h,const gfe_p44417_8L *f,const gfe_p44417_8L *g) {

	uchar8  i;
	uint64  t[NLIMBS],s[NLIMBS];
	uint128 r[NLIMBS+1];

	for (i=0; i<NLIMBS; ++i) {
	
		t[i] = f->l[i+1] << 4;
		s[i] = (g->l[i+1] << 4) + g->l[i+1];
	}

	r[0] = (uint128)f->l[0]*(uint128)g->l[0] + (uint128)t[0]*(uint128)s[6] + (uint128)t[1]*(uint128)s[5] + (uint128)t[2]*(uint128)s[4] + (uint128)t[3]*(uint128)s[3] + (uint128)t[4]*(uint128)s[2] + (uint128)t[5]*(uint128)s[1] + (uint128)t[6]*(uint128)s[0];
	r[1] = (uint128)f->l[0]*(uint128)g->l[1] + (uint128)f->l[1]*(uint128)g->l[0] + (uint128)t[1]*(uint128)s[6] + (uint128)t[2]*(uint128)s[5] + (uint128)t[3]*(uint128)s[4] + (uint128)t[4]*(uint128)s[3] + (uint128)t[5]*(uint128)s[2] + (uint128)t[6]*(uint128)s[1];
	r[2] = (uint128)f->l[0]*(uint128)g->l[2] + (uint128)f->l[1]*(uint128)g->l[1] + (uint128)f->l[2]*(uint128)g->l[0] + (uint128)t[2]*(uint128)s[6] + (uint128)t[3]*(uint128)s[5] + (uint128)t[4]*(uint128)s[4] + (uint128)t[5]*(uint128)s[3] + (uint128)t[6]*(uint128)s[2];
	r[3] = (uint128)f->l[0]*(uint128)g->l[3] + (uint128)f->l[1]*(uint128)g->l[2] + (uint128)f->l[2]*(uint128)g->l[1] + (uint128)f->l[3]*(uint128)g->l[0] + (uint128)t[3]*(uint128)s[6] + (uint128)t[4]*(uint128)s[5] + (uint128)t[5]*(uint128)s[4] + (uint128)t[6]*(uint128)s[3];
	r[4] = (uint128)f->l[0]*(uint128)g->l[4] + (uint128)f->l[1]*(uint128)g->l[3] + (uint128)f->l[2]*(uint128)g->l[2] + (uint128)f->l[3]*(uint128)g->l[1] + (uint128)f->l[4]*(uint128)g->l[0] + (uint128)t[4]*(uint128)s[6] + (uint128)t[5]*(uint128)s[5] + (uint128)t[6]*(uint128)s[4];
	r[5] = (uint128)f->l[0]*(uint128)g->l[5] + (uint128)f->l[1]*(uint128)g->l[4] + (uint128)f->l[2]*(uint128)g->l[3] + (uint128)f->l[3]*(uint128)g->l[2] + (uint128)f->l[4]*(uint128)g->l[1] + (uint128)f->l[5]*(uint128)g->l[0] + (uint128)t[5]*(uint128)s[6] + (uint128)t[6]*(uint128)s[5];
	r[6] = (uint128)f->l[0]*(uint128)g->l[6] + (uint128)f->l[1]*(uint128)g->l[5] + (uint128)f->l[2]*(uint128)g->l[4] + (uint128)f->l[3]*(uint128)g->l[3] + (uint128)f->l[4]*(uint128)g->l[2] + (uint128)f->l[5]*(uint128)g->l[1] + (uint128)f->l[6]*(uint128)g->l[0] + (uint128)t[6]*(uint128)s[6];
	r[7] = (uint128)f->l[0]*(uint128)g->l[7] + (uint128)f->l[1]*(uint128)g->l[6] + (uint128)f->l[2]*(uint128)g->l[5] + (uint128)f->l[3]*(uint128)g->l[4] + (uint128)f->l[4]*(uint128)g->l[3] + (uint128)f->l[5]*(uint128)g->l[2] + (uint128)f->l[6]*(uint128)g->l[1] + (uint128)f->l[7]*(uint128)g->l[0];

	for (i=0; i<NLIMBS; ++i) {

		r[i+1] = r[i+1] + (r[i] >> 56); 
		r[i]   = r[i] & mask56;
	}

	r[0] = r[0] + (r[NLIMBS] >> 52)*17; r[NLIMBS] = r[NLIMBS] & mask52;
	r[1] = r[1] + (r[0] >> 56); r[0] = r[0] & mask56;

	for (i=0; i<NLIMBS+1; ++i) h->l[i] = r[i];
}

void gfp44417reduce(gfe_p44417_8L *h) {

	uchar8  i;
	uint64  t[NLIMBS+1];

	for (i=0; i<NLIMBS+1; ++i) t[i]= h->l[i];

	for (i=0; i<NLIMBS; ++i) {

		t[i+1] = t[i+1] + (t[i] >> 56); 
		t[i]   = t[i] & mask56;
	}

	t[0] = t[0] + (t[NLIMBS] >> 52)*17; t[NLIMBS] = t[NLIMBS] & mask52;
	t[1] = t[1] + (t[0] >> 56); t[0] = t[0] & mask56;

	for (i=0; i<NLIMBS+1; ++i) h->l[i] = t[i];
}
