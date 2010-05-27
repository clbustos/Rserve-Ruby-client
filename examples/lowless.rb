require 'rserve'

data_x=Rserve::REXP::Wrapper.wrap(10.times.map{|i| rand(i)})
data_y=Rserve::REXP::Wrapper.wrap(10.times.map{|i| rand(i)})
c = Rserve::Connection.new();
c.assign("x", data_x);
c.assign("y", data_y);
l = c.eval("lowess(x,y)").as_list
lx = l.at("x").as_floats
ly = l.at("y").as_floats
