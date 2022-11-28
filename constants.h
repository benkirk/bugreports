
#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <math.h>

#include <struct.h>

#ifndef M_PI
#define	M_PI		3.14159265358979323846	/* pi */
#endif
#ifndef M_PI_2
#define	M_PI_2		1.57079632679489661923	/* pi/2 */
#endif

#define	PI	M_PI
#define HPLANCK	6.626205e-27
#define CLIGHT	2.99792501e10
#define BOLTZK	1.3805e-16
#define CHK	1.4388296
#define AMU	1.66e-24
#define sqrt_AMU sqrt(AMU)

/* new Voigt calculation parameters */
#define M_EULER	 0.5772156649015328
#define  alpha   1.730512 /* 2*exp(1)/PI */
#define  B_TYP   1.17e10	/* typical B=0.39cm-1 in Hz */

/*#define	TMP0	296.0*/

#define TMP_DOP  296.0 /* in principle, it doesn't matter, what to put here */
#define	TMP_LOR  296.0

/* TMP_DOP was invented to test the dependence of limb radiation on voigt profile */
/* 03.04.02, 28.02.03 */

#define	CAV	(CLIGHT/sqrt(2*BOLTZK*TMP_DOP/AMU))
#define	PIOV2	M_PI_2
#define	HPSC	1.013e6
#define	CONSMN	HPLANCK*CAV/4/PI

#define H_4_PI  HPLANCK/4.0/PI
#define SQRT_2BOLTZK_AMU_C2 sqrt(2.0*BOLTZK/AMU/CLIGHT/CLIGHT)

#define sqRoot_2K_c2 sqrt(2.0*BOLTZK/CLIGHT/CLIGHT)
#define	H_4_K HPLANCK/4.0/BOLTZK

#define	MULTIPLIER	20
#define GASCONST 8.31441
#define N_AVOGADRO 6.022045e23

/* Molecular weights */
#define  H2O_Mweight 18
#define  CO2_Mweight 44
#define   O3_Mweight 48
#define  N2O_Mweight 42
#define   CO_Mweight 28
#define  CH4_Mweight 16
#define   O2_Mweight 32
#define   NO_Mweight 30
#define  NO2_Mweight 46
#define HNO3_Mweight 63
#define   OH_Mweight 17
#define   N2_Mweight 28
#define  HO2_Mweight 33
#define    O_Mweight 16
#define    C_Mweight 12
#define    N_Mweight 14
#define    H_Mweight  1

#define m_prot 1.672614e-27

/* Molecules in HITRAN order*/
#define	MOL_H2O		 1
#define	MOL_CO2		 2
#define	MOL_O3		 3
#define	MOL_N2O		 4
#define	MOL_CO		 5
#define	MOL_CH4		 6
#define	MOL_O2		 7
#define	MOL_NO		 8
#define	MOL_NO2		10
#define	MOL_HNO3	12
#define MOL_OH		13
#define	MOL_N2		22
#define MOL_HO2		33
#define	MOL_O		34

#define MOL_O1D 	40      /* HITRAN-96 !!! */
#define MOL_N		41
#define MOL_H		42

#define	NMOLMAX	50

/* Group names */

/* H2O */
#define H2O_GROUP_0	100
#define H2O_GROUP_1	101
#define H2O_GROUP_2	102
#define H2O_GROUP_3	103
#define H2O_GROUP_4	104
#define H2O_GROUP_5	105
#define H2O_GROUP_6	106

/* increase this, if more added */
#define H2O_GROUP_MAX	106

#define	H2O_VV_0	150
#define	H2O_VV_GROUP_4	154
#define	H2O_VV_GROUP_5	155

/* CO2 */
#define CO2_GROUP_0	200
#define CO2_GROUP_1	201
#define CO2_GROUP_2	202
#define CO2_GROUP_3	203
#define CO2_GROUP_4	204
#define CO2_GROUP_5	205
#define CO2_GROUP_6	206
#define CO2_GROUP_7	207
#define CO2_GROUP_8	208
#define CO2_GROUP_9	209
#define CO2_GROUP_10	210
#define CO2_GROUP_11	211
#define CO2_GROUP_12	212
#define CO2_GROUP_13	213
#define CO2_GROUP_14	214

/* increase this, if more added */
#define CO2_GROUP_MAX	214

#define	CO2_VV_0	250
#define	CO2_VV_1	251
#define	CO2_VV_2	252

/* O3 */
#define O3_GROUP_0	300
#define O3_GROUP_1	301
#define O3_GROUP_2	302
#define O3_GROUP_3	303
#define O3_GROUP_4	304
#define O3_GROUP_5	305
#define O3_GROUP_6	306
#define O3_GROUP_7	307
#define O3_GROUP_8	308
#define O3_GROUP_9	309
#define O3_GROUP_10 	310
#define O3_GROUP_11	311

/* increase this, if more added */
#define O3_GROUP_MAX	311

#define	O3_VV_0		350
#define O3_VV_102	351
#define	O3_VV_200	352
#define	O3_VV_001	353

/* N2O */
#define N2O_GROUP_0	400
#define N2O_GROUP_1	401
#define N2O_GROUP_2	402
#define N2O_GROUP_3	403

/* increase this, if more added */
#define N2O_GROUP_MAX	403

#define	N2O_VV_GROUP_0	450
#define	N2O_VV_GROUP_4	454
#define	N2O_VV_GROUP_5	455
#define	N2O_VV_GROUP_6	456

/* CO */
#define CO_GROUP_0	500
#define CO_GROUP_1	501
#define CO_GROUP_2	502
#define CO_GROUP_3	503
#define CO_GROUP_4	504
#define CO_GROUP_5	505
#define CO_GROUP_6	506

/* increase this, if more added */
#define CO_GROUP_MAX	506

#define	CO_VV_GROUP_0	550
#define	CO_VV_GROUP_1	551

/* O2 */
#define O2_GROUP_0	700
#define O2_GROUP_1	701
#define O2_GROUP_2	702
#define O2_GROUP_3	703
#define O2_GROUP_4	704
#define O2_GROUP_5	705
#define O2_GROUP_6	706

/* increase this, if more added */
#define O2_GROUP_MAX	706

#define	O2_VV_GROUP_0	750
#define	O2_VV_GROUP_1	751

/* NO */
#define NO_GROUP_0	800
#define NO_GROUP_1	801
#define	NO_GROUP_2	802

/* increase this, if more added */
#define NO_GROUP_MAX	802

#define NO_VV_GROUP_1	850


/* OH */
#define OH_GROUP_1	1301

/* increase this, if more added */
#define OH_GROUP_MAX	1301

/* N2 */
#define N2_GROUP_0	2200
#define N2_GROUP_1	2201
#define N2_GROUP_2	2202
#define N2_GROUP_3	2203
#define N2_GROUP_4	2204
#define N2_GROUP_5	2205
#define N2_GROUP_6	2206
#define N2_GROUP_7	2207

/* increase this, if more added */
#define N2_GROUP_MAX	2207


/* Hitran names of molecules */
extern const char *HitranName[];

#define PLANET_EARTH	0
#define PLANET_MARS	1
#define PLANET_VENUS	2

extern const char *PlanetName[];
extern const PLANET planet_param[];

/* Groups of chemical rate constants */

#define	NO_CHEMISTRY_HERE	0
#define	O3_CHEM_OUR		1
#define	O3_CHEM_VOLLMANN	2
#define	O2_CHEM_OUR		3
#define	NO_CHEM			4

/* Vibrational level = 0, rotational - 1 */

#define THE_VIB_LEVEL	0
#define THE_ROT_LEVEL	1


/* Type names for bands */

#define TYPE_OPT	0
#define TYPE_SUN	1
#define TYPE_CVT	2
#define	TYPE_AVT	3
#define	TYPE_LIMB	4

/* Transfer types */

#define	TRANSFER_LBL	1
#define	TRANSFER_ODF	2
#define TRANSFER_OVL	3

/* Absorb types */
#define ABSORB_LBL	1
#define ABSORB_ODF	2
#define ABSORB_SPHER	3

/* Limb calculation types */

#define LIMB_LBL	1
#define LIMB_ODF	2
#define LIMB_OVL	3

/* ODF representation types */
#define ODF_PARAMETERIZATION 	1
#define ODF_POINT_BY_POINT   	2
#define ODF_NEW_VOIGT		3

/* Limb retrieval types */
#define LIMB_RETR_PBP		1
#define LIMB_RETR_ALL_ALT	2

/* ODF types */

#define ODF_15mu	0	/* Important! This number should correspond to the index in */
#define ODF_4_3mu	1	/* array defined in odf_def.h file!!! */

/* branches */

#define O_branch	-2
#define P_branch	-1
#define Q_branch	 0
#define	R_branch	 1
#define S_branch	 2

#define	SKIP_branch	 -1234
#define DOUBLE_branch	 1234

#endif /* CONSTANTS_H */
