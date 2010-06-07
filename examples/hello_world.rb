require 'rserve'
include Rserve
c = Connection.new
x = c.eval("R.version.string");
puts x.as_string


d = c.eval("rnorm(10000)").as_doubles
