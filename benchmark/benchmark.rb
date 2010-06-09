# Compares rserve, rinruby and rsruby
# in retrieval and assign of information
$:.unshift(File.dirname(__FILE__)+"/../lib")

require 'rubygems'
require 'rserve'
require 'rinruby'
begin 
require 'rsruby'
rs=RSRuby.instance
rescue LoadError
rs=nil
end
require 'benchmark'
data_size=30000
tries=50
con=Rserve::Connection.new
R.eval("1",false)
data=data_size.times.map {rand()}
data_integer=data_size.times.map {rand(100)}
Benchmark.bm(30) do |x|
  x.report("assign '1' rinruby") {
    tries.times {
      R.a=1
    }
  }
  x.report("assign '1' rserve") {
    con.assign("a", 1)
  }
  if rs
  x.report("assign '1' rsruby") {
    rs.assign('a',1)
  }
  end
  x.report("assign double(#{data_size}) rinruby") {
    tries.times {
      R.a=data
    }
  }
  x.report("assign double(#{data_size}) rserve") {
    con.assign("a", data)
  }
  if rs
  x.report("assign double(#{data_size}) rsruby") {
    rs.assign("a", data)
  }
end
  x.report("void_eval rinruby") {
    tries.times {
      R.eval("1",false)
    }
  }
  x.report("void_eval rserve") {
    tries.times {
      con.void_eval("1")
    }
  }
  if rs
  x.report("void_eval rsruby") {
    tries.times {
      rs.eval("1")
    }
  }
  end
  # Assign data
  R.a=1
  con.assign('a',1)
  if rs
  rs.assign('a',1)
  end
  x.report("get '1' rinruby") {
    tries.times {
      R.pull('a')
    }
  }
  x.report("get '1' rserve") {
    tries.times {
      con.eval('a').to_ruby
    }
  }
  if rs
  x.report("get '1' rsruby") {
    tries.times {
      rs.a
    }
  }
end
  
  R.a=data
  con.assign('a',data)
  if rs
  rs.assign('a',data)
  end
  x.report("get double(#{data_size}) rinruby") {
    tries.times {
      R.pull('a')
    }
  }
  x.report("get double(#{data_size}) rserve") {
    tries.times {
      con.eval('a').to_ruby
    }
  }
  
  if rs
  x.report("get double(#{data_size}) rsruby") {
    tries.times {
      rs.a
    }
  }
  end

end
