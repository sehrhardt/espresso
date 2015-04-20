import h5py
import sys
import numpy as np
include "myconfig.pxi"

class h5md(object):
  def __init__(self,filename,system):  
    self.system=system 
    self.filename=filename         
    self.file=self.OpenFile(filename,"a")
    self.h5_write_particles=self.h5_write_particles(self)
    self.h5_read_particles=self.h5_read_particles(self)
    self.h5_write_vmd_parameters_extra=self.h5_write_vmd_parameters_extra(self)
    self.h5_read_vmd_parameters_extra=self.h5_read_vmd_parameters_extra(self)
    
  def OpenFile(self,filename,accesstype):
    file = h5py.File(filename,accesstype)
    return file
  
  def DatasetSize(self,dataset):
    return self.file[dataset].shape
  
  def WriteAttributes(self,dataset,name,value):
    self.file[dataset].attrs[name] = value
  
  def ReadAttributes(self,dataset,name):
    return self.file[dataset].attrs[name]
  
  def CreateDataset(self,file,dataset,shape,Maxshape,Dtype):
    dset = file.create_dataset(dataset,shape, maxshape=Maxshape, dtype=Dtype)
    return dset
  
  def ReadDataset(self,file,dataset_group,dataset_name):
    group=file[dataset_group]
    return group[dataset_name]
        
  def WriteValue(self,timestep,value,groupname,datasetname,dataset_write_function,file,datasetpath,shape,Maxshape,Dtype,case):
      try:
        self.datasetname=self.CreateDataset(self.file,datasetpath,shape,Maxshape,Dtype)
      except:
        self.datasetname=self.file[datasetpath]   
      if case==0: 
        dataset_write_function(self.datasetname) 
      if case==1: 
        dataset_write_function(self.datasetname,timestep)
      if case==2: 
        dataset_write_function(self.datasetname,timestep,value)        
        
  ########################################################### PARTICLES GROUP #########################################################  
 
  class h5_write_particles(object):
    def __init__(self,self_h5md_class):
      self.self_h5md_class=self_h5md_class          
       
    #Position
    def pos(self,timestep,groupname="atoms"):
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_position_step_dataset",self.write_particles_position_step_dataset,self.self_h5md_class.file,"particles/"+groupname+"/position/step",(1,1),(None,1),'int64',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_position_time_dataset",self.write_particles_position_time_dataset,self.self_h5md_class.file,"particles/"+groupname+"/position/time",(1,1),(None,1),'f8',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_position_value_dataset",self.write_particles_position_value_dataset,self.self_h5md_class.file,"particles/"+groupname+"/position/value",(1,1,3),(None,None,3),'f8',1)             
    def write_particles_position_step_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=timestep            
    def write_particles_position_time_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=self.self_h5md_class.system.time
    def write_particles_position_value_dataset(self,dataset,timestep):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=timestep+1): 
        dataset.resize((timestep+1,n_part,3))
      for i in range(0,n_part):
        dataset[timestep,i]=self.self_h5md_class.system.part[i].pos       
    #Image
    def image(self,timestep,groupname="atoms"):
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_image_step_dataset",self.write_particles_image_step_dataset,self.self_h5md_class.file,"particles/"+groupname+"/image/step",(1,1),(None,1),'int64',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_image_time_dataset",self.write_particles_image_time_dataset,self.self_h5md_class.file,"particles/"+groupname+"/image/time",(1,1),(None,1),'f8',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_image_value_dataset",self.write_particles_image_value_dataset,self.self_h5md_class.file,"particles/"+groupname+"/image/value",(1,1,3),(None,None,3),'f8',1)       
    def write_particles_image_step_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=timestep  
    def write_particles_image_time_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=self.self_h5md_class.system.time 
    def write_particles_image_value_dataset(self,dataset,timestep):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,n_part,3))
      for i in range(0,n_part):
        dataset[timestep,i]=self.self_h5md_class.system.part[i].pos            
    #Velocity
    def v(self,timestep,groupname="atoms"):
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_velocity_step_dataset",self.write_particles_velocity_step_dataset,self.self_h5md_class.file,"particles/"+groupname+"/velocity/step",(1,1),(None,1),'int64',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_velocity_time_dataset",self.write_particles_velocity_time_dataset,self.self_h5md_class.file,"particles/"+groupname+"/velocity/time",(1,1),(None,1),'f8',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_velocity_value_dataset",self.write_particles_velocity_value_dataset,self.self_h5md_class.file,"particles/"+groupname+"/velocity/value",(1,1,3),(None,None,3),'f8',1)        
    def write_particles_velocity_step_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=timestep  
    def write_particles_velocity_time_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=self.self_h5md_class.system.time      
    def write_particles_velocity_value_dataset(self,dataset,timestep):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,n_part,3))
      for i in range(0,n_part):
        dataset[timestep,i]=self.self_h5md_class.system.part[i].v    
    #Force
    def f(self,timestep,groupname="atoms"):
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_force_step_dataset",self.write_particles_force_step_dataset,self.self_h5md_class.file,"particles/"+groupname+"/force/step",(1,1),(None,1),'int64',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_force_time_dataset",self.write_particles_force_time_dataset,self.self_h5md_class.file,"particles/"+groupname+"/force/time",(1,1),(None,1),'f8',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_force_value_dataset",self.write_particles_force_value_dataset,self.self_h5md_class.file,"particles/"+groupname+"/force/value",(1,1,3),(None,None,3),'f8',1)
    def write_particles_force_step_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=timestep 
    def write_particles_force_time_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=self.self_h5md_class.system.time      
    def write_particles_force_value_dataset(self,dataset,timestep):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,n_part,3))
      for i in range(0,n_part):
        dataset[timestep,i]=self.self_h5md_class.system.part[i].f    
    #Species
    def type(self,groupname="atoms"):
      self.self_h5md_class.WriteValue(-1,-1,groupname,"particles_species_dataset",self.write_particles_species_dataset,self.self_h5md_class.file,"particles/"+groupname+"/species/value",(1,1),(None,1),'int64',0)     
    def write_particles_species_dataset(self,dataset):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=n_part+1):
        dataset.resize((n_part,1))
      for i in range(0,n_part):
        dataset[i]=self.self_h5md_class.system.part[i].type        
    #ID
    def id(self,groupname="atoms"):
      self.self_h5md_class.WriteValue(-1,-1,groupname,"particles_id_dataset",self.write_particles_id_dataset,self.self_h5md_class.file,"particles/"+groupname+"/id/value",(1,1),(None,1),'int64',0)
    def write_particles_id_dataset(self,dataset):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=n_part+1):
        dataset.resize((n_part,1))
      for i in range(0,n_part):
        dataset[i]=self.self_h5md_class.system.part[i].id        
    #Mass
    def mass(self,groupname="atoms"):
      self.self_h5md_class.WriteValue(-1,-1,groupname,"particles_mass_dataset",self.write_particles_mass_dataset,self.self_h5md_class.file,"particles/"+groupname+"/mass/value",(1,1),(None,1),'int64',0)         
    def write_particles_mass_dataset(self,dataset):
      n_part=self.self_h5md_class.system.n_part
      if(dataset.len()<=n_part+1):
        dataset.resize((n_part,1))
      IF MASS == 1:
        for i in range(0,n_part):
          dataset[i]=self.self_h5md_class.system.part[i].mass
      ELSE: 
        print "ERROR: Feature MASS not activated"
        sys.exit()         
    #Box
    def box(self,timestep=0,groupname="atoms"):
      self.self_h5md_class.WriteValue(-1,-1,groupname,"particles_box_dimension_dataset",self.write_particles_box_dimension_dataset,self.self_h5md_class.file,"particles/"+groupname+"/box/dimension",(1,1),(None,1),'int64',0)         
      self.self_h5md_class.WriteValue(-1,-1,groupname,"particles_box_boundary_dataset",self.write_particles_box_boundary_dataset,self.self_h5md_class.file,"particles/"+groupname+"/box/boundary",(3,1),(3,1),'S30',0)         
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_box_edges_step_dataset",self.write_particles_box_edges_step_dataset,self.self_h5md_class.file,"particles/"+groupname+"/box_edges/step",(1,1),(None,1),'int64',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_box_edges_time_dataset",self.write_particles_box_edges_time_dataset,self.self_h5md_class.file,"particles/"+groupname+"/box_edges/time",(1,1),(None,1),'f8',1)
      self.self_h5md_class.WriteValue(timestep,-1,groupname,"particles_box_edges_value_dataset",self.write_particles_box_edges_value_dataset,self.self_h5md_class.file,"particles/"+groupname+"/box_edges/value",(1,1,3),(None,None,3),'f8',1)
    def write_particles_box_dimension_dataset(self,dataset):
      dataset[0]=3
    def write_particles_box_boundary_dataset(self,dataset):
      if(self.self_h5md_class.system.periodicity[0]==0):
        dataset[0]="none"
      else:
        dataset[0]="periodic"
      if(self.self_h5md_class.system.periodicity[1]==0):
        dataset[1]="none"
      else:
        dataset[1]="periodic"
      if(self.self_h5md_class.system.periodicity[2]==0):
        dataset[2]="none"
      else:
        dataset[2]="periodic"
    def write_particles_box_edges_step_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=timestep
    def write_particles_box_edges_time_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1):
        dataset.resize((timestep+1,1))
      dataset[timestep]=self.self_h5md_class.system.time  
    def write_particles_box_edges_value_dataset(self,dataset,timestep):
      if(dataset.len()<=timestep+1): 
        dataset.resize((timestep+1,3,3))
      #TODO
      dataset[timestep,0,0]=self.self_h5md_class.system.box_l[0]
      dataset[timestep,1,1]=self.self_h5md_class.system.box_l[1]
      dataset[timestep,2,2]=self.self_h5md_class.system.box_l[2]  
      
  #READ CLASS   
  class h5_read_particles(object):
    def __init__(self,self_h5md_class):
      self.self_h5md_class=self_h5md_class
     
    #Position
    def pos(self,timestep,groupname="atoms"):
      try:
        self.self_h5md_class.particles_position_step_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/position','step')
        self.self_h5md_class.particles_position_time_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/position','time')
        self.self_h5md_class.particles_position_value_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/position','value')
      except:
        print "Error: No particles/"+groupname+"/position/value,time,step dataset in h5-file available"
        sys.exit()
      #Write positions and time in Espresso
      self.self_h5md_class.system.time = self.self_h5md_class.particles_position_time_dataset[timestep]
      for i in range(self.self_h5md_class.particles_position_value_dataset.shape[1]):
        self.self_h5md_class.system.part[i].pos = self.self_h5md_class.particles_position_value_dataset[timestep,i]                      
    #Image
    def image(self,timestep,groupname="atoms"):
      try:
        self.self_h5md_class.particles_image_step_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/image','step')
        self.self_h5md_class.particles_image_time_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/image','time')
        self.self_h5md_class.particles_image_value_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/image','value')
      except:
        print "Error: No particles/"+groupname+"/image/value,time,step dataset in h5-file available"
        sys.exit()
      #Write image and time in Espresso
      self.self_h5md_class.system.time = self.self_h5md_class.particles_image_time_dataset[timestep]
      for i in range(self.self_h5md_class.particles_image_value_dataset.shape[1]):
        self.self_h5md_class.system.part[i].pos = self.self_h5md_class.particles_image_value_dataset[timestep,i]                
    #Velocity
    def v(self,timestep,groupname="atoms"):
      try:
        self.self_h5md_class.particles_velocity_step_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/velocity','step')
        self.self_h5md_class.particles_velocity_time_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/velocity','time')
        self.self_h5md_class.particles_velocity_value_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/velocity','value')
      except:
        print "Error: No particles/"+groupname+"/velocity/value,time,step dataset in h5-file available"
        sys.exit()
      #Write velocity and time in Espresso
      self.self_h5md_class.system.time = self.self_h5md_class.particles_velocity_time_dataset[timestep]
      for i in range(self.self_h5md_class.particles_velocity_value_dataset.shape[1]):
        self.self_h5md_class.system.part[i].v = self.self_h5md_class.particles_velocity_value_dataset[timestep,i]                
    #Force
    def f(self,timestep,groupname="atoms"):
      try:
        self.self_h5md_class.particles_force_step_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/force','step')
        self.self_h5md_class.particles_force_time_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/force','time')
        self.self_h5md_class.particles_force_value_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/force','value')
      except:
        print "Error: No particles/"+groupname+"/force/value,time,step dataset in h5-file available"
        sys.exit()
      #Write force and time in Espresso
      self.self_h5md_class.system.time = self.self_h5md_class.particles_force_time_dataset[timestep]
      for i in range(self.self_h5md_class.particles_force_value_dataset.shape[1]):
        self.self_h5md_class.system.part[i].f = self.self_h5md_class.particles_force_value_dataset[timestep,i]               
    #Species
    def type(self,groupname="atoms"):
      try:
        self.self_h5md_class.particles_species_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/species','value')
      except:
        print "Error: No particles/"+groupname+"/species/value dataset in h5-file available"
        sys.exit()
      #Write type in Espresso
      for i in range(self.self_h5md_class.particles_species_dataset.shape[0]):
        self.self_h5md_class.system.part[i].type = int(self.self_h5md_class.particles_species_dataset[i])                
    #ID
    def id(self,groupname="atoms"):
      try:
        self.self_h5md_class.particles_id_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/id','value')
      except:
        print "Error: No particles/"+groupname+"/id/value dataset in h5-file available"
        sys.exit()
      #Write ID in Espresso
      for i in range(self.self_h5md_class.particles_id_dataset.shape[0]):
        self.self_h5md_class.system.part[i].id = int(self.self_h5md_class.particles_id_dataset[i])             
    #Mass
    def mass(self,groupname="atoms"):
      try:
        self.self_h5md_class.particles_mass_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/mass','value')
      except:
        print "Error: No particles/"+groupname+"/mass/value dataset in h5-file available"
        sys.exit()
      #Write mass in Espresso
      for i in range(self.self_h5md_class.particles_mass_dataset.shape[0]):
        self.self_h5md_class.system.part[i].mass = int(self.self_h5md_class.particles_mass_dataset[i])           
    #Box
    def box(self,timestep=0,groupname="atoms"):
      try:
        self.self_h5md_class.particles_box_dimension_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/box','dimension')
        self.self_h5md_class.particles_box_boundary_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/box','boundary')
      except:
        print "Error: No particles/"+groupname+"/box/boundary,dimension dataset in h5-file available"
        sys.exit()
        
      if(self.self_h5md_class.particles_box_boundary_dataset[0]=="none"):
        self.self_h5md_class.system.periodicity[0]=0
      else:
        self.self_h5md_class.system.periodicity[0]=1
      if(self.self_h5md_class.particles_box_boundary_dataset[0]=="none"):
        self.self_h5md_class.system.periodicity[1]=0
      else:
        self.self_h5md_class.system.periodicity[1]=1
      if(self.self_h5md_class.particles_box_boundary_dataset[0]=="none"):
        self.self_h5md_class.system.periodicity[2]=0
      else:
        self.self_h5md_class.system.periodicity[2]=1
             
      try:
        self.self_h5md_class.particles_box_edges_step_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/box/edges','step')
        self.self_h5md_class.particles_box_edges_time_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/box/edges','time')
        self.self_h5md_class.particles_box_edges_value_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'particles/'+groupname+'/box/edges','value')
      except:
        print "Error: No particles/"+groupname+"/box/edges/value,time,step dataset in h5-file available"
        sys.exit()
        
      #Write velocity and time in Espresso
      self.self_h5md_class.system.time = self.self_h5md_class.particles_box_edges_time_dataset[timestep]
      #TODO
      self.self_h5md_class.system.box_l[0] = self.self_h5md_class.particles_box_edges_value_dataset[timestep,0,0]      
      self.self_h5md_class.system.box_l[1] = self.self_h5md_class.particles_box_edges_value_dataset[timestep,1,1]      
      self.self_h5md_class.system.box_l[2] = self.self_h5md_class.particles_box_edges_value_dataset[timestep,2,2]  
  
  
  ####################################################### OBSERVABLES GROUP ########################################################### 
 
  def h5_write_observable(self,timestep,value,observablename,groupname="observable"):
    self.WriteValue(timestep,value,groupname,"observables_step_dataset",self.write_observable_step_dataset,self.file,"observables/"+groupname+"/"+observablename+"/step",(1,1),(None,None),'int64',1)
    self.WriteValue(timestep,value,groupname,"observables_time_dataset",self.write_observable_time_dataset,self.file,"observables/"+groupname+"/"+observablename+"/time",(1,1),(None,None),'f8',1)
    self.WriteValue(timestep,value,groupname,"observables_value_dataset",self.write_observable_value_dataset,self.file,"observables/"+groupname+"/"+observablename+"/value",(1,1),(None,None),'f8',2)             
  def write_observable_step_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=timestep 
  def write_observable_time_dataset(self,dataset,timestep):
    if(dataset.len()<=timestep+1):
      dataset.resize((timestep+1,1))
    dataset[timestep]=self.system.time
  def write_observable_value_dataset(self,dataset,timestep,value):
    try:
      value_length=len(value)
    except:
      value_length=1 
    dataset.resize((timestep+1,value_length))
    for i in range(0,value_length):
      dataset[timestep,i]=value[i]          
  def h5_read_observable(self,timestep,observablename,groupname):  
    try:
      self.observables_step_dataset=self.ReadDataset(self.file,'observables/'+groupname+'/'+observablename,'step')
      self.observables_time_dataset=self.ReadDataset(self.file,'observables/'+groupname+'/'+observablename,'time')
      self.observables_value_dataset=self.ReadDataset(self.file,'observables/'+groupname+'/'+observablename,'value')
    except:
      print "Error: No observables/"+groupname+"/"+observablename+"/value,time,step dataset in h5-file available"
      sys.exit()     
  
  



  #####################################################################################################################################  
  ##################################################### VMD PARAMETERS GROUP ########################################################## 
  #####################################################################################################################################
  
  ##################################################### VMD READ/WRITE DATASET CLASS ##################################################
  	
  def h5_write_vmd_parameters(self,groupname=""):
    #IndexOfSpecies and atomicnumber
    try:
      self.parameters_vmd_atomicnumber_dataset=self.CreateDataset(self.file,"parameters/"+groupname+"/vmd_structure/atomicnumber",(1,1),(None,1),'int64')
    except:
      self.parameters_vmd_atomicnumber_dataset=self.file['parameters/'+groupname+'/vmd_structure/atomicnumber']   
    try:
      self.parameters_vmd_indexOfSpecies_dataset=self.CreateDataset(self.file,"parameters/"+groupname+"/vmd_structure/indexOfSpecies",(1,1),(None,1),'int64')
    except:
      self.parameters_vmd_indexOfSpecies_dataset=self.file['parameters/'+groupname+'/vmd_structure/indexOfSpecies']         
    #Determine number of species/atomicnumber
    number_of_species=0
    n_part=self.system.n_part
    for i in range(0,n_part): 
      if(self.system.part[i].type>number_of_species): 
        number_of_species=self.system.part[i].type
    #Assign values to indexOfSpecies/atomicnumber 
    species_array=np.zeros(number_of_species)
    for i in range(0,number_of_species):
      species_array[i]=i
    self.write_parameters_vmd_atomicnumber_dataset(self.parameters_vmd_atomicnumber_dataset,species_array)
    self.write_parameters_vmd_indexOfSpecies_dataset(self.parameters_vmd_indexOfSpecies_dataset,species_array)
      
    #Bond_from and bond_to
    try:
      self.parameters_vmd_bond_from_dataset=self.CreateDataset(self.file,"parameters/"+groupname+"/vmd_structure/bond_from",(1,1),(None,1),'int64')
    except:
      self.parameters_vmd_bond_from_dataset=self.file['parameters/'+groupname+'/vmd_structure/bond_from'] 
    try:
      self.parameters_vmd_bond_to_dataset=self.CreateDataset(self.file,"parameters/"+groupname+"/vmd_structure/bond_to",(1,1),(None,1),'int64')
    except:
      self.parameters_vmd_bond_to_dataset=self.file['parameters/'+groupname+'/vmd_structure/bond_to']     
    for i in range(0,n_part): 
      for j in range(0,len(self.system.part[i].bonds)):
        self.write_parameters_vmd_bond_from_dataset(self.particles_position_value_dataset,i) 
        self.write_parameters_vmd_bond_from_dataset(self.particles_position_value_dataset,self.system.part[i].bonds[j,1])
                        
  
  def h5_read_vmd_parameters(self,groupname=""):  
    #IndexOfSpecies and atomicnumber
    try:
      self.parameters_vmd_atomicnumber_dataset=self.ReadDataset(self.file,'parameters/'+groupname+'/vmd_structure','atomicnumber')
    except:
      print "Error: No parameters/"+groupname+"/vmd_structure/atomicnumber dataset in h5-file available"
      sys.exit()      
    try:
      self.parameters_vmd_indexOfSpecies_dataset=self.ReadDataset(self.file,'parameters/'+groupname+'/vmd_structure','indexOfSpecies')
    except:
      print "Error: No parameters/"+groupname+"/vmd_structure/indexOfSpecies dataset in h5-file available"
      sys.exit() 
    #Bond_from and bond_to 
    try:
      self.parameters_vmd_bond_from_dataset=self.ReadDataset(self.file,'parameters/'+groupname+'/vmd_structure','bond_from')
    except:
      print "Error: No parameters/"+groupname+"/vmd_structure/bond_from dataset in h5-file available"
      sys.exit()    
    try:
      self.parameters_vmd_bond_to_dataset=self.ReadDataset(self.file,'parameters/'+groupname+'/vmd_structure','bond_to')
    except:
      print "Error: No parameters/"+groupname+"/vmd_structure/bond_to dataset in h5-file available"
      sys.exit() 
        

  class h5_write_vmd_parameters_extra(object):
    def __init__(self,self_h5md_class):
      self.self_h5md_class=self_h5md_class         
    #Chain
    def chain(self,array,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_chain_dataset=self.self_h5md_class.CreateDataset(self.self_h5md_class.file,"parameters/"+groupname+"/vmd_structure/chain",(1,1),(None,1),'S30')
      except:
        self.self_h5md_class.parameters_vmd_chain_dataset=self.self_h5md_class.file['parameters/'+groupname+'/vmd_structure/chain']    
      self.self_h5md_class.write_parameters_vmd_chain_dataset(self.self_h5md_class.parameters_vmd_chain_dataset,array)  
    #Name
    def name(self,array,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_name_dataset=self.self_h5md_class.CreateDataset(self.self_h5md_class.file,"parameters/"+groupname+"/vmd_structure/name",(1,1),(None,1),'S30')
      except:
        self.self_h5md_class.parameters_vmd_name_dataset=self.self_h5md_class.file['parameters/'+groupname+'/vmd_structure/name']    
      self.self_h5md_class.write_parameters_vmd_name_dataset(self.self_h5md_class.parameters_vmd_name_dataset,array)
    #Resid
    def resid(self,array,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_resid_dataset=self.self_h5md_class.CreateDataset(self.self_h5md_class.file,"parameters/"+groupname+"/vmd_structure/resid",(1,1),(None,1),'int64')
      except:
        self.self_h5md_class.parameters_vmd_resid_dataset=self.self_h5md_class.file['parameters/'+groupname+'/vmd_structure/resid']    
      self.self_h5md_class.write_parameters_vmd_resid_dataset(self.self_h5md_class.parameters_vmd_resid_dataset,array)
    #Resname
    def resname(self,array,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_resname_dataset=self.self_h5md_class.CreateDataset(self.self_h5md_class.file,"parameters/"+groupname+"/vmd_structure/resname",(1,1),(None,1),'S30')
      except:
        self.self_h5md_class.parameters_vmd_resname_dataset=self.self_h5md_class.file['parameters/'+groupname+'/vmd_structure/resname']    
      self.self_h5md_class.write_parameters_vmd_resname_dataset(self.self_h5md_class.parameters_vmd_resname_dataset,array)
    #Segid
    def segid(self,array,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_segid_dataset=self.self_h5md_class.CreateDataset(self.self_h5md_class.file,"parameters/"+groupname+"/vmd_structure/segid",(1,1),(None,1),'S30')
      except:
        self.self_h5md_class.parameters_vmd_segid_dataset=self.self_h5md_class.file['parameters/'+groupname+'/vmd_structure/segid']    
      self.self_h5md_class.write_parameters_vmd_segid_dataset(self.self_h5md_class.parameters_vmd_segid_dataset,array)  
    #Type
    def type(self,array,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_type_dataset=self.self_h5md_class.CreateDataset(self.self_h5md_class.file,"parameters/"+groupname+"/vmd_structure/type",(1,1),(None,1),'S30')
      except:
        self.self_h5md_class.parameters_vmd_type_dataset=self.self_h5md_class.file['parameters/'+groupname+'/vmd_structure/type']    
      self.self_h5md_class.write_parameters_vmd_type_dataset(self.self_h5md_class.parameters_vmd_type_dataset,array) 
                        
                    
  class h5_read_vmd_parameters_extra(object):
    def __init__(self,self_h5md_class):
      self.self_h5md_class=self_h5md_class    
    #Chain  
    def chain(self,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_chain_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'parameters/'+groupname+'/vmd_structure','chain')
      except:
        print "Error: No parameters/"+groupname+"/vmd_structure/chain dataset in h5-file available"
        sys.exit()
    #Name  
    def name(self,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_name_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'parameters/'+groupname+'/vmd_structure','name')
      except:
        print "Error: No parameters/"+groupname+"/vmd_structure/name dataset in h5-file available"
        sys.exit()  
    #Resid  
    def resid(self,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_resid_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'parameters/'+groupname+'/vmd_structure','resid')
      except:
        print "Error: No parameters/"+groupname+"/vmd_structure/resid dataset in h5-file available"
        sys.exit() 
    #Resname  
    def resname(self,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_resname_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'parameters/'+groupname+'/vmd_structure','resname')
      except:
        print "Error: No parameters/"+groupname+"/vmd_structure/resname dataset in h5-file available"
        sys.exit()
    #Segid  
    def segid(self,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_segid_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'parameters/'+groupname+'/vmd_structure','segid')
      except:
        print "Error: No parameters/"+groupname+"/vmd_structure/segid dataset in h5-file available"
        sys.exit()
    #Type  
    def type(self,groupname=""):
      try:
        self.self_h5md_class.parameters_vmd_type_dataset=self.self_h5md_class.ReadDataset(self.self_h5md_class.file,'parameters/'+groupname+'/vmd_structure','type')
      except:
        print "Error: No parameters/"+groupname+"/vmd_structure/type dataset in h5-file available"
        sys.exit() 
       
       
  ##################################################### VMD WRITE DATASET FUNCTIONS ####################################################    
  
  #TODO create/read bei mass,radius etc weg
  #Atomic number
  def create_parameters_vmd_atomicnumber_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/atomicnumber",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def write_parameters_vmd_atomicnumber_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]
    
  def read_parameters_vmd_atomicnumber_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['atomicnumber']

  #Bond from
  def create_parameters_vmd_bond_from_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/bond_from",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def write_parameters_vmd_bond_from_dataset(self,dataset,value):
    dataset.resize((dataset.len()+1,1))
    dataset[dataset.len()+1]=value

  def read_parameters_vmd_bond_from_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['bond_from']

  #Bond to    
  def create_parameters_vmd_bond_to_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/bond_to",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def write_parameters_vmd_bond_to_dataset(self,dataset,value):
    dataset.resize((dataset.len()+1,1))
    dataset[dataset.len()+1]=value 
      
  def read_parameters_vmd_bond_to_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['bond_to']
        
  #Chain
  def create_parameters_vmd_chain_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/chain",(1,1), maxshape=(None,1), dtype='S30')
    return dset
        
  def write_parameters_vmd_chain_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]
      
  def read_parameters_vmd_chain_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['chain']    
  
  #IndexOfSpecies    
  def create_parameters_vmd_indexOfSpecies_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/indexOfSpecies",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def write_parameters_vmd_indexOfSpecies_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]
      
  def read_parameters_vmd_indexOfSpecies_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['indexOfSpecies']
      
  #Charge
  def create_parameters_vmd_charge_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/charge",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def write_parameters_vmd_charge_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    

  def read_parameters_vmd_charge_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['charge']    
      
  #Mass
  def create_parameters_vmd_mass_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/mass",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def write_parameters_vmd_mass_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    
      
  def read_parameters_vmd_mass_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['mass']    
      
  #Name
  def create_parameters_vmd_name_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/name",(1,1), maxshape=(None,1), dtype='S30')
    return dset
        
  def write_parameters_vmd_name_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    
      
  def read_parameters_vmd_name_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['name']     
      
  #Radius
  def create_parameters_vmd_radius_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/radius",(1,1), maxshape=(None,1), dtype='f8')
    return dset
        
  def write_parameters_vmd_radius_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]    
      
  def read_parameters_vmd_radius_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['radius']    
      
  #Resid    
  def create_parameters_vmd_resid_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/resid",(1,1), maxshape=(None,1), dtype='int64')
    return dset
        
  def write_parameters_vmd_resid_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]      

  def read_parameters_vmd_resid_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['resid']    

  #Resname
  def create_parameters_vmd_resname_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/resname",(1,1), maxshape=(None,1), dtype='S30')
    return dset
        
  def write_parameters_vmd_resname_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]

  def read_parameters_vmd_resname_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['resname']

  #Segid    
  def create_parameters_vmd_segid_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/segid",(1,1), maxshape=(None,1), dtype='S30')
    return dset
        
  def write_parameters_vmd_segid_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]  

  def read_parameters_vmd_segid_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['segid']
        
  #Type
  def create_parameters_vmd_type_dataset(self,file,groupname):
    dset = file.create_dataset("parameters/"+groupname+"/vmd_structure/type",(1,1), maxshape=(None,1), dtype='S30')
    return dset
        
  def write_parameters_vmd_type_dataset(self,dataset,array):
    if(dataset.len()<=len(array)+1):
      dataset.resize((len(array),1))
    for i in range(0,len(array)):
      dataset[i]=array[i]

  def read_parameters_vmd_type_dataset(self,filename,groupname):
    group=filename['parameters/'+groupname+'/vmd_structure']
    return group['type']
       

