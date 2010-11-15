require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
require 'matrix'
describe Rserve::REXP::Wrapper do
  it "should wrap single value" do
    Rserve::REXP::Wrapper.wrap(1).should==Rserve::REXP::Integer.new(1)
    Rserve::REXP::Wrapper.wrap(1.0).should==Rserve::REXP::Double.new(1.0)
    Rserve::REXP::Wrapper.wrap(true).should==Rserve::REXP::Logical.new(1)
    Rserve::REXP::Wrapper.wrap("a").should==Rserve::REXP::String.new("a")
  end
  it "should wrap arrays of a single type" do
    Rserve::REXP::Wrapper.wrap([1,2]).should==Rserve::REXP::Integer.new([1,2])
    Rserve::REXP::Wrapper.wrap([1.0,2]).should==Rserve::REXP::Double.new([1.0,2.0])
    Rserve::REXP::Wrapper.wrap([true,false]).should==Rserve::REXP::Logical.new([1,0])
    Rserve::REXP::Wrapper.wrap(["a","b"]).should==Rserve::REXP::String.new(["a","b"])
  end
  it "should wrap a standard library matrix" do 
    mat=Matrix[[1,2],[3,4]]
    expected=Rserve::REXP::Double.new([1,3,2,4], Rserve::REXP::List.new( Rserve::Rlist.new( 
      [
      Rserve::REXP::String.new('matrix'),
      Rserve::REXP::Integer.new([2,2])
      ],
      ['class','dim']
      )
     )
    )
    Rserve::REXP::Wrapper.wrap(mat).should==expected
  end
  
  it "should wrap on a list mixed values" do
    r=Rserve::Connection.new
    Rserve::REXP::Wrapper.wrap([1,2.0,false,"a"]).should==
    Rserve::REXP::GenericVector.new(
    Rserve::Rlist.new([
      Rserve::REXP::Integer.new(1),
      Rserve::REXP::Double.new(2.0),
      Rserve::REXP::Logical.new(0),
      Rserve::REXP::String.new("a"),

    ])
    )
  end
  it "should wrap arrays with nil values using NA values of specific type" do
    Rserve::REXP::Wrapper.wrap([1,nil]).should==Rserve::REXP::Integer.new([1,Rserve::REXP::Integer::NA])
    Rserve::REXP::Wrapper.wrap([1.0,nil]).should==Rserve::REXP::Double.new([1.0,Rserve::REXP::Double::NA])
    Rserve::REXP::Wrapper.wrap([true,nil]).should==Rserve::REXP::Logical.new([1,Rserve::REXP::Logical::NA])
    Rserve::REXP::Wrapper.wrap(["a",nil]).should==Rserve::REXP::String.new(["a", Rserve::REXP::String::NA])
  end
end
