
#ifndef MV_UTILS_H
#define MV_UTILS_H
#include <stdlib.h>

void mat_FTRANSP(int N, double **A); /* A=A^{T} */
void mat_FCLR(int N, double **A); /* A=0.0 */
void mat_FMUL(int N, double **A, double **B, double **C); /* C=A*B */
void mat_FADD(int N, double **A, double **B, double **C); /* C=A+B */
void mat_FSUB(int N, double **A, double **B, double **C); /* C=A-B */
void mat_INVERT(int N, double **A, double **C);           /* C=A^{-1) */
void vec_FADD(int N, double *A, double *B, double *C); /* C=A+B */
void vec_FSUB(int N, double *A, double *B, double *C); /* C=A-B */
double vec_FSMUL(int N, double *A, double *B); /* =<A,B> */
void matvec_FMUL(int N, double **A, double *B, double *C); /* C=A*B */
double ** mat_FMEMALLOC(int M, int N);
int ** mat_IMEMALLOC(int M, int N);
double * vec_FMEMALLOC(int N);
int * vec_IMEMALLOC(int N);
void mat_FMEMFREE(double **ptr, int M);
void vec_FMEMFREE(double *ptr);
int mat_LUDCMP(double **a, double *det, int n, int *indx);
int mat_LUBKSB(double **a,int n,int *indx,double *b);
int mat_MPROVE(double **a,double **alud,int n,int *indx,double *b,double *x);

#endif
