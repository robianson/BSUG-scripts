# Custom Script for 606 Bellevue to Delete all Tower 3 HVAC and Geometry

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

spaces = model.getSpaces
spaces.each do |space|
    if (space.name.to_s.include? "L6 T3") || (space.name.to_s.include? "L4 T3")
        puts space.name.to_s
        z = space.thermalZone.get
        #remove zone equipment
        z.equipment.each do |zone_equipment|
            zone_equipment.remove
        end
        z.remove
        space.remove
    end
end 

loops = model.getAirLoopHVACs
loops.each do |loop|
    if loop.thermalZones.count ==0
        puts loop.name.to_s
        if !loop.supplyComponents(OpenStudio::Model::CoilCoolingWater::iddObjectType).empty?
            loop.supplyComponents(OpenStudio::Model::CoilCoolingWater::iddObjectType).each do |coil|
                coil.remove
            end
        end
        if !loop.supplyComponents(OpenStudio::Model::CoilHeatingWater::iddObjectType).empty?
            loop.supplyComponents(OpenStudio::Model::CoilHeatingWater::iddObjectType).each do |coil|
                coil.remove
            end
        end
        loop.remove
    end
end
### save model
model.save_model(@osm_name,@osm_dir)