= rserve-client

* http://github.com/clbustos/Rserve-Ruby-client


== DESCRIPTION:

Ruby client for Rserve, a Binary R server (http://www.rforge.net/Rserve/).

Follows closely the new Java client API, but maintains all Ruby conventions when possible.

== FEATURES / LIMITATIONS

* Easy way to connect to R from Ruby
* Doesn't need any extension, so works on Windows
* Very fast (uses TCP)
* Basic implementation compared to Java Client. You should use only eval and void_eval for now.

== SYNOPSIS:

  require 'rserve'
  con=Rserve::Connection.new
  con.eval("x<-rnorm(1)").as_double.to_f
  => => -1.71032693764757

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
