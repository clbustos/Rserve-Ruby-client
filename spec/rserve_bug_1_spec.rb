require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  describe "Bug #1 on statsample" do 
    before do
      @r=Rserve::Connection.new()
    end
    after do
      @r.close if @r.connected?
    end
    it "should return a correct irr object" do

    @r.void_eval("
    if(!require('irr')) {
       install.packages('irr',repos='https://cloud.r-project.org',quiet=TRUE);
    }
    library(irr)
    ds<-data.frame(a=rnorm(100),b=rnorm(100),c=rnorm(100),d=rnorm(100));
    iccs=list(
    icc_1=icc(ds,'o','c','s'),
    icc_k=icc(ds,'o','c','a'),
    icc_c_1=icc(ds,'t','c','s'),
    icc_c_k=icc(ds,'t','c','a'),
    icc_a_1=icc(ds,'t','a','s'),
    icc_a_k=icc(ds,'t','a','a'))
    ")
    
    @iccs=@r.eval('iccs').to_ruby
    @iccs.should be_instance_of(Array)
    end
end
