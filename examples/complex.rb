# An example testing support for complex numbers.
#

require 'rserve'
c = Rserve::Connection.new

r = c.eval("complex(real = 4:5, imaginary = 1:2)")
#r = c.eval("complex(real = 1, imaginary = 3:4)")

puts r
puts r.to_debug_string
puts r.as_complex.inspect
puts r.to_ruby.inspect
puts r.as_doubles.inspect

# TODO: Make this work
#puts c.assign("x", Rserve::REXP::Complex.new(Complex(1,2)))
#puts con.eval("x")

