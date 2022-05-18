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
always_on = model.getScheduleByName('Always On Discrete').get
airloop = model.getAirLoopHVACByName('AC-43-1: Resi Corridor/Apt').get
spaces = model.getSpaces
spaces.each do |space|
    if not space.thermalZone.empty?
        z = space.thermalZone.get
        #remove zone equipment
        z.equipment.each do |zone_equipment|
           if zone_equipment.to_AirTerminalSingleDuctVAVNoReheat.is_initialized
                zone_equipment.remove
                tu = OpenStudio::Model::AirTerminalSingleDuctVAVNoReheat.new(model,always_on)
                
                tu.setName("#{z.name} DOAS Terminal")
                #tu.addToThermalZone(z,tu)
                airloop.addBranchForZone(z,tu)
                
           end
        end
    end
end 


### save model
model.save_model(@osm_name,@osm_dir)