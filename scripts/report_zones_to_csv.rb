require 'openstudio'
require_relative '../setup.rb'
require_relative '../lib/model.rb'


# load csv library
require 'csv'

# load model
osm_path = File.join(@osm_dir, @osm_name)
model = ModelFile.load_model(osm_path)

#### save a backup
# backup = ModelFile.unique_name(osm_path)
# model.save_model(File.basename(backup),osm_dir)

#### do stuff here

# create path to save csv file
report_path = "#{@osm_dir}/#{@osm_name.gsub('.osm','')} zones.csv"

# open csv file for writing
csv = CSV.open(report_path, 'w')

# write header row 
csv << ["Zone Name", "Area", "Cooling Schedule", "Heating Schedule"]

# loop through each space in model
model.getThermalZones.each do |zone|
  
  # create new array to hold space information
  zone_info = []

  # add space name to array
  zone_info << zone.name.get

  # get space floor area
  area = zone.floorArea  # returns a double, in m^2 https://s3.amazonaws.com/openstudio-sdk-documentation/cpp/OpenStudio-2.7.0-doc/model/html/classopenstudio_1_1model_1_1_space.html#a7d087ac39439b48c4f9b762c5d19246b
  # convert area from m^2 to ft^2)
  area_ip = OpenStudio.convert(area,"m^2","ft^2").get
  # add to array
  space_info << area_ip

  # get thermostat
  tstat = zone.thermostat
  if tstat.is_initialized
    coolingsched = tstat.
  end
  
  # convert and add to array
  space_info << OpenStudio.convert(lpd,"W/m^2","W/ft^2").get

  # get equipment pd and add to array
  space_info << OpenStudio.convert(space.electricEquipmentPowerPerFloorArea,"W/m^2","W/ft^2").get

  # write row to file
  csv << space_info
end 

# close csv file
csv.close











# ### save model
# model.save_model(@osm_name,@osm_dir)