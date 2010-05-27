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

  end
  describe "assign using REXPs" do
    before do
      @r=Rserve::Connection.new

    end
    it "should assign double" do
      rexp=Rserve::REXP::Double.new([1.5,-1.5])
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    
    it "should assign a null" do
      rexp=Rserve::REXP::Null.new
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a int vector" do
      rexp=Rserve::REXP::Integer.new([1,2,3])
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a bool vector" do
      rexp=Rserve::REXP::Logical.new([1,0,1])
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a string vector" do
      rexp=Rserve::REXP::String.new(%w{a b c})
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a list without names" do
      rexp=Rserve::REXP::GenericVector.new(Rserve::Rlist.new([Rserve::REXP::String.new("a")]))
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a list without names and nulls" do
      rexp=Rserve::REXP::GenericVector.new(Rserve::Rlist.new([Rserve::REXP::Null.new]))
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a list with names" do
      x=@r.eval("list(a=TRUE)")
      @r.assign("x",x)
      @r.eval("x").should==x
    end
    it "should assign a data.frame" do
      x=@r.eval("data.frame(a=rnorm(100),b=rnorm(100))")
      @r.assign("x",x)
      @r.eval("x").should==x
    end
    it "should assign a matrix" do
      x=@r.eval("matrix(1:9,3,3)")
      @r.assign("x",x)
      @r.eval("x").should==x
      
    end
    after do
      @r.void_eval("rm(x)")
    end
  end
end
