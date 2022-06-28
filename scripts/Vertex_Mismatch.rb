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
surfaces = model.getSurfaces

surfaces.each do |surf|
  if surf.outsideBoundaryCondition == "Surface"
    vtx = surf.numberofVertices
    adj = surface.adjacentSurface
    
end

### save model
model.save_model(@osm_name,@osm_dir)