require 'socket'
require 'rbconfig'
module Rserve
  ON_WINDOWS=RbConfig::CONFIG['arch']=~/mswin|mingw/
end

require 'spoon' if RUBY_PLATFORM == "java"

require 'rserve/version'
require 'rserve/withnames'
require 'rserve/withattributes'
require 'rserve/with2dnames'
require 'rserve/with2dsizes'


require 'rserve/protocol'
require 'rserve/packet'
require 'rserve/talk'
require 'rserve/rexp'
require 'rserve/engine'
require 'rserve/session'
require 'rserve/connection'
require 'rserve/rlist'
require 'rserve/rfactor'
