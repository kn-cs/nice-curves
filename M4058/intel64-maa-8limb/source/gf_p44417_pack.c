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
#include "gf_p44417_pack.h"

void gfp44417pack(gfe_p44417_8L *v,const uchar8 *u) {

	uchar8 i,j,k,l;

	gfe_p44417_8L t;

	for (i=0;i<NLIMBS;++i) {
	
		j = i*8;
		t.l[i] = (uint64)u[j]; l = 1;
		for (k=1;k<9;++k)
			t.l[i] |= ((uint64)u[j+l++]  << k*8);
	}
	v->l[0] = ((t.l[0] & 0x00FFFFFFFFFFFFFF));
	v->l[1] = ((t.l[0] & 0xFF00000000000000) >> 56) | ((t.l[1] & 0x0000FFFFFFFFFFFF) << 8);
	v->l[2] = ((t.l[1] & 0xFFFF000000000000) >> 48) | ((t.l[2] & 0x000000FFFFFFFFFF) << 16);
	v->l[3] = ((t.l[2] & 0xFFFFFF0000000000) >> 40) | ((t.l[3] & 0x00000000FFFFFFFF) << 24);
	v->l[4] = ((t.l[3] & 0xFFFFFFFF00000000) >> 32) | ((t.l[4] & 0x0000000000FFFFFF) << 32);
	v->l[5] = ((t.l[4] & 0xFFFFFFFFFF000000) >> 24) | ((t.l[5] & 0x000000000000FFFF) << 40);
	v->l[6] = ((t.l[5] & 0xFFFFFFFFFFFF0000) >> 16) | ((t.l[6] & 0x00000000000000FF) << 48);
	v->l[7] = ((t.l[6] & 0x0FFFFFFFFFFFFF00) >>  8);
}

void  gfp44417pack87(gfe_p44417_7L *v, const gfe_p44417_8L *u) {

	v->l[0] = ((u->l[0] & 0x00FFFFFFFFFFFFFF)      ) | ((u->l[1] & 0x00000000000000FF) << 56);
	v->l[1] = ((u->l[1] & 0x00FFFFFFFFFFFF00) >>  8) | ((u->l[2] & 0x000000000000FFFF) << 48);
	v->l[2] = ((u->l[2] & 0x00FFFFFFFFFF0000) >> 16) | ((u->l[3] & 0x0000000000FFFFFF) << 40);
	v->l[3] = ((u->l[3] & 0x00FFFFFFFF000000) >> 24) | ((u->l[4] & 0x00000000FFFFFFFF) << 32);
	v->l[4] = ((u->l[4] & 0x00FFFFFF00000000) >> 32) | ((u->l[5] & 0x000000FFFFFFFFFF) << 24);
	v->l[5] = ((u->l[5] & 0x00FFFF0000000000) >> 40) | ((u->l[6] & 0x0000FFFFFFFFFFFF) << 16);
	v->l[6] = ((u->l[6] & 0x00FF000000000000) >> 48) | ((u->l[7] & 0x000FFFFFFFFFFFFF) << 8);
}

void gfp44417unpack(uchar8 *v,const gfe_p44417_7L *u) {

	uchar8 i,j;

	for (i=0;i<NLIMBS;++i) {

		j = i*8;
		v[j+0] = (uchar8)((u->l[i] & 0x00000000000000FF));
		v[j+1] = (uchar8)((u->l[i] & 0x000000000000FF00) >>  8);
		v[j+2] = (uchar8)((u->l[i] & 0x0000000000FF0000) >> 16);
		v[j+3] = (uchar8)((u->l[i] & 0x00000000FF000000) >> 24);
		v[j+4] = (uchar8)((u->l[i] & 0x000000FF00000000) >> 32);
		v[j+5] = (uchar8)((u->l[i] & 0x0000FF0000000000) >> 40);
		v[j+6] = (uchar8)((u->l[i] & 0x00FF000000000000) >> 48);
		v[j+7] = (uchar8)((u->l[i] & 0xFF00000000000000) >> 56);
	}
}
