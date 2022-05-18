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
windows = model.getSubSurfaces
windows.each do |window|
   if window.surface.is_initialized
      if window.surface.get.outsideBoundaryCondition != "Outdoors" 
         window.remove
      end
  else
     window.remove
  end
end 


### save model
model.save_model(@osm_name,@osm_dir)