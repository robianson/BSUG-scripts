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
pszs = model.getAirLoopHVACUnitarySystems

pszs.each do |psz|
    #rename PSZ-HP stuff as PSZ-AC
    psz.airLoopHVAC.get.setName(psz.airLoopHVAC.get.name.to_s.sub("PSZ-HP","PSZ-AC"))
    psz.setName(psz.name.to_s.sub("PSZ-HP","PSZ-AC"))
    psz.coolingCoil.get.setName(psz.coolingCoil.get.name.to_s.sub("PSZ-HP","PSZ-AC"))
    psz.supplyFan.get.setName(psz.supplyFan.get.name.to_s.sub("PSZ-HP","PSZ-AC"))
    
    #Replace HP Heating Coils with Gas
    oldhc = psz.heatingCoil.get
    if oldhc.to_CoilHeatingDXSingleSpeed.is_initialized
        newhc = OpenStudio::Model::CoilHeatingGas.new(model,always_on) 
        newhc.setName("#{psz.airLoopHVAC.get.name}_Gas Htg Coil")
        psz.setHeatingCoil(newhc)
        oldhc.remove
    end

end


### save model
model.save_model(@osm_name,@osm_dir)