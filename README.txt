= rserve-client

* http://github.com/clbustos/Rserve-Ruby-client


== DESCRIPTION:

Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/).

Follows closely the new Java client API, but maintains all Ruby conventions when possible.

== FEATURES / LIMITATIONS

* 100% ruby
* Uses TCP/IP sockets to interchange data and commands
* Requires Rserve installed on the server machine. On debian /  ubuntu, you should use <tt>sudo apt-get install r-cran-rserve</tt>
Pros:
  * Work with Ruby 1.8, 1.9 and JRuby 1.5
  * Implements almost completely R's datatypes: integer, doubles, chars, logical vectors, lists and raw data.
  * Follows closely the Java API, so any change on the server could be adopted without much problem
  * Fast
Cons:
  * Requires Rserve
  * No seamless integration with Ruby. You obtain data with an interface closer to R than Ruby.
 
== RELATED LIBRARIES (Ruby / R)

* Rinruby [http://rinruby.ddahl.org/]
  * 100% ruby 
  * Uses pipes to send commands and evals
  * Uses TCP/IP Sockets to send and retrieve data
  * Pros:
    * Doesn't requires anything but R
    * Work with Ruby 1.8, 1.9 and JRuby 1.5
    * All API tested
  * Cons:
    * VERY SLOW
    * Very limited datatypes: Only vector and Matrix
* RSRuby
  * C Extension for Ruby, linked to R's shared library
  * Pros:
    * Very fast data access
    * Seamless integration with ruby. Every method and object is treated like a Ruby one
  * Cons:
    * Transformation between R and Ruby types aren't trivial
    * Dependent of operating system, Ruby implementation and R version
    * Not available for alternative implementations of Ruby (JRuby, IronRuby and Rubinius)
    
    
== TODO

Implements

* REXPs
  * Enviroment
  * ExpressionVector
  * Raw
  * Reference
  * S4
  * Wrapper
* Sessions
* Authentification
* Original test

Spec

* Test suite on Rserve Java new API
* First tutorial on R


== SYNOPSIS:

  require 'rserve'
  con=Rserve::Connection.new
  con.eval("x<-rnorm(1)")
  => #<Rserve::REXP::Double:0x000000011a13c8 
        @payload=[(5339785585931699/2251799813685248)], 
	@attr=nil>
  con.eval("list(name='Fred')").as_list
  
  => #<Rserve::Rlist:0x00000001bf82a8 @names=["name"], @data=[#<Rserve::REXP::String:0x00000001bf8548 @payload=["Fred"], @attr=nil>]>

== REQUIREMENTS:

* R
* Rserve

== INSTALL:

  sudo gem install rserve-client

== LICENSE:

REngine - Java interface to R
Copyright (C) 2004,5,6,7  Simon Urbanek 
Copyrigth (C) 2010 Claudio Bustos (Ruby version)

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
