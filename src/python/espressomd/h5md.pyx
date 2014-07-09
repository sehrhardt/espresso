import h5py
import sys
import numpy as np

class h5md(object):
  def __init__(self,h5_filename,es):  
    self.es=es 
    self.h5_filename=h5_filename           
    self.h5_file=self.h5_open_file(h5_filename,"a")

  ###################################### FILES ###################################### 
  def h5_open_file(self,filename,accesstype):
    h5_file = h5py.File(filename,accesstype)
    return h5_file
 
  ###################################### READ/WRITE ###################################### 
  def h5_write_to_file(self,dataset_name,particlesgroup="atoms",timestep=-1):
    if(timestep==-1): timestep=particlesgroup #Needed because write_to_h5 is overloaded function
    #Position
    if(dataset_name=="pos"):
      try:
        self.particles_position_step_dataset=self.h5_create_particles_position_step_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_position_step_dataset=self.h5_file["particles/"+particlesgroup+"/position/step"]    
      try:
        self.particles_position_time_dataset=self.h5_create_particles_position_time_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_position_time_dataset=self.h5_file["particles/"+particlesgroup+"/position/time"]     
      try:
        self.particles_position_value_dataset=self.h5_create_particles_position_value_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_position_value_dataset=self.h5_file["particles/"+particlesgroup+"/position/value"]         
      self.h5_write_particles_position_step_dataset(self.particles_position_step_dataset,timestep)
      self.h5_write_particles_position_time_dataset(self.particles_position_time_dataset,timestep)
      self.h5_write_particles_position_value_dataset(self.particles_position_value_dataset,timestep)
      
    #Image
    if(dataset_name=="image"):
      try:
        self.particles_image_step_dataset=self.h5_create_particles_image_step_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_image_step_dataset=self.h5_file["particles/"+particlesgroup+"/image/step"]    
      try:
        self.particles_image_time_dataset=self.h5_create_particles_image_time_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_image_time_dataset=self.h5_file["particles/"+particlesgroup+"/image/time"]  
      try:
        self.particles_image_value_dataset=self.h5_create_particles_image_value_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_image_value_dataset=self.h5_file["particles/"+particlesgroup+"/image/value"]      
      self.h5_write_particles_image_step_dataset(self.particles_image_step_dataset,timestep)
      self.h5_write_particles_image_time_dataset(self.particles_image_time_dataset,timestep)
      self.h5_write_particles_image_value_dataset(self.particles_image_value_dataset,timestep)
      
    #Velocity
    if(dataset_name=="v"):
      try:
        self.particles_velocity_step_dataset=self.h5_create_particles_velocity_step_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_velocity_step_dataset=self.h5_file["particles/"+particlesgroup+"/velocity/step"] 
      try:
        self.particles_velocity_time_dataset=self.h5_create_particles_velocity_time_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_velocity_time_dataset=self.h5_file["particles/"+particlesgroup+"/velocity/time"]  
      try:
        self.particles_velocity_value_dataset=self.h5_create_particles_velocity_value_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_velocity_value_dataset=self.h5_file["particles/"+particlesgroup+"/velocity/value"]          
      self.h5_write_particles_velocity_step_dataset(self.particles_velocity_step_dataset,timestep)
      self.h5_write_particles_velocity_time_dataset(self.particles_velocity_time_dataset,timestep)
      self.h5_write_particles_velocity_value_dataset(self.particles_velocity_value_dataset,timestep)
      
    #Force
    if(dataset_name=="f"):
      try:
        self.particles_force_step_dataset=self.h5_create_particles_force_step_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_force_step_dataset=self.h5_file["particles/"+particlesgroup+"/force/step"]      
      try:
        self.particles_force_time_dataset=self.h5_create_particles_force_time_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_force_time_dataset=self.h5_file["particles/"+particlesgroup+"/force/time"]    
      try:
        self.particles_force_value_dataset=self.h5_create_particles_force_value_dataset(self.h5_file,particlesgroup)
      except:
        self.particles_force_value_dataset=self.h5_file["particles/"+particlesgroup+"/force/value"]     
      self.h5_write_particles_force_step_dataset(self.particles_force_step_dataset,timestep)
      self.h5_write_particles_force_time_dataset(self.particles_force_time_dataset,timestep)
      self.h5_write_particles_force_value_dataset(self.particles_force_value_dataset,timestep)
      
    #Species
    if(dataset_name=="type"):
      try:
        self.particles_species_dataset=self.h5_create_particles_species_dataset(self.h5_file,particlesgroup)
      except:
        pass
      self.h5_write_particles_species_dataset(self.particles_species_dataset)
      
    #ID
    if(dataset_name=="id"):
      try:
        self.particles_id_dataset=self.h5_create_particles_id_dataset(self.h5_file,particlesgroup)
      except:
        pass
      self.h5_write_particles_id_dataset(self.particles_id_dataset)
      
    #Mass
    if(dataset_name=="mass"):
      try:
        self.particles_mass_dataset=self.h5_create_particles_mass_dataset(self.h5_file,particlesgroup)
      except:
        pass
      self.h5_write_particles_mass_dataset(self.particles_mass_dataset)
    
  def h5_read_from_file(self,dataset_name,particlesgroup="atoms",timestep=-1):
    if(timestep==-1): timestep=particlesgroup #Needed because write_to_h5 is overloaded function
    #Position
    if(dataset_name=="pos"):
      try:
        self.particles_position_step_dataset=self.h5_read_particles_position_step_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No position/step dataset in h5-file available"
        sys.exit()
      try:
        self.particles_position_time_dataset=self.h5_read_particles_position_time_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No position/time dataset in h5-file available"
        sys.exit()
      try:
        self.particles_position_value_dataset=self.h5_read_particles_position_value_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No position/value dataset in h5-file available"
        sys.exit()
      self.es.glob.time = self.particles_position_time_dataset[timestep]
      for i in range(self.particles_position_value_dataset.shape[1]):
        self.es.part[i].pos = self.particles_position_value_dataset[timestep,i]
        
    #Image
    if(dataset_name=="image"):
      try:
        self.particles_image_step_dataset=self.h5_read_particles_image_step_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No image/step dataset in h5-file available"
      try:
        self.particles_image_time_dataset=self.h5_read_particles_image_time_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No image/time dataset in h5-file available"
      try:
        self.particles_image_value_dataset=self.h5_read_particles_image_value_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No image/value dataset in h5-file available"
        sys.exit()
      self.es.glob.time = self.particles_image_time_dataset[timestep]
      for i in range(self.particles_image_value_dataset.shape[1]):
        self.es.part[i].pos = self.particles_image_value_dataset[timestep,i]
        
    #Velocity
    if(dataset_name=="v"):
      try:
        self.particles_velocity_step_dataset=self.h5_read_particles_velocity_step_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No velocity/step dataset in h5-file available"
        sys.exit()
      try:
        self.particles_velocity_time_dataset=self.h5_read_particles_velocity_time_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No velocity/time dataset in h5-file available"
        sys.exit()
      try:
        self.particles_velocity_value_dataset=self.h5_read_particles_velocity_value_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No velocity/value dataset in h5-file available"
        sys.exit()
      self.es.glob.time = self.particles_velocity_time_dataset[timestep]
      for i in range(self.particles_velocity_value_dataset.shape[1]):
        self.es.part[i].v = self.particles_velocity_value_dataset[timestep,i]
        
    #Force
    if(dataset_name=="f"):
      try:
        self.particles_force_step_dataset=self.h5_read_particles_force_step_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No force/step dataset in h5-file available"
        sys.exit()
      try:
        self.particles_force_time_dataset=self.h5_read_particles_force_time_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No force/time dataset in h5-file available"
        sys.exit()
      try:
        self.particles_force_value_dataset=self.h5_read_particles_force_value_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No force/value dataset in h5-file available"
        sys.exit()
      self.es.glob.time = self.particles_force_time_dataset[timestep]
      for i in range(self.particles_force_value_dataset.shape[1]):
        self.es.part[i].f = self.particles_force_value_dataset[timestep,i]
        
    #Species
    if(dataset_name=="type"):
      try:
        self.particles_species_dataset=self.h5_read_particles_species_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No species dataset in h5-file available"
        sys.exit()
      for i in range(self.particles_species_dataset.shape[0]):
        self.es.part[i].type = int(self.particles_species_dataset[i]) 
        
    #ID
    if(dataset_name=="id"):
      try:
        self.particles_id_dataset=self.h5_read_particles_id_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No id dataset in h5-file available"
        sys.exit()
      for i in range(self.particles_id_dataset.shape[0]):
        self.es.part[i].id = int(self.particles_id_dataset[i])
        
    #Mass
    if(dataset_name=="mass"):
      try:
        self.particles_mass_dataset=self.h5_read_particles_mass_dataset(self.h5_file,particlesgroup)
      except:
        print "Error: No mass dataset in h5-file available"
        sys.exit()
      for i in range(self.particles_mass_dataset.shape[0]):
        self.es.part[i].mass = int(self.particles_mass_dataset[i]) 
  
  ###################################### Observables ###################################### 
  def h5_write_observable(self,observablesgroup,observablename,value,timestep):
    try:
      self.observables_step_dataset=self.h5_create_observable_step_dataset(self.h5_file,observablesgroup,observablename)
    except:
      self.observables_step_dataset=self.h5_file['observables/'+observablesgroup+'/'+observablename+'/step'] 
    try:
      self.observables_time_dataset=self.h5_create_observable_time_dataset(self.h5_file,observablesgroup,observablename)
    except:
      self.observables_time_dataset=self.h5_file['observables/'+observablesgroup+'/'+observablename+'/time'] 
    try:
      self.observables_value_dataset=self.h5_create_observable_value_dataset(self.h5_file,observablesgroup,observablename)
    except:
      self.observables_value_dataset=self.h5_file['observables/'+observablesgroup+'/'+observablename+'/value'] 
    self.h5_write_observable_step_dataset(self.observables_step_dataset,timestep)
    self.h5_write_observable_time_dataset(self.observables_time_dataset,timestep)
    self.h5_write_observable_value_dataset(self.observables_value_dataset,value,timestep)
          
        
  ###################################### VMD ###################################### 
  def h5_write_vmd_parameters(self):
    try:
      self.parameters_vmd_atomicnumber=self.h5_create_parameters_vmd_atomicnumber_dataset(self.h5_file)
    except:
      self.parameters_vmd_atomicnumber=self.h5_file['parameters/vmd_structure/atomicnumber']   
    try:
      self.parameters_vmd_indexOfSpecies=self.h5_create_parameters_vmd_indexOfSpecies_dataset(self.h5_file)
    except:
      self.parameters_vmd_indexOfSpecies=self.h5_file['parameters/vmd_structure/indexOfSpecies']   

    number_of_species=0
    n_part=self.es.glob.n_part
    for i in range(0,n_part):
      if(self.es.part[i].type>number_of_species): number_of_species=self.es.part[i].type

    self.parameters_vmd_atomicnumber.resize((number_of_species+1,1))
    self.parameters_vmd_indexOfSpecies.resize((number_of_species+1,1))
    species_array=np.zeros(number_of_species)
    for i in range(0,number_of_species):
      species_array[i]=i
    self.h5_write_parameters_vmd_atomicnumber_dataset(self.parameters_vmd_atomicnumber,species_array)
    self.h5_write_parameters_vmd_indexOfSpecies_dataset(self.parameters_vmd_indexOfSpecies,species_array)
         
  ###################################### PARTICLES ###################################### 
  #Positions/value
  def h5_create_particles_position_value_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/position/value",(1,1,3), maxshape=(None,None,3), dtype='f8')
    return dset
        
  def h5_write_particles_position_value_dataset(self,dataset,timestep):
    n_part=self.es.glob.n_part
    if(dataset.len()<=timestep+1): 
      dataset.resize((timestep+1,n_part,3))
    for i in range(0,n_part):
      dataset[timestep,i]=self.es.part[i].pos
      
  def h5_read_particles_position_value_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/position']
    return group['value']

  #Positions/time   
  def h5_create_particles_position_time_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/position/time",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_particles_position_time_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=self.es.glob.time

  def h5_read_particles_position_time_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/position']
    return group['time']    
      
  #Positions/step
  def h5_create_particles_position_step_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/position/step",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_position_step_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=timestep
      
  def h5_read_particles_position_step_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/position']
    return group['step']
  
  
  #Image/value
  def h5_create_particles_image_value_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/image/value",(1,1,3), maxshape=(None,None,3), dtype='f8')
    return dset
        
  def h5_write_particles_image_value_dataset(self,dataset,timestep):
    n_part=self.es.glob.n_part
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,n_part,3))
    for i in range(0,n_part):
      dataset[timestep,i]=self.es.part[i].pos
      
  def h5_read_particles_image_value_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/image']
    return group['value']

  #Image/time  
  def h5_create_particles_image_time_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/image/time",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_particles_image_time_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=self.es.glob.time

  def h5_read_particles_image_time_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/image']
    return group['time']    
      
  #Image/step 
  def h5_create_particles_image_step_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/image/step",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_image_step_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=timestep
      
  def h5_read_particles_image_step_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/image']
    return group['step']
        
        
  #Velocity/value
  def h5_create_particles_velocity_value_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/velocity/value",(1,1,3), maxshape=(None,None,3), dtype='f8')
    return dset
        
  def h5_write_particles_velocity_value_dataset(self,dataset,timestep):
    n_part=self.es.glob.n_part
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,n_part,3))
    for i in range(0,n_part):
      dataset[timestep,i]=self.es.part[i].v
      
  def h5_read_particles_velocity_value_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/velocity']
    return group['value']
        
  #Velocity/time  
  def h5_create_particles_velocity_time_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/velocity/time",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_particles_velocity_time_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=self.es.glob.time

  def h5_read_particles_velocity_time_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/velocity']
    return group['time']    
      
      
  #Velocity/step
  def h5_create_particles_velocity_step_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/velocity/step",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_velocity_step_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=timestep

  def h5_read_particles_velocity_step_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/velocity']
    return group['step']    


  #Force/value
  def h5_create_particles_force_value_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/force/value",(1,1,3), maxshape=(None,None,3), dtype='f8')
    return dset
        
  def h5_write_particles_force_value_dataset(self,dataset,timestep):
    n_part=self.es.glob.n_part
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,n_part,3))
    for i in range(0,n_part):
      dataset[timestep,i]=self.es.part[i].f
      
  def h5_read_particles_force_value_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/force']
    return group['value']
        
  #Force/time   
  def h5_create_particles_force_time_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/force/time",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_particles_force_time_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=self.es.glob.time

  def h5_read_particles_force_time_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/force']
    return group['time']    
      
  #Force/step
  def h5_create_particles_force_step_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/force/step",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_force_step_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=timestep

  def h5_read_particles_force_step_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/force']
    return group['step']  
                
  #Species    
  def h5_create_particles_species_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/species/value",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_species_dataset(self,dataset):
    n_part=self.es.glob.n_part
    if(dataset.len()<=n_part+1):
      dataset.resize((n_part,1))
    for i in range(0,n_part):
      dataset[i]=self.es.part[i].type

  def h5_read_particles_species_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/species']
    return group['value']

  #ID    
  def h5_create_particles_id_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/id/value",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_id_dataset(self,dataset):
    n_part=self.es.glob.n_part
    if(dataset.len()<=n_part+1):
      dataset.resize((n_part,1))
    for i in range(0,n_part):
      dataset[i]=self.es.part[i].id

  def h5_read_particles_id_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/id']
    return group['value']

  #Mass    
  def h5_create_particles_mass_dataset(self,h5_file,particlesgroup):
    dset = h5_file.create_dataset("particles/"+particlesgroup+"/mass/value",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_particles_mass_dataset(self,dataset):
    n_part=self.es.glob.n_part
    if(dataset.len()<=n_part+1):
      dataset.resize((n_part,1))
    for i in range(0,n_part):
      dataset[i]=self.es.part[i].mass

  def h5_read_particles_mass_dataset(self,filename,particlesgroup):
    group=filename['particles/'+particlesgroup+'/mass']
    return group['value']  
  
  ###################################### PARTICLES/BOX ###################################### 
  
  
  
  ###################################### VMD-STRUCTURE ###################################### 
  #IndexOfSpecies    
  def h5_create_parameters_vmd_indexOfSpecies_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/indexOfSpecies",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_parameters_vmd_indexOfSpecies_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]
      
  def h5_read_parameters_vmd_indexOfSpecies_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['indexOfSpecies']
  
  #Atomic number
  def h5_create_parameters_vmd_atomicnumber_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/atomicnumber",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_parameters_vmd_atomicnumber_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]

  def h5_read_parameters_vmd_atomicnumber_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['atomicnumber']

  #Bond from
  def h5_create_parameters_vmd_bond_from_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/bond_from",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_parameters_vmd_bond_from_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]

  def h5_read_parameters_vmd_bond_from_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['bond_from']

  #Bond to    
  def h5_create_parameters_vmd_bond_to_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/bond_to",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_parameters_vmd_bond_to_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]  
      
  def h5_read_parameters_vmd_bond_to_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['bond_to']
        
  #Chain
  def h5_create_parameters_vmd_chain_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/chain",(1,1), maxshape=(None,1), dtype='S10')
    return dset
        
  def h5_write_parameters_vmd_chain_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]
      
  def h5_read_parameters_vmd_chain_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['chain']    
      
  #Charge
  def h5_create_parameters_vmd_charge_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/charge",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_parameters_vmd_charge_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    

  def h5_read_parameters_vmd_charge_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['charge']    
      
  #Mass
  def h5_create_parameters_vmd_mass_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/mass",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_parameters_vmd_mass_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    
      
  def h5_read_parameters_vmd_mass_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['mass']    
      
  #Name
  def h5_create_parameters_vmd_name_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/name",(1,1), maxshape=(None,1), dtype='S10')
    return dset
        
  def h5_write_parameters_vmd_name_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    
      
  def h5_read_parameters_vmd_name_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['name']    
      
  #Number segid    
  def h5_create_parameters_vmd_indexOfSegid_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/indexOfSegid",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_parameters_vmd_indexOfSegid_dataset(self,dataset,es,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]      
      
  def h5_read_parameters_vmd_indexOfSegid_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['indexOfSegid']    
      
  #Radius
  def h5_create_parameters_vmd_radius_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/radius",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def h5_write_parameters_vmd_radius_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    
      
  def h5_read_parameters_vmd_radius_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['radius']    
      
  #Resid    
  def h5_create_parameters_vmd_resid_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/resid",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def h5_write_parameters_vmd_resid_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]      

  def h5_read_parameters_vmd_resid_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['resid']    

  #Resname
  def h5_create_parameters_vmd_resname_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/resname",(1,1), maxshape=(None,1), dtype='S10')
    return dset
        
  def h5_write_parameters_vmd_resname_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]

  def h5_read_parameters_vmd_resname_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['resname']

  #Segid    
  def h5_create_parameters_vmd_segid_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/segid",(1,1), maxshape=(None,1), dtype='S10')
    return dset
        
  def h5_write_parameters_vmd_segid_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]  

  def h5_read_parameters_vmd_segid_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['segid']
        
  #Type
  def h5_create_parameters_vmd_type_dataset(self,h5_file):
    dset = h5_file.create_dataset("parameters/vmd_structure/type",(1,1), maxshape=(None,1), dtype='S10')
    return dset
        
  def h5_write_parameters_vmd_type_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]

  def h5_read_parameters_vmd_type_dataset(self,filename):
    group=filename['parameters/vmd_structure']
    return group['type']

  ###################################### OBSERVABLES ###################################### 
  #Observable/value
  def h5_create_observable_value_dataset(self,h5_file,observablesgroup,observablename):
    dset = h5_file.create_dataset("observables/"+observablesgroup+"/"+observablename+"/value",(1,1), maxshape=(None,None), dtype='f8')
    return dset
        
  def h5_write_observable_value_dataset(self,dataset,value,timestep):
    try:
      value_length=len(value)
    except:
      value_length=1 
    dataset.resize((timestep+1,value_length))
    for i in range(0,value_length):
      dataset[timestep,i]=value[i]
      
  def h5_read_observable_value_dataset(self,filename,observablesgroup,observablename):
    group=filename['observables/'+observablesgroup+'/'+observablename]
    return group['value']

  #Observable/time   
  def h5_create_observable_time_dataset(self,h5_file,observablesgroup,observablename):
    dset = h5_file.create_dataset("observables/"+observablesgroup+"/"+observablename+"/time",(1,1), maxshape=(None,None), dtype='f8')
    return dset
        
  def h5_write_observable_time_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=self.es.glob.time

  def h5_read_observable_time_dataset(self,filename,observablesgroup,observablename):
    group=filename['observables/'+observablesgroup+'/'+observablename]
    return group['time']    
      
  #Observable/step
  def h5_create_observable_step_dataset(self,h5_file,observablesgroup,observablename):
    dset = h5_file.create_dataset("observables/"+observablesgroup+"/"+observablename+"/step",(1,1), maxshape=(None,None), dtype='int64')
    return dset
        
  def h5_write_observable_step_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=timestep
      
  def h5_read_observable_step_dataset(self,filename,observablesgroup,observablename):
    group=filename['observables/'+observablesgroup+'/'+observablename]
    return group['step']