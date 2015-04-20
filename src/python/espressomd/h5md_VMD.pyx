
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
       

