require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::REXP::Integer do
  describe "initialization" do
    it "should accept array as payload" do
      payload=[0,1,0]
      a=Rserve::REXP::Logical.new(payload)
      a.payload.should==payload
    end
    it "should accept a single value as payload" do
      payload=1
      a=Rserve::REXP::Logical.new(payload)
      a.payload.should==[ Rserve::REXP::Logical::TRUE ]
    end
  end
  describe "NA management" do
    before do
      @payload=[1,Rserve::REXP::Logical::NA, 0]
      @a=Rserve::REXP::Logical.new(@payload)

    end
    it "method is_NA should return coherent answer" do
      @a.na?.should==[false,true,false]
      @a.na?(@a.as_bytes[0]).should be false
      @a.na?(@a.as_bytes[1]).should be true
    end
    it "method to_a should return correct answer" do
      @a.to_a.should==[true,nil,false]
    end
  end
  describe "common methods" do
    before do
      @n=rand(100)
      @payload=@n.times.map {rand(2)}
      @a=Rserve::REXP::Logical.new(@payload)
    end
    subject {@a}
    it "should return correct length of payload" do
      @a.length.should==@n
    end
    it {should be_logical}
    it "method as_bytes should return payload" do
      @a.as_bytes.should==@payload
    end
    it "method as_integer should return integers" do
      @a.as_integers.should==@payload.map {|v| v==Rserve::REXP::Logical::TRUE ? 1 : 0}
    end
    it "method as_doubles should return floats" do
      @a.as_doubles.should==@payload.map {|v| v==Rserve::REXP::Logical::TRUE ? 1.0 : 0.0}
    end
    it "method as_string should return string" do
      @a.as_strings.should==@payload.map {|v| v==Rserve::REXP::Logical::TRUE ? "TRUE" : "FALSE"}
    end
    it "method true? should return an array with true for TRUE values" do
      @a.true?.should==@payload.map {|v| v==Rserve::REXP::Logical::TRUE ? true :false}
    end
    it "method false? should return an array with true for FALSE values" do
      @a.false?.should==@payload.map {|v| v==Rserve::REXP::Logical::FALSE ? true :false}
    end


    it "method to_debug_string and to_s returns a coherent response" do
      @a.to_debug_string.size.should>0
      @a.to_s.size.should>0

    end
  end


end
