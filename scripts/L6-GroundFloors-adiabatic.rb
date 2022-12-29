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
floor = model.getConstructionByName('Typical Insulated Carpeted 6in Slab Floor').get
roof = model.getConstructionByName('Champion - Above Deck Roof').get
puts floor

model.getBuildingStorys.each do |story|
  

  
  # loop through spaces and set thermal zone multipliers
  story.spaces.each do |space|    
    if story.name.to_s.include? "Building Story 1"
    
      surfs = space.surfaces
      surfs.each do |surf|
        if surf.surfaceType == "Floor"
          #if surf.outsideBoundaryCondition != "Surface"
            surf.setOutsideBoundaryCondition("Adiabatic")
            surf.setConstruction(floor)
            puts surf.name
          #end
        elsif surf.surfaceType == "RoofCeiling"
          surf.setConstruction(roof)
          puts(surf.name)
        end
      end
    elsif story.name.to_s.include? "L17"
      surfs = space.surfaces
      surfs.each do |surf|
        if surf.surfaceType == "Floor"
          if surf.outsideBoundaryCondition != "Surface"
            surf.setOutsideBoundaryCondition("Adiabatic")
            puts surf.name
          end
        end
      end
    end
  end
end 


### save model
model.save_model(@osm_name,@osm_dir)