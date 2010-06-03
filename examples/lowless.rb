require 'rserve'

data_x=20.times.map{|i| rand(i)}
data_y=20.times.map{|i| rand(i)}
c = Rserve::Connection.new();
c.assign("x", data_x);
c.assign("y", data_y);
l = c.eval("lowess(x,y)").as_list
lx = l["x"].as_floats
ly = l["y"].as_floats
puts "lx:#{lx}"
puts "ly:#{ly}"
