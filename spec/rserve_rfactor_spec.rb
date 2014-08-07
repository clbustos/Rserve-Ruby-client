require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::RFactor do
  before do
    @levels=['a','b','c','d']
    @ids=[1,1,2,2,3,3,4]
    @base_index=1
    @factor=Rserve::RFactor.new(@ids,@levels,false,@base_index)
  end
  it "method size should return number of ids" do
    @factor.size.should==@ids.size
  end
  it "method [] should return correct value (1 based)" do
    @ids.each_index {|i|
      @factor[i].should == @levels[@ids[i]-@base_index]
      @factor[1].should=='a'
      @factor[3].should=='b'
      @factor[5].should=='c'

    }
  end
  it "methods contains? should work with integers and strings" do
    @factor.contains?(1).should be true
    @factor.contains?(5).should be false
    @factor.contains?('a').should be true
    @factor.contains?('z').should be false
  end
  it "methods count should work with integers and strings" do
    @factor.count(2).should==2
    @factor.count(5).should==0
    @factor.count('a').should==2
    @factor.count('z').should==0
  end
  it "method counts_hash should return correct value" do
    @factor.counts_hash.should=={'a'=>2,'b'=>2,'c'=>2,'d'=>1}
  end
  it "method as_integers should return correct values" do
    @factor.as_integers.should==@ids
  end

  it "method as_strings should return correct values" do
    @factor.as_strings==%w{a a b b c c d}
  end

end
