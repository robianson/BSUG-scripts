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
report_path = "#{@osm_dir}/#{@osm_name.gsub('.osm','')} surface vertex list.csv"

# open csv file for writing
csv = CSV.open(report_path, 'w')

# write header row 
csv << ["Surface", "Area", "Vertex", "x","y","z"]

# loop through each space in model
model.getSurfaces.each do |surf|
  


  # add space name to array
  surfname = surf.name.get
  

  # get space floor area
  area = surf.grossArea  # returns a double, in m^2 https://s3.amazonaws.com/openstudio-sdk-documentation/cpp/OpenStudio-2.7.0-doc/model/html/classopenstudio_1_1model_1_1_space.html#a7d087ac39439b48c4f9b762c5d19246b
  # convert area from m^2 to ft^2)
  area_ip = OpenStudio.convert(area,"m^2","ft^2").get
  
  ii = 0
  surf.vertices.each do |vertex|
    # create new array to hold surface information
    surface_info = []
    # add to array
    surface_info << surf.name.get
    surface_info << area_ip
    surface_info << ii
    surface_info << vertex.x
    surface_info << vertex.y
    surface_info << vertex.z
    ii = ii + 1
    # write row to file
    csv << surface_info
  end

end 

# close csv file
csv.close











# ### save model
# model.save_model(@osm_name,@osm_dir)