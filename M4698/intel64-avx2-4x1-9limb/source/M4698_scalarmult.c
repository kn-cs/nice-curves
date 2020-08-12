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
#include "gf_p2519_pack.h"
#include "gf_p2519_arith.h"
#include "M4698.h"
#include <stdio.h>

int M4698_scalarmult(uchar8 *q, const uchar8 *n, const uchar8 *p) {

	vec r[NLIMBS_VEC] = {0};
	vec t[NLIMBS_VEC] = {0};

	gfe_p2519_9L u[2];
	gfe_p2519_4L v[2];

	uchar8 i,s[CRYPTO_BYTES];

	for (i=0;i<CRYPTO_BYTES;++i) s[i] = n[i];
	s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] & 0x07;
	s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] | 0x04;
	s[0] = s[0] & 0xFC;

	gfp2519pack(u,p);

	t[0][0] = t[0][3] = r[0][2] = 1; 
	
	for (i=0;i<NLIMBS_VEC;++i) {t[i][2] = u[0].l[i]; r[i][3] = u[0].l[i];}

	M4698_mladder(t,r,s);

	for (i=0;i<NLIMBS_VEC;++i) {u[0].l[i] = t[i][0]; u[1].l[i] = t[i][1];}

	gfp2519pack94(v,u);
	gfp2519pack94(v+1,u+1);

	#if defined(__ADX__)

		gfp2519invx(v+1,v+1);
		gfp2519mulx(v,v,v+1);
	#else
		gfp2519inv(v+1,v+1);
		gfp2519mul(v,v,v+1);
	#endif

	gfp2519reduce(v);
	gfp2519makeunique(v);
	gfp2519unpack(q,v);

	return 0;
}

int M4698_scalarmult_base(uchar8 *q, const uchar8 *n, const uchar8 *p) {

	vec r,t[NLIMBS_VEC] = {0};

	gfe_p2519_9L u[2];
	gfe_p2519_4L v[2];

	uchar8 i,s[CRYPTO_BYTES];

	for (i=0;i<CRYPTO_BYTES;++i) s[i] = n[i];
	s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] & 0x07;
	s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] | 0x04;
	s[0] = s[0] & 0xFC;

	gfp2519pack(u,p);

	t[0][0] = t[0][3] = r[0] = r[1] = r[2] = 1; r[3] = u[0].l[0];
	
	for (i=0;i<NLIMBS_VEC;++i) t[i][2] = u[0].l[i];

	M4698_mladder_base(t,r,s);

	for (i=0;i<NLIMBS_VEC;++i) {u[0].l[i] = t[i][0]; u[1].l[i] = t[i][1];}

	gfp2519pack94(v,u);
	gfp2519pack94(v+1,u+1);

	#if defined(__ADX__)

		gfp2519invx(v+1,v+1);
		gfp2519mulx(v,v,v+1);
	#else
		gfp2519inv(v+1,v+1);
		gfp2519mul(v,v,v+1);
	#endif

	gfp2519reduce(v);
	gfp2519makeunique(v);
	gfp2519unpack(q,v);

	return 0;
}
