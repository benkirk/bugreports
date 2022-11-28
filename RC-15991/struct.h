#ifndef STRUCT_H
#define STRUCT_H

#define CHECK_PTR(x) {\
	if(!(x)) \
	{\
	 printf("NULL pointer returned by malloc(no free memory), exiting...\n");\
	 exit(1);\
	};\
}

typedef struct {
	int		NA;
	int		NMOL;
	int		ND;
	int		NVL;
	int		NL;
	int		NCVT;
	int		NCVV;
	int		N15MKM;
	double		RPR21;
	double		RPR42;
	double		tets;
	double		conv;
	int		itermax;
	int		iter0;
	int		kback;
	int		kdlay;
	int		nacc;
	int		planet;
	double		alb;
	int		vv_use_lower;
	int		co2_rules;	/* to use selection rules or not */
	double		CO2_O_rate_constant;
	int		odf_NF1;
	int		odf_NF2;
	double		odf_xcore;
	double		odf_xmax;
	int		num1_0;
	int		P_R_join;	/* combining P and R branches to one */
	} PARAMETERINFO;

typedef struct {
	int		NA;
	double		*mu;
	double		*mw;
	int		NF;
	double		*x;
	double		*xw;
	} INTEGR_ODF;


typedef struct {
	int		iso;
	int		ivu_name;       /* 02201, etc */
	int		ivl_name;	/* 01101, etc */
	double		GAIR;
	double		CTMP;
	double		B_rot;		/* rotational constant */
	double		sqrt_M;		/* square root from m */
	double		f0_band;   	/* EVU - EVL */
	double		A_band;         /* for the most intensive line at T=300K */
	double		BU_band;
	double		BD_band;
	double		SumWup;		/* sum of rotational distribution =1, 0.5 */
	double		SumWlo;		/* ---//--- for the lower level  */
	int		type;		/* -1/0/1 = P/Q/R */
        double		koeff_tmp;       /* precalculated and rounded rescaling coefficient - added 29/03/2020 */
	} LINE_ODF_prelim;

typedef struct {
	int			N_elts;
	double		P;
	double		T;
	double		DOP; /* Doppler halfwidth, can be used for recalculations back- and forth */
	double		X_ODF[30];
	double		prof[30];
	} ODF_LUT;











typedef struct {
	int		mole;
	int		iso;
	int		ivu_name;       /* 02201, etc */
	int		ivl_name;	/* 01101, etc */
        int		IVU;            /* local number for the current run */
        int		IVL;
	double		GAIR;
	double		CTMP;
	double		B_rot;		/* rotational constant */
	double		sqrt_M;		/* square root from m */
	double		f0_band;   	/* EVU - EVL */
	double		A_band;         /* for the most intensive line at T=300K */
	double		BU_band;
	double		BD_band;
	double		SumWup;		/* sum of rotational distribution =1, 0.5 */
	double		SumWlo;		/* ---//--- for the lower level  */
	int		type;		/* -1/0/1 = P/Q/R */
	double		*koeff;
	/* =line_odf[odf_index].profile[id]/line_odf[4].profile[id]*/
        /* koeff is used for renormalising of ODF profile */

	double		FincD;
        double		koeff_tmp; /* technical trick, saving data and rounding them 29/03/2020 */
	} LINE_ODF;

typedef struct {
	INTEGR_ODF	*integr_odf;
	int		odf_num;
	LINE_ODF	*line_odf;
	double		**ODF_PROFILE;
	double		**rate_Up;
	double		**rate_Do;
	} BAND_ODF;

typedef	struct {
	int		mole;
	int		iso;
	int		name;
	int		chem_group;
	double		chem_dmulti;
	double		energy;
	double		K_H_Brot;	/* BOLTZK /HPLANCK / B_rot */
	} VIBLEVEL;

typedef	struct {
	int		mole;
	int		iso;
	double		frequency;
	double		debye;		/* for co2 only */
	int		partner;	/* hitran number of*/
	int		ivu_index;
	int		ivl_index;
	int		group;
	double		alt_indep;
	int		alt_dep;
	} BAND_CVT;

typedef	struct {
	int		NUM;
	int		type;
	void		*band;
	double		**rate_Up;
	double		**rate_Do;
	} PBAND_CVT;

typedef	struct {
	int		mole1;
	int		iso1;
	int		mole2;
	int		iso2;
	int		ivu_index1;
	int		ivl_index1;
	int		ivu_index2;
	int		ivl_index2;
	int		group;
	double		alt_indep;
	int		alt_dep;
	} BAND_CVV;

typedef	struct {
	int		hitnumber;
	int		iso;
	double		sqamass;
	double		abund;
	int		nvl;
	int		ivu_index;
	int		ivl_index;
	} MOLECULE;

typedef struct {
	double		*altitude;
	double		*c_volume;
	double		*temperature;
	double		*sqrt_T;
	double		*pressure;
	double		*concentration;
	double		*Cp;
	int		ND;
	double		*WTS_suppl_0;
	double		*WTS_suppl_1;
	} ATMOSPHERE;

typedef struct {
	int		iso;
	int		u_level;
	int		l_level;
	double		frequency;
	double		aein;
	double		debye;
	} DEBYE_INFO_prelim;

typedef struct {
	int		iso;
	int		u_level;
	int		l_level;
	double		frequency;
	double		aein;
	double		debye;
	} DEBYE_INFO;

typedef struct {
    int     hitnumber;
    int     iso;
    int     name;
    double      abund;
    double      q296;
    int     gj;
    double      amass;
    int     sym;
    } MOLPARAM;

typedef struct {
	double		R;
	double		AU;
        double          g;
	} PLANET;

typedef	struct {
	int		NUM;
	int		type;
	void		*band;
	double		**rate_Up;
	double		**rate_Do;
	} PBAND;

#endif /* STRUCT_H */
