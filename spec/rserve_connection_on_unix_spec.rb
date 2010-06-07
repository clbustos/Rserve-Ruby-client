require File.dirname(__FILE__)+"/spec_helper.rb"
require 'rbconfig'
describe "Rserve::Connection on unix" do
  before do
      @r=Rserve::Connection.new
  end
  if RbConfig::CONFIG['arch']!~/mswin/
    it "method eval_void should raise an error with an incorrect expression" do
      lambda {@r.void_eval("x<-")}.should raise_exception(Rserve::Connection::EvalError) {|e| e.request_packet.stat.should==2}
      lambda {@r.void_eval("as.stt(c(1))")}.should raise_exception(Rserve::Connection::EvalError) {|e|
      e.request_packet.stat.should==127}
	  end
	  it "method eval should raise an error with an incorrect expression" do
      lambda {@r.eval("x<-")}.should raise_exception(Rserve::Connection::EvalError) {|e| e.request_packet.stat.should==2}
      lambda {@r.eval("as.stt(c(1))")}.should raise_exception(Rserve::Connection::EvalError) {|e|
      e.request_packet.stat.should==127}
	  end
    it "should raise ServerNotAvailable if started another instance on another port" do
       lambda {Rserve::Connection.new(:port_number=>6700)}.should raise_exception(Rserve::Connection::ServerNotAvailable)
    end
    it "should create different session on *nix" do
       s=Rserve::Connection.new
       @r.assign("a", 1)
       s.assign("a",2)
       @r.eval('a').to_i.should==1
       s.eval('a').to_i.should==2
       s.close
    end
  else
    it "shouldn't crash server with an incorrect expression as Windows version does"
    it "shouldn't raise ServerNotAvailable if started another instance on another port as Windows version does"
    it "shouldn create a different session. On Windows, every new connection closes previously open session"
  end
  
end


