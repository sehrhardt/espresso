/*
  Copyright (C) 2010,2011,2012,2013,2014 The ESPResSo project
  Copyright (C) 2002,2003,2004,2005,2006,2007,2008,2009,2010 
    Max-Planck-Institute for Polymer Research, Theory Group
  
  This file is part of ESPResSo.
  
  ESPResSo is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  ESPResSo is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
*/
#ifndef _THERMOSTAT_H
#define _THERMOSTAT_H
/** \file thermostat.hpp 

*/

#include <cmath>
#include "utils.hpp"
#include "particle_data.hpp"
#include "random.hpp"
#include "global.hpp"
#include "integrate.hpp"
#include "cells.hpp"
#include "lb.hpp"
#include "dpd.hpp"
#include "virtual_sites.hpp"

/** \name Thermostat switches*/
/************************************************************/
/*@{*/

#define THERMO_OFF        0
#define THERMO_LANGEVIN   1
#define THERMO_DPD        2
#define THERMO_NPT_ISO    4
#define THERMO_LB         8
#define THERMO_INTER_DPD  16
#define THERMO_GHMC       32
#define THERMO_CPU       64

/*@}*/

#if (!defined(FLATNOISE) && !defined(GAUSSRANDOMCUT) && !defined(GAUSSRANDOM))
#define FLATNOISE
#endif

/************************************************
 * exported variables
 ************************************************/

/** Switch determining which thermostat to use. This is a or'd value
    of the different possible thermostats (defines: \ref THERMO_OFF,
    \ref THERMO_LANGEVIN, \ref THERMO_DPD \ref THERMO_NPT_ISO). If it
    is zero all thermostats are switched off and the temperature is
    set to zero.  */
extern int thermo_switch;

/** temperature. */
extern double temperature;

/** Langevin friction coefficient gamma. */
extern double langevin_gamma;

/** Friction coefficient for nptiso-thermostat's inline-function friction_therm0_nptiso */
extern double nptiso_gamma0;
/** Friction coefficient for nptiso-thermostat's inline-function friction_thermV_nptiso */
extern double nptiso_gammav;

/** Number of NVE-MD steps in GHMC Cycle*/
extern int ghmc_nmd;
/** Phi parameter for GHMC partial momenum update step */
extern double ghmc_phi;

/************************************************
 * functions
 ************************************************/


/** initialize constants of the thermostat on
    start of integration */
void thermo_init();

/** very nasty: if we recalculate force when leaving/reentering the integrator,
    a(t) and a((t-dt)+dt) are NOT equal in the vv algorithm. The random
    numbers are drawn twice, resulting in a different variance of the random force.
    This is corrected by additional heat when restarting the integrator here.
    Currently only works for the Langevin thermostat, although probably also others
    are affected.
*/
void thermo_heat_up();

/** pendant to \ref thermo_heat_up */
void thermo_cool_down();

/** Get current temperature for CPU thermostat */
int get_cpu_temp();

/** Start the CPU thermostat */
void set_cpu_temp(int temp);

/** locally defined funcion to find Vx. In case of LEES_EDWARDS, that is relative to the LE shear frame
    @param i      coordinate index
    @param vel    velocity vector
    @param pos    position vector
    @return       adjusted (or not) i^th velocity coordinate */
inline double le_frameV(int i, double *vel, double *pos)
{
#ifdef LEES_EDWARDS

   if( i == 0 ){
       double relY  = pos[1] * box_l_i[1] - 0.5;
       return( vel[0] - relY * lees_edwards_rate );
   }

#endif

   return vel[i];
}

#ifdef NPT
/** add velocity-dependend noise and friction for NpT-sims to the particle's velocity 
    @param dt_vj  j-component of the velocity scaled by time_step dt 
    @return       j-component of the noise added to the velocity, also scaled by dt (contained in prefactors) */
inline double friction_therm0_nptiso(double dt_vj) {
  extern double nptiso_pref1, nptiso_pref2;
  if(thermo_switch & THERMO_NPT_ISO)   
#if defined (FLATNOISE)
    return ( nptiso_pref1*dt_vj + nptiso_pref2*(d_random()-0.5) );
#elif defined (GAUSSRANDOMCUT)
    return ( nptiso_pref1*dt_vj + nptiso_pref2*gaussian_random_cut() );
#elif defined (GAUSSRANDOM)
    return ( nptiso_pref1*dt_vj + nptiso_pref2*gaussian_random() );
#else
#error No Noise defined
#endif
  return 0.0;
}

/** add p_diff-dependend noise and friction for NpT-sims to \ref nptiso_struct::p_diff */
inline double friction_thermV_nptiso(double p_diff) {
  extern double nptiso_pref3, nptiso_pref4;
  if(thermo_switch & THERMO_NPT_ISO)   
#if defined (FLATNOISE)
    return ( nptiso_pref3*p_diff + nptiso_pref4*(d_random()-0.5) );
#elif defined (GAUSSRANDOMCUT)
    return ( nptiso_pref3*p_diff + nptiso_pref4*gaussian_random_cut() );
#elif defined (GAUSSRANDOM)
    return ( nptiso_pref3*p_diff + nptiso_pref4*gaussian_random() );
#else
#error No Noise defined
#endif
  return 0.0;
}
#endif

/** overwrite the forces of a particle with
    the friction term, i.e. \f$ F_i= -\gamma v_i + \xi_i\f$.
*/
inline void friction_thermo_langevin(Particle *p)
{
  extern double langevin_pref1, langevin_pref2;
#ifdef LANGEVIN_PER_PARTICLE
  double langevin_pref1_temp, langevin_pref2_temp;
#endif
  
  int j;
#ifdef MASS
  double massf = sqrt(PMASS(*p));
#else
  double massf = 1;
#endif


#ifdef VIRTUAL_SITES
#ifndef VIRTUAL_SITES_THERMOSTAT
  if (ifParticleIsVirtual(p))
  {
    for (j=0;j<3;j++)
    p->f.f[j]=0;

    return;
  }
#endif

#ifdef THERMOSTAT_IGNORE_NON_VIRTUAL
  if (!ifParticleIsVirtual(p))
  {
    for (j=0;j<3;j++)
    p->f.f[j]=0;

    return;
  }
#endif
#endif	  

  double velocity[3];
  for (int i = 0; i < 3; i++) {
    velocity[i] = p->m.v[i];
#ifdef ENGINE
    velocity[i] -= p->swim.v_swim*p->r.quatu[i];
#endif
  }

  for ( j = 0 ; j < 3 ; j++) 
  {
#ifdef EXTERNAL_FORCES
    if (!(p->p.ext_flag & COORD_FIXED(j)))
#endif
    {
#ifdef LANGEVIN_PER_PARTICLE  
      
#if defined (FLATNOISE)
      if(p->p.gamma >= 0.) 
      {
        langevin_pref1_temp = -p->p.gamma/time_step;
        
        if(p->p.T >= 0.)
          langevin_pref2_temp = sqrt(24.0*p->p.T*p->p.gamma/time_step);
        else
          langevin_pref2_temp = sqrt(24.0*temperature*p->p.gamma/time_step);

        p->f.f[j] = langevin_pref1_temp*
                       le_frameV(j, velocity, p->r.p)*PMASS(*p) + langevin_pref2_temp*(d_random()-0.5)*massf;
      }
      else 
      {
        if(p->p.T >= 0.)
          langevin_pref2_temp = sqrt(24.0*p->p.T*langevin_gamma/time_step);
        else          
          langevin_pref2_temp = langevin_pref2;

        p->f.f[j] = langevin_pref1*
                  le_frameV(j, velocity, p->r.p)*PMASS(*p) + langevin_pref2_temp*(d_random()-0.5)*massf;
      }
#elif defined (GAUSSRANDOMCUT)
      if(p->p.gamma >= 0.) 
      {
        langevin_pref1_temp = -p->p.gamma/time_step;
        
        if(p->p.T >= 0.)
          langevin_pref2_temp = sqrt(2.0*p->p.T*p->p.gamma/time_step);
        else
          langevin_pref2_temp = sqrt(2.0*temperature*p->p.gamma/time_step);

        p->f.f[j] = langevin_pref1_temp*
                       le_frameV(j, velocity, p->r.p)*PMASS(*p) + langevin_pref2_temp*gaussian_random_cut()*massf;
      }
      else 
      {
        if(p->p.T >= 0.)
          langevin_pref2_temp = sqrt(2.0*p->p.T*langevin_gamma/time_step);
        else          
          langevin_pref2_temp = langevin_pref2;

        p->f.f[j] = langevin_pref1*
                  le_frameV(j, velocity, p->r.p)*PMASS(*p) + langevin_pref2_temp*gaussian_random_cut()*massf;
      }
#elif defined (GAUSSRANDOM)
      if(p->p.gamma >= 0.) 
      {
        langevin_pref1_temp = -p->p.gamma/time_step;
        
        if(p->p.T >= 0.)
          langevin_pref2_temp = sqrt(2.0*p->p.T*p->p.gamma/time_step);
        else
          langevin_pref2_temp = sqrt(2.0*temperature*p->p.gamma/time_step);
        
        p->f.f[j] = langevin_pref1_temp*
                       le_frameV(j, velocity, p->r.p)*PMASS(*p) + langevin_pref2_temp*gaussian_random()*massf;
      }
      else 
      {
        if(p->p.T >= 0.)
          langevin_pref2_temp = sqrt(2.0*p->p.T*langevin_gamma/time_step);
        else          
          langevin_pref2_temp = langevin_pref2;
        
        p->f.f[j] = langevin_pref1*
                  le_frameV(j, velocity, p->r.p)*PMASS(*p) + langevin_pref2_temp*gaussian_random()*massf;
      }
#else
#error No Noise defined
#endif


#else 

/*******************different shapes of noise */
#if defined (FLATNOISE)
      p->f.f[j] = langevin_pref1*le_frameV(j, velocity, p->r.p)
                  * PMASS(*p) + langevin_pref2*(d_random()-0.5)*massf;
#elif defined (GAUSSRANDOMCUT)
      p->f.f[j] = langevin_pref1*le_frameV(j, velocity, p->r.p)
                  * PMASS(*p) + langevin_pref2*gaussian_random_cut()*massf;
#elif defined (GAUSSRANDOM)
      p->f.f[j] = langevin_pref1*le_frameV(j, velocity, p->r.p)
                  * PMASS(*p) + langevin_pref2*gaussian_random()*massf;
#else
#error No Noise defined
#endif
/*******************end different shapes of noise */

#endif
    }
#ifdef EXTERNAL_FORCES
    else p->f.f[j] = 0;
#endif
  }
//  printf("%d: %e %e %e %e %e %e\n",p->p.identity, p->f.f[0],p->f.f[1],p->f.f[2], p->m.v[0],p->m.v[1],p->m.v[2]);
  

  ONEPART_TRACE(if(p->p.identity==check_id) fprintf(stderr,"%d: OPT: LANG f = (%.3e,%.3e,%.3e)\n",this_node,p->f.f[0],p->f.f[1],p->f.f[2]));
  THERMO_TRACE(fprintf(stderr,"%d: Thermo: P %d: force=(%.3e,%.3e,%.3e)\n",this_node,p->p.identity,p->f.f[0],p->f.f[1],p->f.f[2]));
}

#ifdef ROTATION
/** set the particle torques to the friction term, i.e. \f$\tau_i=-\gamma w_i + \xi_i\f$.
    The same friction coefficient \f$\gamma\f$ is used as that for translation.
*/
inline void friction_thermo_langevin_rotation(Particle *p)
{
  extern double langevin_pref2;

  int j;
#ifdef VIRTUAL_SITES
#ifndef VIRTUAL_SITES_THERMOSTAT
  if (ifParticleIsVirtual(p))
  {
    for (j=0;j<3;j++)
    p->f.torque[j]=0;

    return;
  }
#endif

#ifdef THERMOSTAT_IGNORE_NON_VIRTUAL
  if (!ifParticleIsVirtual(p))
  {
    for (j=0;j<3;j++)
    p->f.torque[j]=0;

    return;
  }
#endif
#endif	
  
  for ( j = 0 ; j < 3 ; j++) 
  {
#if defined (FLATNOISE)
#ifdef ROTATIONAL_INERTIA
    p->f.torque[j] = -langevin_gamma*p->m.omega[j] *p->p.rinertia[j] + langevin_pref2*sqrt(p->p.rinertia[j]) * (d_random()-0.5);
#else
    p->f.torque[j] = -langevin_gamma*p->m.omega[j] + langevin_pref2*(d_random()-0.5);
#endif
#elif defined (GAUSSRANDOMCUT)
#ifdef ROTATIONAL_INERTIA
    p->f.torque[j] = -langevin_gamma*p->m.omega[j] *p->p.rinertia[j] + langevin_pref2*sqrt(p->p.rinertia[j]) * gaussian_random_cut();
#else
    p->f.torque[j] = -langevin_gamma*p->m.omega[j] + langevin_pref2*gaussian_random_cut();
#endif
#elif defined (GAUSSRANDOM)
#ifdef ROTATIONAL_INERTIA
    p->f.torque[j] = -langevin_gamma*p->m.omega[j] *p->p.rinertia[j] + langevin_pref2*sqrt(p->p.rinertia[j]) * gaussian_random();
#else
    p->f.torque[j] = -langevin_gamma*p->m.omega[j] + langevin_pref2*gaussian_random();
#endif
#else
#error No Noise defined
#endif
  }

  ONEPART_TRACE(if(p->p.identity==check_id) fprintf(stderr,"%d: OPT: LANG f = (%.3e,%.3e,%.3e)\n",this_node,p->f.f[0],p->f.f[1],p->f.f[2]));
  THERMO_TRACE(fprintf(stderr,"%d: Thermo: P %d: force=(%.3e,%.3e,%.3e)\n",this_node,p->p.identity,p->f.f[0],p->f.f[1],p->f.f[2]));
}
#endif


#endif

