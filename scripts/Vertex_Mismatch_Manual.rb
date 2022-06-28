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
mismatch = ["SURFACE 1946","SURFACE 850","SURFACE 2084","SURFACE 443","SURFACE 850","SURFACE 1946"]

# loop through each story in model
mismatch.each do |surf|
  
  surface = model.getSurfaceByName(surf).get
  #get surface
  surface.resetAdjacentSurface
  surface.setOutsideBoundaryCondition("Adiabatic")
  
end 


### save model
model.save_model(@osm_name,@osm_dir)