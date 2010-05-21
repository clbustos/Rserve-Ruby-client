# encoding: UTF-8

require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve::Protocol::REXPFactory do
  before do
    @r=Rserve::Connection.new
  end
  it "should process single logical" do
    la=@r.eval("TRUE")
    la.should be_instance_of(Rserve::REXP::Logical)
    la.true?.should==[true]
  end
  it "should process logical vector" do
    la=@r.eval("c(TRUE,FALSE,TRUE)")
    la.should be_instance_of(Rserve::REXP::Logical)
    la.true?.should==[true,false,true]
  end
  it "should process single double" do
    la=@r.eval("1.5")
    la.should be_instance_of(Rserve::REXP::Double)
    la.as_doubles.should==[1.5]
  end
  it "should process double vector" do
    a=100.times.map{|i| rand()}
    la=@r.eval("c("+a.map(&:to_s).join(",")+")")
    la.should be_instance_of(Rserve::REXP::Double)
    
    la.as_doubles.map(&:to_f).each_with_index {|v,i|
      v.should be_close(a[i],1e-10)
    }
  end
  it "should process char" do
    la=@r.eval("c('abc','def','ghi')")
    la.should be_instance_of(Rserve::REXP::String)
    la.as_strings.should==['abc','def','ghi']
  end
  it "should process list" do
    require 'pp'
    la=@r.eval("list(name='Fred',age=30,10,20,kids=c(1,2,3))")
    la.should be_list
    la.should be_recursive
    la.as_list.names.should==['name','age','','','kids']
  end

end
