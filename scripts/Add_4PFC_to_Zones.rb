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
zones = model.getThermalZones
zones.each do |z|
   has4pfc=false
    #check if zone has a 4PFC
    z.equipment.each do |zone_equipment|
        if zone_equipment.to_ZoneHVACFourPipeFanCoil.is_initialized
            has4pfc = true
        end
    end

    if !has4pfc
        puts z.name.to_s
    end
end 

### save model
model.save_model(@osm_name,@osm_dir)