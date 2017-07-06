require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe "Rserve::Connection on unix" do
  if !Rserve::ON_WINDOWS
    before do
      @r=Rserve::Connection.new
    end
    after do
      @r.close if @r.connected?
    end
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
    it "should raise ServerNotAvailableError if started another instance on another port" do
       lambda {Rserve::Connection.new(:port_number=>6700)}.should raise_exception(Rserve::Connection::ServerNotAvailableError)
    end
    it "should create different session on *nix" do
       s=Rserve::Connection.new
       @r.assign("a", 1)
       s.assign("a",2)
       @r.eval('a').to_i.should==1
       s.eval('a').to_i.should==2
       s.close
    end
    it "should eval_void_detach correctly" do
      s=@r.void_eval_detach("x<-c(TRUE,FALSE)")
      @r.should_not be_connected      
      s.should be_instance_of(Rserve::Session)
      s.host.should==@r.hostname
      s.key.size.should==32
    end
    it "should detach and attach correctly" do
      x=rand(100)
      @r.void_eval("x<-#{x}")
      s=@r.detach
      @r.should_not be_connected      
      s.should be_instance_of(Rserve::Session)
      s.host.should==@r.hostname
      s.key.size.should==32
      r=s.attach
      r.eval("x").to_ruby.should eq x
    end
  else
    it "shouldn't crash server with an incorrect expression as Windows version does"
    it "shouldn't raise ServerNotAvailableError if started another instance on another port as Windows version does"
    it "shouldn't create a different session. On Windows, every new connection closes previously open session"
    it "shouldn't eval_void_detach correctly"
    it "shouldn't detach correctly"
  end
  
end


