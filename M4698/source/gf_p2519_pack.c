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

#include "basic_types.h"
#include "gf_p2519_type.h"
#include "gf_p2519_pack.h"

// converts from bytes to 64-bit integers
void gfp2519pack(gfe_p2519 *v,const uchar8 *u) {

	uchar8 i,j,k,l;

	for (i=0;i<NLIMBS;++i) {
	
		j = i*8;
		v->l[i] = (uint64)u[j]; l = 1;
		for (k=1;k<9;++k)
			v->l[i] |= ((uint64)u[j+l++]  << k*8);
	}	
}


// converts from 64-bit integers to bytes
void gfp2519unpack(uchar8 *v,const gfe_p2519 *u) {

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
