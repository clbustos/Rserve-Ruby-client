require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Rserve::Connection do
  describe "opening and closing" do
    before do
      @r=Rserve::Connection.new()
    end
    after do
      @r.close if @r.connected?
    end    
    it "should be open a connection and receive ID-String" do
      @r.get_server_version.should==103
      @r.protocol.should=="QAP1"
      @r.last_error.should=="OK"
      @r.rt.should be_instance_of(Rserve::Talk)
    end
    it "should quit correctly" do
      @r.should be_connected
      @r.close.should be true
      @r.should_not be_connected
      @r.close.should be true
    end
    it "raise an error if eval is clased after closed" do
      @r.close
      lambda {@r.eval("TRUE")}.should raise_exception(Rserve::Connection::NotConnectedError)
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
      @r.void_eval("x<-1").should be true
    end
    
    it "method eval should return a simple object" do
      la=@r.eval("TRUE")
      la.should be_instance_of(Rserve::REXP::Logical)
      la.true?.should==[true]
    end
    
    
    it "should eval_void and eval correctly" do
      @r.void_eval("x<-c(TRUE,FALSE)").should be true
      la=@r.eval("x")
      la.should be_instance_of(Rserve::REXP::Logical)
      la.true?.should==[true,false]
    end
    it "should assign a string" do
      @r.assign("x","a string")
      @r.eval("x").to_ruby.should=="a string"
    end
    it "should assign an array with nils values" do
      
      @r.assign('x',[1.0,2.5,nil])
      @r.eval('x').to_ruby.should==[1.0,2.5,nil]
    end

  end
  describe "assign using REXPs" do
    before do
      @r=Rserve::Connection.new
    end
    after do
	    @r.close
     end
    it "should assign double" do
      rexp=Rserve::REXP::Double.new([1.5,-1.5])
      @r.assign("x", rexp)
      @r.eval("x").should==rexp
    end
    it "should assign a double with nils and set correctly the nils" do
      rexp=Rserve::REXP::Double.new([1.5, Rserve::REXP::Double::NA, -1.5])
      @r.assign("x", rexp)
      @r.eval('is.na(x)').to_ruby.should==[false,true,false]
    end
    it "should assign a integer with nils and set correctly the nils" do
      rexp=Rserve::REXP::Integer.new([1, Rserve::REXP::Integer::NA, 2])
      @r.assign("x", rexp)
      @r.eval('is.na(x)').to_ruby.should==[false,true,false]
    end
    
    
    it "should assign a double with nils and return correct values" do
      rexp=Rserve::REXP::Double.new([1.5,Rserve::REXP::Double::NA, -1.5])
      @r.assign("x", rexp)
      rexp_out=@r.eval("x")
      rexp_out.payload.should==rexp.payload
    end
    it "should assign a integer with nils and return correct values" do
      rexp=Rserve::REXP::Integer.new([1,Rserve::REXP::Integer::NA, 2])
      @r.assign("x", rexp)
      rexp_out=@r.eval("x")
      rexp_out.payload.should==rexp.payload
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
      x=@r.eval("matrix(1:12,6,2)")
      @r.assign("x",x)
      @r.eval("x").should==x
    end
    it "should assign a ruby matrix" do
      mat_ruby=Matrix[[1,7],[2,8],[3,9],[4,10],[5,11],[6,12]]
      @r.assign('x',mat_ruby)
      x=@r.eval('x')
      y=@r.eval('y<-matrix(c(1,2,3,4,5,6,7,8,9,10,11,12),6,2)')
      #p x.attr.to_ruby
      x.as_floats.should==y.as_floats
      x.attr.as_list['dim'].should==y.attr.as_list['dim']
      x.to_ruby.should==mat_ruby
    end
    
    after do
      @r.void_eval("rm(x)")
    end
  end
end
