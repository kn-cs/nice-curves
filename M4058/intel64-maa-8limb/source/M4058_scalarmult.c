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
#include "gf_p44417_arith.h"
#include "M4058.h"

int M4058_scalarmult(uchar8 *q, const uchar8 *n, const uchar8 *p) {

	gfe_p44417_8L r[2];
	gfe_p44417_7L t;

	uchar8 i,s[CRYPTO_BYTES];

	for (i=0;i<CRYPTO_BYTES;++i) s[i] = n[i];
        s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] | 0x0F;
        s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] | 0x08;
	s[0] = s[0] & 0xFC;

	gfp44417pack(r,p);

	M4058_mladder(r,r,s);

	gfp44417inv(r+1,r+1);
	gfp44417mul(r,r,r+1);
	gfp44417reduce(r);
	gfp44417pack87(&t,r);
	gfp44417makeunique(&t);
	gfp44417unpack(q,&t);

	return 0;
}

int M4058_scalarmult_base(uchar8 *q, const uchar8 *n, const uchar8 *p) {

	gfe_p44417_8L r[2];
	gfe_p44417_7L t;

	uchar8 i,s[CRYPTO_BYTES];

	for (i=0;i<CRYPTO_BYTES;++i) s[i] = n[i];
        s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] | 0x0F;
        s[CRYPTO_BYTES-1] = s[CRYPTO_BYTES-1] | 0x08;
	s[0] = s[0] & 0xFC;

	gfp44417pack(r,p);

	M4058_mladder_base(r,r,s);

	gfp44417inv(r+1,r+1);
	gfp44417mul(r,r,r+1);
	gfp44417reduce(r);
	gfp44417pack87(&t,r);
	gfp44417makeunique(&t);
	gfp44417unpack(q,&t);

	return 0;
}
