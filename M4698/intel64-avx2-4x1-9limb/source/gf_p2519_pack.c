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

#include "gf_p2519_pack.h"

void gfp2519pack(gfe_p2519_9L *v,const uchar8 *u) {

	uchar8 i,j,k,l;
	gfe_p2519_4L t;

	for (i=0;i<NLIMBS;++i) {
	
		j = i*8;
		t.l[i] = (uint64)u[j]; l = 1;
		for (k=1;k<9;++k)
			t.l[i] |= ((uint64)u[j+l++]  << k*8);
	}

	v->l[0] = ((t.l[0] & 0x000000000FFFFFFF));
	v->l[1] = ((t.l[0] & 0x00FFFFFFF0000000) >> 28);
	v->l[2] = ((t.l[0] & 0xFF00000000000000) >> 56) | ((t.l[1] & 0x00000000000FFFFF) <<  8);
	v->l[3] = ((t.l[1] & 0x0000FFFFFFF00000) >> 20);
	v->l[4] = ((t.l[1] & 0xFFFF000000000000) >> 48) | ((t.l[2] & 0x0000000000000FFF) << 16);
	v->l[5] = ((t.l[2] & 0x000000FFFFFFF000) >> 12);
	v->l[6] = ((t.l[2] & 0xFFFFFF0000000000) >> 40) | ((t.l[3] & 0x000000000000000F) << 24);
	v->l[7] = ((t.l[3] & 0x00000000FFFFFFF0) >>  4);
	v->l[8] = ((t.l[3] & 0x07FFFFFF00000000) >> 32);
}

void gfp2519pack94(gfe_p2519_4L *v,const gfe_p2519_9L *u) {

	v->l[0] = ((u->l[0] & 0x000000000FFFFFFF))       | ((u->l[1] & 0x000000000FFFFFFF) << 28) | ((u->l[2] & 0x00000000000000FF) << 56);
	v->l[1] = ((u->l[2] & 0x000000000FFFFF00) >>  8) | ((u->l[3] & 0x000000000FFFFFFF) << 20) | ((u->l[4] & 0x000000000000FFFF) << 48);
	v->l[2] = ((u->l[4] & 0x000000000FFF0000) >> 16) | ((u->l[5] & 0x000000000FFFFFFF) << 12) | ((u->l[6] & 0x0000000000FFFFFF) << 40);
	v->l[3] = ((u->l[6] & 0x000000000F000000) >> 24) | ((u->l[7] & 0x000000000FFFFFFF) <<  4) | ((u->l[8] & 0x000000000FFFFFFF) << 32);    
}

void gfp2519unpack(uchar8 *v,const gfe_p2519_4L *u) {

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
