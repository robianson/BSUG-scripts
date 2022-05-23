require 'openstudio'
require_relative '../setup.rb'
require_relative '../lib/model.rb'

# load model
osm_path = File.join(@osm_dir, @osm_name)
model = ModelFile.load_model(osm_path)

#### save a backup
backup = ModelFile.unique_name(osm_path)
model.save_model(File.basename(backup),@osm_dir)

#### do stuff here
degens = ['SURFACE 428','SURFACE 1710','SURFACE 1814','SURFACE 593','SURFACE 1909','SURFACE 1905',
'SURFACE 799','SURFACE 802','SURFACE 777','SURFACE 1095','SURFACE 1127','SURFACE 1021','SURFACE 1521','SURFACE 1542']

# loop through each story in model
degens.each do |surf|
  
  #get surface
  surface = model.getSurfaceByName(surf).get
  puts surface.name.to_s
  
  surface.remove
end 


### save model
model.save_model(@osm_name,@osm_dir)