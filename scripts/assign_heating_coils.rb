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



t1h = model.getPlantLoopByName("HHW Loop T1").get
t2h = model.getPlantLoopByName("HHW Loop T2").get
t3h = model.getPlantLoopByName("HHW Loop T3").get
t1c = model.getPlantLoopByName("CHW Loop T1").get
t2c = model.getPlantLoopByName("CHW Loop T2").get
t3c = model.getPlantLoopByName("CHW Loop T3").get

htg_coils = model.getCoilHeatingWaters
htg_coils.each do |coil|
    if coil.name.to_s.include? "T3"
        t3h.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T2"
        t2h.addDemandBranchForComponent(coil)
    else
        t1h.addDemandBranchForComponent(coil)
    end
end

clg_coils = model.getCoilCoolingWaters
clg_coils.each do |coil|
    if coil.name.to_s.include? "T3"
        t3c.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T2"
        t2c.addDemandBranchForComponent(coil)
    else
        t1c.addDemandBranchForComponent(coil)
    end
end
### save model
model.save_model(@osm_name,@osm_dir)