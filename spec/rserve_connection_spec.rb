require File.dirname(__FILE__)+"/spec_helper.rb"
describe Rserve::Connection do
   describe "opening and closing" do
   it "should be open a connection and receive ID-String" do
     @r=Rserve::Connection.new()
     @r.get_server_version.should=="0103"
     @r.protocol.should=="QAP1"
     @r.last_error.should=="OK"
     @r.rt.should be_instance_of(Rserve::Talk)
   end
   it "should quit correctly" do
     @r=Rserve::Connection.new
     @r.should be_connected
     @r.close.should be_true
     @r.should_not be_connected
     @r.close.should be_true
   end
   
 end
 describe "basic eval methods" do
    before do
      @r=Rserve::Connection.new
    end
    it "should eval_void correctly" do
      @r.void_eval("x<-1").should be_true
    end
  end
end
