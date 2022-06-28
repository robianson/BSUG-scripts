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

#remove all elec baseboards
bbs = model.getZoneHVACBaseboardRadiantConvectiveElectrics
bbs.each do |baseboard|
    baseboard.remove
end

#add gas unit heaters

zonelist = ["Thermal Zone: L0 MPOS_STO", 
"Thermal Zone: L0 T2 Bike Storage S_STO", 
"Thermal Zone: L0 T2 Bike Storage_STO", 
"Thermal Zone: L2 T1 Stair 01A_STR", 
"Thermal Zone: L2 T1 Stair 01E_STR", 
"Thermal Zone: L2 T2 Stair 02A_STR", 
"Thermal Zone: L2 T2 Stair 02B_STR", 
"Thermal Zone: L2 T3 Stairs Combined_STR", 
"Thermal Zone: L17 T1 Stair 01A_STR", 
"Thermal Zone: L17 T1 Stair 01B_STR", 
"Thermal Zone: L4 T1 Stair 01A_STR", 
"Thermal Zone: L4 T1 Stair 01B_STR", 
"Thermal Zone: L4 T2 Stair 02A_STR", 
"Thermal Zone: L4 T2 Stair 02B_STR", 
"Thermal Zone: L4 T2 Stair 02C_STR", 
"Thermal Zone: L4 T3 Stairs Combined_STR", 
"Thermal Zone: L6 T1 Stair 01A_STR", 
"Thermal Zone: L6 T1 Stair 01B_STR", 
"Thermal Zone: L6 T2 Stair 02A_STR", 
"Thermal Zone: L6 T2 Stair 02B_STR", 
"Thermal Zone: L6 T3 Stairs Combined_STR", 
"Thermal Zone: P1 T1 Storage_STO", 
"Thermal Zone: P1 T3 Storage 1_STO", 
"Thermal Zone: P1 T3 Storage 2_STO", 
"Thermal Zone: P1 T3 Storage 3_STO",
"Thermal Zone: P1 T2 Storage_STO"]

#check whether zones already have unit heaters
zones = []

zonelist.each do |zone_name|
    if model.getThermalZoneByName(zone_name).is_initialized
        z = model.getThermalZoneByName(zone_name).get
        bbs = 0
        zone_eqp = z.equipment
        zone_eqp.each do |eqp|
        if eqp.to_ZoneHVACUnitHeater.is_initialized
            bbs = 1
        end
        end
    
        if bbs == 0
        zones << z
        else
        puts "Thermal zone '#{z.name}' already has a unit heater. Skipping."
        end
    end
end


# For each thermal zones (zones is initialized above, depending on which filter you chose)

always_on = model.getScheduleByName('Always On Discrete').get

zones.each do |z|
    puts "Adding UH for '#{z.name}'."
    #create an Electric Baseboard
    fan = OpenStudio::Model::FanOnOff.new(model,always_on)
    fan.setPressureRise(318) #0.3 W/CFM, I hope
    htg_coil = OpenStudio::Model::CoilHeatingGas.new( model,
        always_on) 
    htg_coil.setGasBurnerEfficiency(0.78)

    unit_heater = OpenStudio::Model::ZoneHVACUnitHeater.new(model,always_on,fan,htg_coil)
    unit_heater.setName("#{z.name}_Gas UH")

    #add the electric Baseboard Heater to the zone
    unit_heater.addToThermalZone(z)
end

### save model
model.save_model(@osm_name,@osm_dir)