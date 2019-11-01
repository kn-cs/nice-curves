/*
+-------------------------------------------------------------------------------+
|  This file has the performance measurement strategy used in the paper titled  |
|  "The Software Performance of Authenticated-Encryption Modes" by the authors  |
|  Ted Krovetz and Phillip Rogaway. 						|
|  Web link: http://dx.doi.org/10.1007/978-3-642-21702-9_18			|
+-------------------------------------------------------------------------------+
*/

#ifndef __MEASURE__
#define __MEASURE__

int comp(const void *, const void *);
void median_next(unsigned);
extern void qsort(void *, size_t, size_t, int (*)(const void *, const void *));

#define CACHE_WARM_ITER 25000
#define MAX_ITER 100000
#define M 1000
#define N 1000

#define STAMP ({unsigned res; __asm__ __volatile__ ("rdtsc" : "=a"(res) : : "edx"); res;}) /* Time stamp */

#define MEASURE_TIME(x)					\
	do { 						\
		int i,j; 				\
		for (i = 0; i < M; i++) { 		\
							\
			unsigned c2, c1;		\
			for(j=0;j<CACHE_WARM_ITER;j++) {\
				x;			\
			}				\
			c1 = STAMP;			\
			for (j = 1; j <= N; j++) { 	\
				x; 			\
			}				\
			c1 = STAMP - c1;		\
			median_next(c1);		\
		} 					\
	} while (0)


unsigned values[MAX_ITER];
int num_values = 0;

unsigned get_median(void) {

	unsigned res;

	qsort(values, num_values, sizeof(unsigned), comp);
    	res = values[num_values/2];
    	num_values = 0;
    	return res;
}


int comp(const void *x, const void *y) { 

	return *(unsigned *)x - *(unsigned *)y; 
}

	
void median_next(unsigned x) { 

	values[num_values++] = x; 
}


#endif
