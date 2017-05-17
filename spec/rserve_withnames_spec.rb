require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::WithNames do
  before do
    @a=[1,2,3,4]
    @a.extend Rserve::WithNames
  end
    it "should return nil without names" do
      @a.names.should be_nil
    end
  describe "with incorrect naming" do
    it "should raise an error with names array of another size" do
      lambda {@a.names=["1","2"]}.should raise_exception(ArgumentError)
    end
    it "should raise an error with names array !(String or nil)  " do
      lambda {@a.names=[1,"a","b","c"]}.should raise_exception(ArgumentError)
      lambda {@a.names=[nil,"a","b","c"]}.should_not raise_exception
    end
  end
  describe "correct naming" do
    before do
      @a.names=['a','b','c',nil]
    end
    it "should set names and return them without problems" do
      @a.names.should==['a','b','c',nil] 
    end
    it "should return correct values with 0-index([x])" do
      @a[0].should==1
      @a[3].should==4
    end
    it "should return correct values with 1-index syntactic sugar ([[x]])" do
      @a[[1]].should==1
      @a[[4]].should==4
    end
    it "should return with names(['x'])" do
      @a['a'].should==1
      @a['b'].should==2
    end
    it "should set values with numeric indexes" do
      @a[0]=10
      @a.should==[10,2,3,4]
    end
    it "should set values with string indexes" do
      @a['a']=10
      @a.should==[10,2,3,4]
      @a.put('b',20)
      @a.should==[10,20,3,4]
    end

    it "should push with or without name" do
      @a.push(5)
      @a.names.should==['a','b','c',nil,nil]
      @a.push(6,'f')
      @a.names.should==['a','b','c',nil,nil,'f']
    end
    it "method clear should delete names" do
      @a.clear
      @a.names.should be_nil
    end
    it "should delete_at names" do
      @a.delete_at(0)
      @a.should==[2,3,4]
      @a.names.should==["b","c",nil]
    end
    it "should pop names" do
      @a.pop
      @a.names.should==['a','b','c']
    end
    it "should shift names" do
      @a.shift
      @a.names.should==['b','c',nil]
    end
    it "should reverse! names" do
      @a.reverse!
      @a.names.should==[nil,'c','b','a']
    end
    it "should slice names" do
      b=@a.slice(1,2)
      b.should==[2,3]
      b.names.should==['b','c']
    end
  end  
  
end
