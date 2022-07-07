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


zones = []

zonelist.each do |zone_name|
    if model.getThermalZoneByName(zone_name).is_initialized
        z = model.getThermalZoneByName(zone_name).get
        bbs = 0
        zone_eqp = z.equipment
        zone_eqp.each do |eqp|
        if eqp.to_ZoneHVACBaseboardRadiantConvectiveElectric.is_initialized
            bbs = 1
        end
        end
    
        if bbs == 0
        zones << z
        else
        puts "Thermal zone '#{z.name}' already has a baseboard. Skipping."
        end
    end
end

# For each thermal zones (zones is initialized above, depending on which filter you chose)
zones.each do |z|
    puts "Adding Baseboard for '#{z.name}'."
    #create an Electric Baseboard
    elec_baseboard = OpenStudio::Model::ZoneHVACBaseboardRadiantConvectiveElectric.new(model)
    elec_baseboard.setName("#{z.name}_Elec Baseboard")
    #add the electric Baseboard Heater to the zone
    elec_baseboard.addToThermalZone(z)
end

### save model
model.save_model(@osm_name,@osm_dir)