
int gauss(double , double , double *, double *, int);

double planck(double , double );

int reflect(int , double *);

int feaut2a(double *, double *, double *, double *,
	     double , double ,
	     double , double , int );

int feaut2a_opt(double *, double *, double *, double *,
	      double , int, double *);

int feaut2a_optlimb(double *, double *, double *,
	      double , int, double *);

int exp_along(double *, double *, int );

double poly(int n, double *y, double *x, double xx);

int interpol( int n , double *y , double *x ,
	      int nn, double *yy, double *xx);

int interpol_lin( int n , double *y , double *x ,
	      int nn, double *yy, double *xx);

int interpol_log( int n , double *y , double *x ,
	      int nn, double *yy, double *xx);

int interpol_inv( int n , double *y , double *x ,
	         int nn, double *yy, double *xx);

double voigt (double , double);

double doppler(double);

double voigt_appr (double , double);

double el_time(void);

double el_time2(void);

int dfe(double *dtaum, double *sm, double *jm, double *diagm,
	     double fincd, int nd,double *pool);

int dfe_opt1(double *dtaum, double *sm, double *jm, double *diagm,
	     double fincd, int nd,double *pool);

int shortc(double *dtaum, double *sm, double *jm, double *diagm,
	     double fincd, int nd,double *pool);

int longc(double *dtaum, double *sm, double *jm, double *diagm,
	     double fincd, int nd,double *pool);

int fea_ih(double *dtaum, double *sm, double *jm, double *diagm,
	     double fincd, int nd,double *pool);

double dfe_optlimb1(double *dtaum, double *sm, double *jm,
	            int nd,double *pool);

double dfe_optlimb2(double *dtaum, double *sm,
	            int nd);

double sho_optlimb1(double *dtaum, double *sm, int nd, double *pool);

double fea_optlimb1(double *dtaum, double *sm, double *jm, 
	            int nd,double *pool);

int dfe_geom1(double *dtaum, double *emism, double *dlm, double *jm,
	     double fincd, int nd, double *pool);

int dfe_geomlimb1(double *dtaum, double *emism, double *dlm, double *jm, 
	          int nd, double *pool);

double dfe_geomlimb2(double *dtaum, double *emism, double *dlm, int nd );

double exp_m1(double x);
