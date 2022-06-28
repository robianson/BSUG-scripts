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
xs = set.new
ys = set.new
zs = set.new


#loop though each space in model
model.getSpaces.each do |space|
  x= space.xOrigin.to_f.round(2)
  y= space.yOrigin.to_f.round(2)
  z= space.zOrigin.to_f.round(2)
  if !xs.include?(x)
    if xs.include?(x+0.01)
      x = x+.01
    elsif(xs.include?(x-.01))
      x = x-.01
    else
      xs << x
    end
  end
     

  space.setXOrigin(x)
  space.setYOrigin(y)
  space.setZOrigin(z)
end


# loop through each surface in model
model.getSurfaces.each do |surface|
  
  # round x, y, and z coordinates of each surface to nearest centimeter
  surf_verts = []
  surface.vertices.each do |vert|

    x= vert.x.to_f.round(2)
    y= vert.y.to_f.round(2)
    z= vert.z.to_f.round(2)
    surf_verts << OpenStudio::Point3d.new(x,y,z)
  end
  surface.setVertices(surf_verts)

end 

# loop through each subsurface in model
model.getSubSurfaces.each do |subsurface|
  
  # round x, y, and z coordinates of each surface to nearest centimeter
  surf_verts = []
  subsurface.vertices.each do |vert|

    x= vert.x.to_f.round(2)
    y= vert.y.to_f.round(2)
    z= vert.z.to_f.round(2)
    surf_verts << OpenStudio::Point3d.new(x,y,z)
  end
  subsurface.setVertices(surf_verts)

end 

### save model
model.save_model(@osm_name,@osm_dir)








# ### save model
# model.save_model(@osm_name,@osm_dir)