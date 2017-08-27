# rserve-client

* http://github.com/clbustos/Rserve-Ruby-client

[![Build Status](https://travis-ci.org/clbustos/Rserve-Ruby-client.svg?branch=master)](https://travis-ci.org/clbustos/Rserve-Ruby-client)

## DESCRIPTION:

Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/).

Follows closely the new Java client API, but maintains all Ruby conventions when possible.

## FEATURES / LIMITATIONS

* 100% ruby
* Uses TCP/IP sockets to interchange data and commands
* Requires Rserve installed on the server machine. On debian /  ubuntu, you should use <tt>sudo apt-get install r-cran-rserve</tt>
Pros:
* Work with Ruby 1.9.3, 2.0.0, 2.1.1, 2.3.1 (tested on Travis) and  and JRuby 1.5.
* Retrieve and assign various R's datatypes: integer, doubles, chars, logical vectors, lists and raw data.
* Session allows to process data asynchronously. You start a command, detach the process and retrieve result later. You can marshall the session, store on file or database and use it when you need it.
* Ruby API follows closely the Java API, so any change on the server API could be adopted without much problem
* Fast: 5-10 times faster than RinRuby.
* Easy management of differences between R and Ruby, or "You can have your cake and eat it, too!"
  *  From R side: The evaluation of expression retrieves REXP object, with a lot of information from original variables on R. You can construct your REXP objects and <tt>assign</tt> them to variables on R fast using binary TCP/IP port or send complex expression without lost of time using <tt>void_eval</tt> 
  * Between R and Ruby: Every REXP object implements methods to convert to specific Ruby type: as_integers, as_doubles, as_strings
  * From Ruby side: Every REXP objects has a <tt>to_ruby</tt> method, which automagicly converts every R type on equivalent Ruby type. So, a vector of size 1 is converted to an integer or double, a vector of size>1 returns an array, a named list returns a hash and so on. If you need to create a complex expression, you could always use method <tt>eval</tt> without problem
Cons:
* Requires Rserve
* Limited features on Windows, caused by limitations on Rserve on this platform: single concurrent connection allowed, server crash on parse errors and can't spawn sessions.

## RELATED LIBRARIES (Ruby / R)

* Rinruby [http://rinruby.ddahl.org/]
  * 100% ruby 
  * Uses pipes to send commands and evals
  * Uses TCP/IP Sockets to send and retrieve data
  * Pros:
    * Doesn't requires anything but R
    * Works flawlessly on Windows
    * Work with Ruby 1.8, 1.9 and JRuby 1.5
    * All API tested
  * Cons:
    * VERY SLOW on assignation
    * Very limited datatypes: Only vector and Matrix
* RSRuby
  * C Extension for Ruby, linked to R's shared library
  * Pros:
    * Blazing speed! 5-10 times faster than Rserve and 100-1000 than RinRuby.
    * Seamless integration with ruby. Every method and object is treated like a Ruby one
  * Cons:
    * Transformation between R and Ruby types aren't trivial
    * Dependent on operating system, Ruby implementation and R version
    * Ocassionaly crash
    * Not available for alternative implementations of Ruby (JRuby, IronRuby and Rubinius)
    
    
## TODO

Implements

* Original test

Spec

* Test suite on Rserve Java new API
* First tutorial on R


## SYNOPSIS:

    require 'rserve'
    con=Rserve::Connection.new
    
    # Evaluation retrieves a <tt>Rserve::REXP</tt> object
    
    x=con.eval('x<-rnorm(1)')
    => #<Rserve::REXP::Double:0x000000010a81f0 @payload=[(4807469545488851/9007199254740992)], @attr=nil>

    # You could use specific methods to retrieve ruby objects
    x.as_doubles => [0.533736337958596]
    x.as_strings => ["0.533736337958596"]
    
    # Every Rserve::REXP could be converted to Ruby objects using
    # method <tt>to_ruby</tt>
    x.to_ruby => (4807469545488851/9007199254740992)
    
    # The API could manage complex recursive list
    
    x=con.eval('list(l1=list(c(2,3)),l2=c(1,2,3))').to_ruby
    => #<Array:19590368 [#<Array:19590116 [[(2/1), (3/1)]] names:nil>, [(1/1), (2/1), (3/1)]] names:["l1", "l2"]>

    
    # You could assign a REXP to R variables

    con.assign("x", Rserve::REXP::Double.new([1.5,2.3,5]))
    => #<Rserve::Packet:0x0000000136b068 @cmd=65537, @cont=nil>
    con.eval("x")
    => #<Rserve::REXP::Double:0x0000000134e770 @payload=[(3/2), (2589569785738035/1125899906842624), (5/1)], @attr=nil>
    
    # Rserve::REXP::Wrapper.wrap allows you to transform Ruby object to 
    # REXP, could be assigned to R variables
    
    Rserve::REXP::Wrapper.wrap(["a","b",["c","d"]])
    
    => #<Rserve::REXP::GenericVector:0x000000010c81d0 @attr=nil, @payload=#<Rserve::Rlist:0x000000010c8278 @names=nil, @data=[#<Rserve::REXP::String:0x000000010c86d8 @payload=["a"], @attr=nil>, #<Rserve::REXP::String:0x000000010c85c0 @payload=["b"], @attr=nil>, #<Rserve::REXP::String:0x000000010c82e8 @payload=["c", "d"], @attr=nil>]>>
    
## REQUIREMENTS:

* R
* Rserve

## INSTALL:

  sudo gem install rserve-client

## LICENSE:

REngine - Java interface to R
Copyright (C) 2004,5,6,7  Simon Urbanek 
Copyrigth (C) 2010-2017 Claudio Bustos (Ruby version)

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
