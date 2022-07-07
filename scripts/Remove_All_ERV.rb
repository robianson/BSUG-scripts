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
ervs = model.getHeatExchangerAirToAirSensibleAndLatents

ervs.each do |erv|
    puts "removing ERV #{erv.name.to_s}"
    erv.remove
end

### save model
model.save_model(@osm_name,@osm_dir)