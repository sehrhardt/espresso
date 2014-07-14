import ctypes
import sys
import os.path
import espressomd.System as es
import numpy
import code_info
import h5md

print("""
=======================================================
=                    lj_liquid.py                     =
=======================================================

Program Information:""")
print(code_info.features())

dev="cpu"

# System parameters
#############################################################
# 10 000  Particles
box_l = 10
density = 0.1

# Interaction parameters (repulsive Lennard Jones)
#############################################################
lj_eps   =  1.0
lj_sig   =  1.0
lj_cut   =  1.12246
lj_cap   = 20 

# Integration parameters
#############################################################
es.glob.time_step = 0.01
es.glob.skin      = 0.4
es.thermostat.Thermostat().setLangevin(1.0,1.0)

# warmup integration (with capped LJ potential)
warm_steps   = 100
warm_n_times = 30
# do the warmup until the particles have at least the distance min__dist
min_dist     = 0.9

# integration
int_steps   = 1000
int_n_times = 10


#############################################################
#  Setup System                                             #
#############################################################

# Interaction setup
#############################################################
es.glob.box_l = [box_l,box_l,box_l]
es.nonBondedInter[0,0].lennardJones.setParams(
    epsilon=lj_eps, sigma=lj_sig,
    cutoff=lj_cut, shift="auto")
es.nonBondedInter.setForceCap(lj_cap)

print("LJ-parameters:")
print(es.nonBondedInter[0,0].lennardJones.getParams())

# Particle setup
#############################################################
volume = box_l*box_l*box_l
n_part = int(volume*density)

# H5MD: Create/Read Position dataset
#############################################################
h5_filename="lj_liquid_h5md.h5"
h5_file_already_exists=os.path.isfile("lj_liquid_h5md.h5")
h5=h5md.h5md("lj_liquid_h5md.h5",es)

# Positions
#############################################################
#H5MD: Read positions from h5-file and store them in Espresso
if (h5_file_already_exists): #Check if file already exists -> Keep positions
  lastTimestep=h5.h5_dataset_size("particles/A/position/value")[0]-1
  h5.h5_read_particles.pos(lastTimestep,"A")
  h5.h5_read_particles.image(lastTimestep,"A")
  h5.h5_read_particles.v(lastTimestep,"A")
  h5.h5_read_particles.f(lastTimestep,"A")
  h5.h5_read_particles.type("A")
  h5.h5_read_particles.mass("A")
  h5.h5_read_particles.id("A")
  h5.h5_read_particles.box(lastTimestep,"A")
  h5.h5_read_observable(lastTimestep,"energies","A")
else: #Random Positions
  for i in range(n_part):
    es.part[i].pos=numpy.random.random(3)*es.glob.box_l
    es.part[i].type=i%3
  h5.h5_write_particles.pos(0,"A")
  h5.h5_write_particles.image(0,"A")
  h5.h5_write_particles.v(0,"A")
  h5.h5_write_particles.f(0,"A")
  h5.h5_write_particles.type("A")
  h5.h5_write_particles.mass("A")
  h5.h5_write_particles.id("A")
  h5.h5_write_particles.box(0,"A")
  h5.h5_write_observable(0,[2,3,4],"energies","A")
  

# Else
#############################################################

print "Simulate %d particles in a cubic simulation box " % n_part
print "%f at density %f\n" % (box_l,density)
act_min_dist = es.analyze.mindist()
print "Start with minimal distance %f" % act_min_dist
es.glob.max_num_cells = 2744

#############################################################
#  Warmup Integration                                       #
#############################################################
#open Observable file
obs_file = open("pylj_liquid.obs", "w")
obs_file.write("# Time\tE_tot\tE_kin\tE_pot\n")

if (not h5_file_already_exists): #Check if file already exists -> No warmup
  print "\nStart warmup integration:"
  print "At maximum %d times %d steps" % (warm_n_times, warm_steps)
  print "Stop if minimal distance is larger than %f" % min_dist

  # set LJ cap
  lj_cap = 20
  es.nonBondedInter.setForceCap(lj_cap)
  print(es.nonBondedInter[0,0].lennardJones)

  # Warmup Integration Loop
  i = 0
  while (i < warm_n_times and act_min_dist < min_dist):
    es.integrate(warm_steps)
    # Warmup criterion
    act_min_dist = es.analyze.mindist() 
    print "\rrun %d at time=%f (LJ cap=%f) min dist = %f\r" % (i,es.glob.time,lj_cap,act_min_dist),
    i = i + 1
    #Increase LJ cap
    lj_cap = lj_cap + 10
    es.nonBondedInter.setForceCap(lj_cap)

# Just to see what else we may get from the c code
print "\n\nro variables:"
print "cell_grid     %s" % es.glob.cell_grid
print "cell_size     %s" % es.glob.cell_size 
print "local_box_l    %s" % es.glob.local_box_l 
print "max_cut        %s" % es.glob.max_cut
print "max_part       %s" % es.glob.max_part
print "max_range      %s" % es.glob.max_range 
print "max_skin       %s" % es.glob.max_skin
print "n_nodes        %s" % es.glob.n_nodes
print "n_part         %s" % es.glob.n_part
print "n_part_types   %s" % es.glob.n_part_types 
print "periodicity    %s" % es.glob.periodicity
print "transfer_rate  %s" % es.glob.transfer_rate
print "verlet_reuse   %s" % es.glob.verlet_reuse

# write parameter file
set_file = open("pylj_liquid.set", "w")
set_file.write("box_l %s\ntime_step %s\nskin %s\n" % (box_l, es.glob.time_step, es.glob.skin))

#############################################################
#      Integration                                          #
#############################################################
print "\nStart integration: run %d times %d steps" % (int_n_times, int_steps)

# remove force capping
lj_cap = 0 
es.nonBondedInter.setForceCap(lj_cap)
print(es.nonBondedInter[0,0].lennardJones)

# print initial energies
energies = es.analyze.energy()
print energies

for i in range(0,int_n_times):
  print "run %d at time=%f " % (i,es.glob.time)
  es.integrate(int_steps)
  energies = es.analyze.energy()
  print energies
  obs_file.write('{ time %s } %s\n' % (es.glob.time,energies))
  #H5MD: Write Positions, Forces etc.
  h5.h5_write_particles.pos(i,"A")
  h5.h5_write_particles.image(i,"A")
  h5.h5_write_particles.v(i,"A")
  h5.h5_write_particles.f(i,"A")
  h5.h5_write_particles.box(i,"A")
  h5.h5_write_observable(i,[2,3,4],"energies","A")
#H5MD: Write VMD parameters
h5.h5_write_vmd_parameters("A")
h5.h5_read_vmd_parameters("A")#xxxxxxxxxxxxxxxx

h5.h5_write_vmd_parameters_extra.chain(["A", "B", "C"],"A")
h5.h5_read_vmd_parameters_extra.chain("A")#xxxxxxxxxxxxxxxx

h5.h5_write_vmd_parameters_extra.name(["A", "B", "C"],"A")
h5.h5_read_vmd_parameters_extra.name("A")#xxxxxxxxxxxxxxxx

h5.h5_write_vmd_parameters_extra.resid([1,2,3,4,5],"A")
h5.h5_read_vmd_parameters_extra.resid("A")#xxxxxxxxxxxxxxxx

h5.h5_write_vmd_parameters_extra.resname(["A", "B", "C"],"A")
h5.h5_read_vmd_parameters_extra.resname("A")#xxxxxxxxxxxxxxxx

h5.h5_write_vmd_parameters_extra.segid(["A", "B", "C"],"A")
h5.h5_read_vmd_parameters_extra.segid("A")#xxxxxxxxxxxxxxxx

h5.h5_write_vmd_parameters_extra.type(["A", "B", "C"],"A")
h5.h5_read_vmd_parameters_extra.type("A")#xxxxxxxxxxxxxxxx

h5.h5_write_attributes("particles/A/position/value","Name","Value")
print h5.h5_read_attributes("particles/A/position/value","Name")


# write end configuration
end_file = open("pylj_liquid.end", "w")
end_file.write("{ time %f } \n { box_l %f }\n" % (es.glob.time, box_l) )
end_file.write("{ particles {id pos type} }")
for i in range(n_part):
    end_file.write("%s\n" % es.part[i].pos)
    # id & type not working yet

obs_file.close()
set_file.close()
end_file.close()
es._espressoHandle.die()

# terminate program
print "\n\nFinished"
print "XXXXXXXXXXXX"
print "XXXXXXXXXXXX"
#es.interactions.FeneBond(1)
#es.bondedInter[0].FeneBond.setParams(k=1.0, d_r_max=10.0,r_0=1.0)#xxx
#es.part[0].bonds=[[1,2]]
print "XXXXXXXXXXXX"
print "XXXXXXXXXXXX",es.part[0].bonds
print "XXXXXXXXXXXX"
print es.glob.periodicity
