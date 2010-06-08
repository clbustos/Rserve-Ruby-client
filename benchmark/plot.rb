# Creates a graph with multiple size assignment and retrieval

require 'rubygems'
require 'rserve'
require 'rinruby'
require 'benchmark'
require 'statsample'

max=40
R.eval("1")
con=Rserve::Connection.new
rserve_assign    = []
rserve_retrieve  = []
rinruby_assign   = []
rinruby_retrieve = []
max.times.map {|x|
  puts "Rserve #{x}"
  start=Time.new.to_f
  con.assign('a',(x*100+1).times.map {rand})
  a=Time.new.to_f-start
  
  start=Time.new.to_f

  con.eval('a').to_f
  
  b=Time.new.to_f-start
  
  rserve_assign.push(a)
  rserve_retrieve.push(b)
}
rinruby=max.times.map {|x|

  puts "Rinruby #{x}"
  start=Time.new.to_f
  R.assign("a", (x*100+1).times.map {rand})
  a=Time.new.to_f-start
  start=Time.new.to_f
  R.pull('a')
  b=Time.new.to_f-start
  rinruby_assign.push(a)
  rinruby_retrieve.push(b)
}

ds_assign={'times'=>(1..max).map {|v| v*100+1}.to_scale,'rserve assign'=> rserve_assign.to_scale, 'rserve retrieve'=>rserve_retrieve.to_scale, 'rinruby assign'=>rinruby_assign.to_scale, 'rinruby retrieve'=>rinruby_retrieve.to_scale}.to_dataset
Statsample::CSV.write(ds_assign,'comparison.csv')
