require File.dirname(__FILE__)+"/spec_helper.rb"
describe Rserve::Connection do
   describe "opening and closing" do
     it "should be open a connection and receive ID-String" do
       @r=Rserve::Connection.new()
       @r.get_server_version.should==103
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
     after do
       @r.close if @r.connected?
     end
   
 end
 describe "basic eval methods" do
    before do
      @r=Rserve::Connection.new
    end
    it "should eval_void correctly" do
      @r.void_eval("x<-1").should be_true
    end
    it "should eval correctly" do
      la=@r.eval("c(TRUE,TRUE,FALSE,FALSE)")
      la.should be_instance_of(Rserve::REXP::Logical)
      la.true?.should==[true,true,false,false]
    end
    it "should eval_void and eval correctly" do
      @r.void_eval("x<-c(TRUE,FALSE)").should be_true
      la=@r.eval("x")
      la.should be_instance_of(Rserve::REXP::Logical)
      la.true?.should==[true,false]      
      
    end
  end
end
