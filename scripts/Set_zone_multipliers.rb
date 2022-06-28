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
floor_mults = {'P1'=>6,'L0'=>1,'L1'=>3,'L4'=>2,'L6'=>47,'L17'=>36}

# loop through each story in model
model.getBuildingStorys.each do |story|
  
  #look up floor multiplier from hash
  mult = floor_mults[story.name.to_s]
  #puts story.name.to_s & " " & mult.to_s
  
  # loop through spaces and set thermal zone multipliers
  story.spaces.each do |space|
    space.thermalZone.get.setMultiplier(mult)
    
    if story.name.to_s == "L6"
      if space.name.to_s.include? "T1"
        space.thermalZone.get.setMultiplier(11)
      end
    end
  end
end 


### save model
model.save_model(@osm_name,@osm_dir)