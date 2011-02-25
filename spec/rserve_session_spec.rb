require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Rserve::Session do
  if !Rserve::ON_WINDOWS
    before do
      @r=Rserve::Connection.new
    end
    after do
      @r.close if @r.connected?
    end    

    it "should resume an detached session with void_eval_detach" do
        x2=10+rand(12)
        s=@r.void_eval_detach("x<-1:#{x2}")
        r=Rserve::Connection.new
        r.void_eval("x<-1")
        r.eval("x").to_ruby.should==1
        s.should be_instance_of(Rserve::Session)
        r2=s.attach
        r2.eval("x").to_ruby.should==(1..x2).to_a
      end
    it "should resume an detached session with detach" do
        x2=10+rand(12)
        @r.void_eval("x<-1:#{x2}")
        s=@r.detach
        r=Rserve::Connection.new
        r.void_eval("x<-1")
        r.eval("x").to_ruby.should==1
        s.should be_instance_of(Rserve::Session)
        r2=s.attach
        r2.eval("x").to_ruby.should==(1..x2).to_a
    end
  else
    it "shouldn't work with sessions on windows"
  end    
end