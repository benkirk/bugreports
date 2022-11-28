#if 0
#include <complex.h>
#endif

#include <stdio.h>

/*
 * Help functions/macros/...
 */

int iso_name_to_hitnumber(int iso_name);
int iso_name_to_iMol(
		int			iso_name,
		MOLECULE		*,
		PARAMETERINFO 		*pars
		);
double PROBDN(int , int );

int filesize(const char *filename);
int hit_getint(char *rec, int len);
double hit_getdbl(char *rec, int len);


int mol_in_the_problem (
			int		M,
			MOLECULE	*mol,
			PARAMETERINFO	*pars );

/*
 * Subroutines called by 'main'.
 */

MOLECULE * init_molecule_data (
		MOLECULE		*mol,
		PARAMETERINFO		*pars);

int init_parameters(PARAMETERINFO *pars);

/*
 * Info printing routines.
 */


int print_PARAMETERINFO (
		PARAMETERINFO		*);

int print_MOLECULE (
		MOLECULE 		*,
		int
		);

int print_VIBLEVEL (
		VIBLEVEL		*,
		int
		);

int print_ATMOSPHERE (
		ATMOSPHERE		*,
		int
		);

int print_QROT (
		double			**,
		int			,
		PARAMETERINFO 		*);

int print_POP(
		double			**,
		PARAMETERINFO		*);

int print_TVIB_plus(
		double			**,
		double			**,
		VIBLEVEL		*,
		MOLECULE		*,
		ATMOSPHERE		*,
		PARAMETERINFO		*);

int print_CVV (
		BAND_CVV		*,
		MOLECULE		*,
		VIBLEVEL		*,
		PARAMETERINFO		*);

int print_RMAT(
		double			**,
		int
		);

int print_FMAT(
		double			**A,
		int			NL,
		int			NR
		);

int print_RMAT_RHS(
		double			**,
		double			*,
		int
		);

int print_RMAT_RHS_long(
		double			**,
		double			*,
		int );

VIBLEVEL * init_vl_data (
		MOLECULE		*mol,
		VIBLEVEL		*v_level,
		PARAMETERINFO		*pars);

void fill_atmosphere_model (ATMOSPHERE		*atmos,
			PARAMETERINFO		*pars,
			MOLECULE		*mol,
			float			*H,
			float			*P,
			float			*T,
			float			*CO2,
			float			*O,
			float			*N2,
			float			*O2);

int fill_atmos (
		ATMOSPHERE		*atmos);

int compute_qrot (
		double			**Qrot,
		VIBLEVEL		*v_level,
		ATMOSPHERE		*atmos,
		PARAMETERINFO		*pars);

BAND_CVV * fill_CVV (
		MOLECULE		*molecule,
		VIBLEVEL		*v_level,
		BAND_CVV		*cvv_band,
		DEBYE_INFO		*deb,
		PARAMETERINFO		*pars);

BAND_CVT * compute_static_coll_coeff(
		MOLECULE		*molecule,
		VIBLEVEL		*v_level,
		PBAND_CVT		*pcvt_band,
		ATMOSPHERE		*atmos,
		double			**Qrot,
		DEBYE_INFO		*deb,
		PARAMETERINFO		*pars);

int popul2(
		double			**,
		double			**,
		double			**,
		MOLECULE		*,
		VIBLEVEL		*,
		ATMOSPHERE		*,
		PARAMETERINFO		*);

DEBYE_INFO * init_DEBYE(
		DEBYE_INFO		*deb,
		PARAMETERINFO		*pars,
		MOLECULE		*mol);

int	copy_DEBYE(	DEBYE_INFO	*deb_src,
			int		i,
			DEBYE_INFO	*deb,
			int		j);

int clear_Rmat ( double **, int );

int clear_array ( double **A, int NX,int NY);

int compute_populations(
     		BAND_ODF		*odf_band,
		PBAND_CVT		*pcvt_band,
     		double			**Rmat,
     		MOLECULE		*mol,
		VIBLEVEL		*v_level,
     		double			**PopVN,
     		ATMOSPHERE		*atmos,
     		PARAMETERINFO		*pars,
     		int			id);

int	compute_dynamic_coll_coeff(
		BAND_CVV 		*,
		VIBLEVEL		*,
		ATMOSPHERE		*,
		MOLECULE		*,
		double 			**,
		double 			**,
		double 			**,
		PARAMETERINFO		*,
		double			**,
		int
		);


double check_conv(
		double 			**PopV,
		double 			**PopVN,
		double			**Delta,
		PARAMETERINFO		*pars );

int do_ng_acceleration(
		int			iter,
		MOLECULE		*molecule,
		double			**PopV,
		double			**PopVN,
		double			***G, /* PopStack      */
		double			***D, /* PopStackDelta */
		PARAMETERINFO		*pars);

BAND_CVV * read_external_CVV (
		BAND_CVV		*cvv_band,
		VIBLEVEL		*v_level,
		MOLECULE		*mol,
		PARAMETERINFO		*pars);


double find_debye(
		int			iMol,
		int			ivu,
		int			ivl,
		MOLECULE		*molecule,
		DEBYE_INFO		*deb,
		PARAMETERINFO		*pars);

int	ch_rates (
		int			mode,
     		PBAND			*pband,
     		MOLECULE		*mol,
		VIBLEVEL		*v_level,
     		double			**PopV,
     		ATMOSPHERE		*atmos,
     		PARAMETERINFO		*pars);

int update_pops(
		double 			**PopV,
		double 			**PopVN,
		PARAMETERINFO		*pars );



int check_VMRs(
		ATMOSPHERE		*atmos,
		ATMOSPHERE		*atmosN,
		PARAMETERINFO		*pars);


int alloc_atmos (
		int			ND,
		ATMOSPHERE		*atmos);

int free_atmos (
		ATMOSPHERE	*atmos,
		int		ND);

int alloc_rates(
		int			ND,
		PBAND			*pband);

int dealloc_rates(
		int			ND,
		PBAND			*pband);

int	ch_vib_rates (
     		BAND_ODF		*band_odf,
     		MOLECULE		*mol,
		VIBLEVEL		*v_level,
     		double			**PopV,
     		ATMOSPHERE		*atmos,
     		PARAMETERINFO		*pars,
		float			*CH_SUM);

int check_TE(
		ATMOSPHERE		*atmos,
		ATMOSPHERE		*atmosN,
		PARAMETERINFO		*pars);

int	transfer_odf(
		double			**PopV,
		double			**Qrot,
		ATMOSPHERE		*atmos,
		VIBLEVEL		*v_level,
		MOLECULE		*mol,
		PARAMETERINFO		*pars,
      		BAND_ODF               *band_odf);

int sign(double argument);

int init_ODF_freq(INTEGR_ODF		*integr_ODF,
		  PARAMETERINFO		*pars);

int free_ODF_freq(INTEGR_ODF	*integr_ODF);

void	quick_sort(double **Y,int left, int right);

int clear_rates(
		int			ND,
		PBAND			*pband);

int is_level_in_problem(
			MOLECULE	*mol,
			int		iMol,
			VIBLEVEL	*v_level,
			int		il);

int init_odf (double		**Qrot,
              ATMOSPHERE	*atmos,
              VIBLEVEL		*v_level,
              MOLECULE		*mol,
              PARAMETERINFO	*pars,
              BAND_ODF		*band_odf);

int	copy_odf_src(	const LINE_ODF_prelim *odf_src,
			int 		i,
			LINE_ODF	*line_odf,
			int		j);

double	param_odf(double	x, double	P, double	T);

int	free_band_odf(BAND_ODF	*band_odf,int	ND);
