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
spaces = model.getSpaces
spaces.each do |space|
    if not space.thermalZone.empty?
        z = space.thermalZone.get
        #remove zone equipment
        z.equipment.each do |zone_equipment|
           if zone_equipment.to_ZoneHVACWaterToAirHeatPump.is_initialized
                zone_equipment.remove
                fan = OpenStudio::Model::FanOnOff.new(model,always_on)
                fan.setPressureRise(318)

                
                clg_coil = OpenStudio::Model::CoilCoolingWater.new(model,
                                                                    always_on)
                clg_coil.setName("#{z.name} 4PFC CLG COIL")
                htg_coil = OpenStudio::Model::CoilHeatingWater.new( model,
                                                        always_on) 
                htg_coil.setName("#{z.name} 4PFC HTG COIL")
                boilerloop = model.getPlantLoops[2]
                boilerloop.addDemandBranchForComponent(htg_coil)
                fc = OpenStudio::Model::ZoneHVACFourPipeFanCoil.new(model,
                                                                                always_on, 
                                                                                fan,
                                                                                clg_coil,
                                                                                htg_coil)

                fc.setName("#{z.name} 4PFC")
                fc.addToThermalZone(z)
           end
        end
    end
end 













### save model
model.save_model(@osm_name,@osm_dir)