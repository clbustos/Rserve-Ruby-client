require File.dirname(__FILE__)+"/spec_helper.rb"
describe Rserve::Connection do
   describe "opening and closing" do
     before do
       @r=Rserve::Connection.new()
     end
     it "should be open a connection and receive ID-String" do
       @r.get_server_version.should==103
       @r.protocol.should=="QAP1"
       @r.last_error.should=="OK"
       @r.rt.should be_instance_of(Rserve::Talk)
     end
     it "should raise ServerNotAvailable if started another instance on another port" do
       lambda {Rserve::Connection.new(:port_number=>6700)}.should raise_exception(Rserve::Connection::ServerNotAvailable)
     end
     it "should quit correctly" do
       @r.should be_connected
       @r.close.should be_true
       @r.should_not be_connected
       @r.close.should be_true
     end
     it "raise an error if eval is clased after closed" do
       @r.close
       lambda {@r.eval("TRUE")}.should raise_exception(Rserve::Connection::NotConnected)
     end
     after do
       @r.close if @r.connected?
     end
   
 end
 describe "basic eval methods" do
    before do
      @r=Rserve::Connection.new
    end
    it "method eval_void should return true with correct expression" do
      @r.void_eval("x<-1").should be_true
    end
    it "method eval_void should raise an error with an incorrect expression" do
      lambda {@r.void_eval("x<-")}.should raise_exception(Rserve::Connection::EvalError) {|e| e.request_packet.stat.should==2}
      lambda {@r.void_eval("as.stt(c(1))")}.should raise_exception(Rserve::Connection::EvalError) {|e|
      e.request_packet.stat.should==127}
    end
    
    it "method eval should return a simple object" do
      la=@r.eval("TRUE")
      la.should be_instance_of(Rserve::REXP::Logical)
      la.true?.should==[true]
    end
    
    it "method eval should raise an error with an incorrect expression" do
      lambda {@r.eval("x<-")}.should raise_exception(Rserve::Connection::EvalError) {|e| e.request_packet.stat.should==2}
      lambda {@r.eval("as.stt(c(1))")}.should raise_exception(Rserve::Connection::EvalError) {|e|
      e.request_packet.stat.should==127}
    end
    
    it "should eval_void and eval correctly" do
      @r.void_eval("x<-c(TRUE,FALSE)").should be_true
      la=@r.eval("x")
      la.should be_instance_of(Rserve::REXP::Logical)
      la.true?.should==[true,false]      
    end
    it "should assign a string" do
      @r.assign("x","a string")
      @r.eval("x").to_ruby.should=="a string"
    end
    it "should assign a rexp" do
      @r.assign("x",Rserve::REXP::Double.new([1,2,3]))
      @r.eval("x").to_ruby.should==[1.0,2.0,3.0]
      
    end
  end
end
