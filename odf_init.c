#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <struct.h>
#include <functions.h>
#include <constants.h>
#include <subroutines.h>
#include <mv_utils.h>

int init_odf (double		**Qrot,
              ATMOSPHERE	*atmos,
              VIBLEVEL		*v_level,
              MOLECULE		*mol,
              PARAMETERINFO	*pars,
              BAND_ODF		*band_odf)

{
 const LINE_ODF_prelim odf_src[]={
#include "odf_hitran.h"

#if 0
 {626, 1101,    1,1.0,0.7,0.39,8.5463442e-12,667.0,0.5,0.5,0.5,1.0},
 {636, 1101,    1,1.1,0.7,0.39,8.6429162e-12,667.0,0.5,0.5,0.5,1.0},
 {626, 2201, 1101,1.2,0.7,0.39,8.5463442e-12,667.0,0.5,0.5,0.5,1.0}
#endif
 };
/* iso, ivu,  ivl,G0,CTMP,Brot,sqM,fband,A_b,BU_,BD_,SumWup */

 /* new structure, 22/03/2020 */
 const ODF_LUT odf_lut[] ={
#include "odf_lut.h"
};

 LINE_ODF	*line_odf;

 double		**ODF_PROFILE;
 double		*P, *TE, *x;
 double		dNuLor,dNuDop,sqRoot_Bi_B0,sqRoot_M0_Mi,F0i_F00,exp_coeff;
 double		exp_B0_Bi,compl_coeff,Q00,Qmax,xnorm;
 double		w_LL, w_LR, w_RL, w_RR, w_T_left, w_T_right, w_P_left, w_P_right;

 const int N_P_LUT=221, N_T_LUT=51;  /* hardwired coefficients bound to LUT, updated on the 5th of April 2020 */
 int		NMAX,ivl,NVL,i,id,ND,num1_0;
 int		U_found,L_found,odf_counter,ifr,NF,P_R_join, N_LUT, i_lut, i_elt;
 int		i_T_left, i_T_right, i_P_left, i_P_right, i_LL, i_LR, i_RL, i_RR;

 TE		=atmos->temperature;
 P		=atmos->pressure;

 line_odf	=band_odf->line_odf;
 NVL		=pars->NVL;
 ND		=pars->ND;
 P_R_join	=pars->P_R_join;
 NF		=band_odf->integr_odf->NF;
 x		=band_odf->integr_odf->x;


 if ((pars->odf_NF1+pars->odf_NF2)!=odf_lut[0].N_elts )
  {
   printf("ODF N points in the LUT and in the parameters do not match: %i != %i, exiting\n",pars->odf_NF1+pars->odf_NF2, odf_lut[0].N_elts);
   exit(123);
  }

  N_LUT=sizeof(odf_lut)/sizeof(odf_lut[0]);

#if 0
  for (i_lut=0;i_lut<N_LUT;i_lut++)
   {
	printf("LUT %14.6e %8.3f\n",odf_lut[i_lut].P, odf_lut[i_lut].T);
	for (i_elt=0;i_elt<odf_lut[i_lut].N_elts;i_elt++)
	 {
	  printf("%14.6e %14.6e\n",odf_lut[i_lut].X_ODF[i_elt],odf_lut[i_lut].prof[i_elt]);
     }
   }
#endif


 ODF_PROFILE	=band_odf->ODF_PROFILE;

 NMAX=sizeof(odf_src)/sizeof(LINE_ODF_prelim);

#ifdef PRINT
 printf("NMAX= %i\n",NMAX);
#endif

 odf_counter=0;
 num1_0=-1;

 for(i=0;i<NMAX;i++)
  {
   ivl=0;
   U_found=0;
   L_found=0;

   while (((!U_found)||(!L_found))&&(ivl<NVL))
    {
     if (odf_src[i].iso==v_level[ivl].iso)
      {
       if (odf_src[i].ivu_name==v_level[ivl].name) U_found=ivl+1; /* trick */
       if (odf_src[i].ivl_name==v_level[ivl].name) L_found=ivl+1; /* trick */
      }
     ivl++;
    }

   if ((U_found)&&(L_found))                                    /* purpose of the trick */
    {
     copy_odf_src(odf_src,i,line_odf,odf_counter);
     line_odf[odf_counter].IVU=U_found-1;			/* recovering  */
     line_odf[odf_counter].IVL=L_found-1;			/* real ivl numbers */
     line_odf[odf_counter].mole=v_level[line_odf[odf_counter].IVU].mole;
     line_odf[odf_counter].koeff=vec_FMEMALLOC(ND);

     if ((num1_0<0)&&(odf_src[i].iso==626)&&
                     (odf_src[i].ivu_name==1101)&&
		     (odf_src[i].ivl_name==1)       )
      {
       pars->num1_0	=odf_counter;
       num1_0		=odf_counter;
      }
#if 0
     printf("odf N %i is included\n",i);
     printf("iso= %3i U= %5.5d L= %5.5d\n",
     line_odf[odf_counter].iso,
     line_odf[odf_counter].ivu_name,
     line_odf[odf_counter].ivl_name);
#endif
      odf_counter++;
    }
  } /* i - cycle over ODF */

 if (-1==num1_0)
  {
   printf("no data for basic ODF. Exiting...\n");
   exit(0);
  }

#ifdef PRINT
 printf("num1_0= %3i\n",num1_0);
#endif

 /* calculating koeff[id] = sqrt(Brot/Brot0)*exp(-h(Brot0-Brot)/4/BOLTZK/TE[id])* */
 /* *f0_band/f0_band0*sqrt(m0/m)*voigt(0,AV)/voigt(0,AV0) */

#if 0     /* 29/03/2020 - simplified to LUT values */
 for(i=0;i<odf_counter;i++)
  {
   for(id=0;id<ND;id++)
    {
     line_odf[i].koeff[id]=line_odf[i].koeff_tmp;
    }
  }
#endif

 for(id=0;id<ND;id++)
  {
   xnorm=0.0;
   /* NB!!! hardwiring i_T and i_P indices assuming that no one will change the LUT !!!! */
   i_T_left=floor((TE[id]-100.0)/10.0);
   if (i_T_left<0) i_T_left=0;
   if (i_T_left>N_T_LUT-1) i_T_left=N_T_LUT-1; /* index in a 1D array */
   i_T_right=i_T_left+1;
   if (i_T_right>N_T_LUT-1) i_T_right=N_T_LUT-1;

   i_P_left=floor(-log10(P[id])/.05)-5; /* 221 elements, from 0 to 220, P=10^(-0.05*index); NB!!! -5 gives the best fit,  see the records of 05 April 2020 */
   if (i_P_left < 0) i_P_left=0;
   if (i_P_left > N_P_LUT-1) i_P_left=N_P_LUT-1;
   i_P_right=i_P_left+1;
   if (i_P_right>N_P_LUT-1) i_P_right=N_P_LUT-1;

   i_LL=i_T_left*N_P_LUT+i_P_left;
   i_LR=i_T_left*N_P_LUT+i_P_right;
   i_RL=i_T_right*N_P_LUT+i_P_left;
   i_RR=i_T_right*N_P_LUT+i_P_right;

   if (i_T_left!=i_T_right)
    {
     w_T_right=(TE[id]-odf_lut[i_LL].T)/(odf_lut[i_RL].T-odf_lut[i_LL].T);
     w_T_left=1.0-w_T_right;
    }
   else
    {
     w_T_left=0.5;
     w_T_right=0.5;
    }

   if (i_P_left!=i_P_right)
    {
     w_P_right=(log10(P[id])-log10(odf_lut[i_LL].P))/(log10(odf_lut[i_LR].P)-log10(odf_lut[i_LL].P));
     w_P_left=1.0-w_P_right;
    }
   else
    {
     w_P_left=0.5;
     w_P_right=0.5;
    }

   w_LL=w_T_left+w_P_left;  /* there's no need to renormalize the weights here */
   w_RL=w_T_right+w_P_left; /* because there will be normalization by xnorm, anyway */
   w_LR=w_T_left+w_P_right;
   w_RR=w_T_right+w_P_right;

   if (1==0)
    {
     printf("\nwww: %8.3f %8.3f %8.3f %8.3f %8.3f\n", w_LL, w_RL, w_LR, w_RR, w_LL+w_LR+w_RL+w_RR);

     printf("wwwT: %8.3f %8.3f %8.3f %8.3f\n",w_T_left, odf_lut[i_LL].T, TE[id], odf_lut[i_RL].T );
     printf("wwwP: %8.3f %14.6e %14.6e %14.6e\n",w_P_left, odf_lut[i_LL].P, P[id], odf_lut[i_LR].P );
     printf("TTT: %8.3f %8.3f %8.3f %8.3f %8.3f\n", TE[id], odf_lut[i_LL].T, odf_lut[i_LR].T, odf_lut[i_RL].T, odf_lut[i_RR].T);
     printf("PPP: %14.6e %14.6e %14.6e %14.6e %14.6e\n", P[id], odf_lut[i_LL].P, odf_lut[i_LR].P, odf_lut[i_RL].P, odf_lut[i_RR].P);
    }


   for(ifr=0;ifr<NF;ifr++)
    {
     /* ODF_PROFILE[id][ifr]=prof0[id]*param_odf(x[ifr]*prof0[id],P[id],TE[id]);*/
     ODF_PROFILE[id][ifr]= w_LL*odf_lut[i_LL].prof[ifr] +
                           w_LR*odf_lut[i_LR].prof[ifr] +
                           w_RL*odf_lut[i_RL].prof[ifr] +
                           w_RR*odf_lut[i_RR].prof[ifr];

     if ((ifr>NF*0.05)&&(ifr<NF*0.15))  ODF_PROFILE[id][ifr]*=2.0;

     xnorm+=ODF_PROFILE[id][ifr]*band_odf->integr_odf->xw[ifr];

    }
   for(ifr=0;ifr<NF;ifr++)
    {
     ODF_PROFILE[id][ifr]/=2.0*xnorm;
#if 0
     printf("id= %3i X= %8.6e Y= %6.4e\n",id,x[ifr],ODF_PROFILE[id][ifr]);
#endif
    }
#ifdef PRINT
     printf("id= %3i xnorm= %6.4e\n",id,2.0*xnorm);
#endif
  }

 if (P_R_join)
  {
   for(i=0;i<odf_counter;i++)
    {
     if (line_odf[i].type==P_branch)
      {
       if (i<odf_counter-2)
        {
         if ((line_odf[i+2].type==R_branch)&&
             (line_odf[i+2].iso==line_odf[i].iso)&&
	     (line_odf[i+2].IVU==line_odf[i].IVU)&&
             (line_odf[i+2].IVL==line_odf[i].IVL)
	     )
	  {
	   line_odf[i  ].type=DOUBLE_branch;
	   line_odf[i+2].type=SKIP_branch;
	  }
        }
       if (i<odf_counter-1)
        {
         if ((line_odf[i+1].type==R_branch)&&
             (line_odf[i+1].iso==line_odf[i].iso)&&
	     (line_odf[i+1].IVU==line_odf[i].IVU)&&
             (line_odf[i+1].IVL==line_odf[i].IVL)
	     )
	  {
           line_odf[i  ].type=DOUBLE_branch;
	   line_odf[i+1].type=SKIP_branch;
	  }
        }
      }	/* type==-1 - P-branch*/
    }  /* odf_index */
  } /* P_R_join */

 return odf_counter;
}

int	copy_odf_src(	const LINE_ODF_prelim *odf_src,
			int 		i,
			LINE_ODF	*line_odf,
			int		j)
{
 line_odf[j].iso	=odf_src[i].iso;
 line_odf[j].ivu_name	=odf_src[i].ivu_name;
 line_odf[j].ivl_name	=odf_src[i].ivl_name;
 line_odf[j].GAIR	=odf_src[i].GAIR;
 line_odf[j].CTMP	=odf_src[i].CTMP;
 line_odf[j].B_rot	=odf_src[i].B_rot;
 line_odf[j].sqrt_M	=odf_src[i].sqrt_M;
 line_odf[j].f0_band	=odf_src[i].f0_band;
 line_odf[j].A_band	=odf_src[i].A_band;
 line_odf[j].BU_band	=odf_src[i].BU_band;
 line_odf[j].BD_band	=odf_src[i].BD_band;
 line_odf[j].SumWup	=odf_src[i].SumWup;
 line_odf[j].SumWlo	=odf_src[i].SumWlo;
 line_odf[j].type	=odf_src[i].type;
 line_odf[j].koeff_tmp	=odf_src[i].koeff_tmp; /* 29/03/2020 */

 return 0;
}

double	param_odf(double	x, double	P, double	T)
{
 const double	A1=-1.91*0.975, A2=-1.8e-1*0.975,A3=1.65e-2*0.975;
 const double	A6=-2.5e-5*0.975;
 const double	B1=2.223e-4,B2=400.0,B3=0.75+0.5,B4=1e-5;
 const double	C1= 64.2327,C2= 0.106409, C3=2.18864, C4= -20.0082;
 double		x2,x3,x6,y,B,x0, dLor;

 B=B1*pow((B2/T),B3)*P/B4;

 x0=C1/(pow(B,C2)+C3)+C4;

 dLor=0.05*pow(296.0/T,0.7)*P;

 if (x<x0)
  {
   x2=x*x;
   x3=x2*x;
   x6=x3*x3;
   y=exp(A1*x+A2*x2+A3*x3+A6*x6);
  }
 else
  {
   y=B/x/x;
  }

 /*
 CORE:
 y=exp(-1.91*x-1.8e-1*x^2+1.65e-2*x^3-2.5e-5*x^6)*1.0248,
 new vesrion;
 y=exp(0.975*(-1.91*x-1.8e-1*x^2+1.65e-2*x^3-2.5e-5*x^6))

 WING:
 y=b/x^2, where
 b=2.2e-4*(400/T)^(0.75+0.5)*p/1e-5
 */

 return y;
}

int  free_band_odf(BAND_ODF	*band_odf,int	ND)
{
 int	i;

 mat_FMEMFREE(band_odf->ODF_PROFILE,ND);
 mat_FMEMFREE(band_odf->rate_Up,ND);
 mat_FMEMFREE(band_odf->rate_Do,ND);

 for(i=0;i<band_odf->odf_num;i++)
   free(band_odf->line_odf[i].koeff);

 free(band_odf->line_odf);
 free(band_odf);

 return 0;
}
