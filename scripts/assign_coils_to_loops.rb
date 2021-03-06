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
#remove all components from plant loops with "HW loop" in the name (includes both HHW and CHW)  
model.getPlantLoops.each do |loop|
    if loop.name.to_s.include? "HW Loop"
        loop.demandComponents.each do |comp|
            if comp.name.to_s.include? "Coil"
                loop.removeDemandBranchWithComponent(comp.to_HVACComponent.get)
            end
        end
    end
end

ph = model.getPlantLoopByName("HHW Loop Podium").get
t1h = model.getPlantLoopByName("HHW Loop T1").get
t2h = model.getPlantLoopByName("HHW Loop T2").get
t3h = model.getPlantLoopByName("HHW Loop T3").get
pc = model.getPlantLoopByName("CHW Loop Podium").get
t1c = model.getPlantLoopByName("CHW Loop T1").get
t2c = model.getPlantLoopByName("CHW Loop T2").get
t3c = model.getPlantLoopByName("CHW Loop T3").get

htg_coils = model.getCoilHeatingWaters
htg_coils.each do |coil|
    if (coil.name.to_s.include? "P1") || (coil.name.to_s.include? "L0") || (coil.name.to_s.include? "L2")
        ph.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T2"
        t2h.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T1"
        t1h.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T3"
        t3h.addDemandBranchForComponent(coil)
    else
        ph.addDemandBranchForComponent(coil)
    end
end

clg_coils = model.getCoilCoolingWaters
clg_coils.each do |coil|
    if (coil.name.to_s.include? "P1") || (coil.name.to_s.include? "L0") || (coil.name.to_s.include? "L2")
        pc.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T2"
        t2c.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T1"
        t1c.addDemandBranchForComponent(coil)
    elsif coil.name.to_s.include? "T3"
        t3c.addDemandBranchForComponent(coil)
    else
        pc.addDemandBranchForComponent(coil)
    end
end
### save model
model.save_model(@osm_name,@osm_dir)