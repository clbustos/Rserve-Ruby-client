require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve::REXP::Double do
  describe "initialization" do
    it "should accept array as payload" do
      payload=[1,2,3]
      a=Rserve::REXP::Double.new(payload)
      a.payload.should==payload.map(&:to_f)
    end
    it "should accept float as payload" do
      payload=1.1
      a=Rserve::REXP::Double.new(payload)
      a.payload.should==[1.1]
    end
    
    
    
  end
  describe "NA management" do
    before do
      @payload=[3,5,Rserve::REXP::Double::NA, 10,20]
      @a=Rserve::REXP::Double.new(@payload)
    end
    
    it "method na? should return coherent answer" do
      @a.na?(@a.as_integers[0]).should be_false
      @a.na?(@a.as_integers[2]).should be_true
      @a.na?.should==[false,false,true,false,false]
    end
    it "to_a should return correct values with NA" do
      @a.to_a.should==[3,5, nil, 10, 20]
    end
    it "to_ruby should return correct values with NA" do
      @a.to_ruby.should==[3,5, nil, 10, 20]
    end
  end
  describe "common methods" do
    before do
      @n=rand(10)+10
      @payload=@n.times.map {rand(10).to_f}
      @a=Rserve::REXP::Double.new(@payload)
    end
    subject {@a}
    it "should return correct length of payload" do
      @a.length.should==@n
    end
    it {should be_numeric}
    it {should be_integer}
    it "method as_integer should return payload as integers" do
      @a.as_integers.should==@payload.map(&:to_i)
    end
    it "method as_doubles should return floats" do
      @a.as_doubles.should==@payload
    end
    it "method as_strings should return strings" do
      @a.as_strings.should==@payload.map(&:to_s)
    end
    
    
    it "method to_debug_string and to_s returns a coherent response" do
      @a.to_debug_string.size.should>0
      @a.to_s.size.should>0
      
    end
    end
  
  
end
