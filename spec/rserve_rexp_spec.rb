require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::REXP do
  before do
    @r=Rserve::Connection.new
  end
  describe "with matrix" do
    before {@m=@r.eval('matrix(c(1,2,3,4,5,6,7,8,9), 3,3)') }
    it "method as_integers should return correct values for original vector" do
      @m.as_integers.should==[1,2,3,4,5,6,7,8,9] # verification
    end
    it "method dim should return correct dimensions" do
      @m.dim.should==[3,3]
    end
    it "method as_double_matrix returns a valid double matrix" do
      @m.as_double_matrix.should==[[1,4,7],[2,5,8],[3,6,9]]
    end
    it "method as_matrix returns a valid standard library matrix" do
      @m=@r.eval('matrix(c(1,2,3,4,5,6,7,8,9), 3,3)')
      @m.as_matrix.should==Matrix[[1,4,7],[2,5,8],[3,6,9]]
    end
    it "method split_array returns a valid splitted array" do
      @m.as_double_matrix.should==@m.as_nested_array
      @r.void_eval("a=1:16; attr(a,'dim')<-c(2,2,2,2)")
      a=@r.eval("a")
      a.as_nested_array.should==[[[[1.0, 3.0], [2.0, 4.0]], [[5.0, 7.0], [6.0, 8.0]]],
 [[[9.0, 11.0], [10.0, 12.0]], [[13.0, 15.0], [14.0, 16.0]]]]
      
    end
  end
  describe "common methods" do
    before do
      @v=@r.eval("c(1.5,2.5,3.5)")
      @l=@r.eval("list(at='val')")
    end
    it "method as_integer should return first value as integer" do
      @v.as_integer.should==1
    end
    it "method as_double should  return first value as float" do
      @v.as_double.should==1.5
    end
    it "method as_string should return first value as string (float representation)" do
      @v.as_string.should=="1.5"
    end
    it "method has_attribute? should return false for non-lists" do
      @v.has_attribute?('randomattribute').should be false
    end
    it "method has_attribute? should return true for existing value" do
      @l.has_attribute?('names').should be true
    end
    it "method has_attribute? should return false for non existing value" do
      @l.has_attribute?('at2').should be false
    end
    it "method get_attribute should return correct value for attribute" do
      @l.get_attribute('names').as_strings.should==['at']
    end
    it "method create_data_frame should create a valid data frame" do
      l=Rserve::Rlist.new([Rserve::REXP::Integer.new([1,2,3,4,5,6,7,8,9,10])],['a'])
      @r.assign "b", Rserve::REXP.create_data_frame(l)
      b=@r.eval("b")
      b.attr.as_list['class'].as_string.should=='data.frame'
      b.attr.as_list['row.names'].as_integers.should==[Rserve::REXP::Integer::NA, -10]
      b.attr.as_list['names'].as_strings.should==['a']      
      
    end
  end

end
