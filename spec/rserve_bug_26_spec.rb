require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  describe "Bug Error handling NA values on integer matrix #26" do
    before do
      @r=Rserve::Connection.new()
    end
    after do
      @r.close if @r.connected?
    end
    it "should return a correct Matrix" do

    @r.eval("m<-matrix(as.integer(c(1, NA, NA, 4)), ncol=2)")
    
    @m=@r.eval('m').to_ruby
    @m.should be_instance_of(Matrix)
    expect(@m).to eq(Matrix[[1,nil],[nil,4]])
    end
end
