require 'socket'
require 'rbconfig'
module Rserve
  ON_WINDOWS=RbConfig::CONFIG['arch']=~/mswin|mingw/
end

require 'spoon' if RUBY_PLATFORM == "java"
require 'require_relative' if RUBY_VERSION < "1.9"

require_relative 'rserve/withnames'
require_relative 'rserve/withattributes'
require_relative 'rserve/with2dnames'
require_relative 'rserve/with2dsizes'


require_relative 'rserve/protocol'
require_relative 'rserve/packet'
require_relative 'rserve/talk'
require_relative 'rserve/rexp'
require_relative 'rserve/engine'
require_relative 'rserve/session'
require_relative 'rserve/connection'
require_relative 'rserve/rlist'
require_relative 'rserve/rfactor'
require_relative 'rserve/version'

