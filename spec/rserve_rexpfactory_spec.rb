# encoding: UTF-8

require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve::Protocol::REXPFactory do
  before do
    @r=Rserve::Connection.new
  end
  it "should process null" do
    la=@r.eval("NULL")
    la.should be_instance_of(Rserve::REXP::Null)
  end
  it "should process single logical" do
    la=@r.eval("TRUE")
    la.should be_instance_of(Rserve::REXP::Logical)
    la.true?.should==[true]
  end
  it "should process array" do
    @r.void_eval("a<-c(1,2,3,4,5,6,7,8); attr(a,'dim')<-c(2,2,2)")
    la=@r.eval("a")
    la.dim.should==[2,2,2]
  end
  it "should process logical vector" do
    la=@r.eval("c(TRUE,FALSE,TRUE)")
    la.should be_instance_of(Rserve::REXP::Logical)
    la.true?.should==[true,false,true]
  end
  it "should process logical vectors with NA" do
    la=@r.eval("c(TRUE,NA)")
    la.should be_instance_of(Rserve::REXP::Logical)
    la.na?.should==[false,true]    
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
    la.dim.should be_nil
    la.as_doubles.map(&:to_f).each_with_index {|v,i|
      v.should be_close(a[i],1e-10)
    }
  end
  it "should process double vector with NA" do
    la=@r.eval("c(1,NA)")
    la.should be_instance_of(Rserve::REXP::Double)
    la.na?.should==[false,true]
    
  end
  it "should process string vector" do
    la=@r.eval("c('abc','def','ghi')")
    la.should be_instance_of(Rserve::REXP::String)
    la.as_strings.should==['abc','def','ghi']
  end
  it "should process string vector with NA" do
    la=@r.eval("c('abc','def',NA)")
    la.should be_instance_of(Rserve::REXP::String)
    la.na?.should==[false,false,true]

  end
  describe "factor processing" do
    it "should process factor without NA" do
      la=@r.eval <<-EOF
      state <- c("tas", "sa",  "qld", "nsw", "nsw", "nt",  "wa",  "wa",
                    "qld", "vic", "nsw", "vic", "qld", "qld", "sa",  "tas",
                    "sa",  "nt",  "wa",  "vic", "qld", "nsw", "nsw", "wa",
                    "sa",  "act", "nsw", "vic", "vic", "act");
      statef <- factor(state)
      EOF
      la.should be_factor
      la.as_factor.levels.sort.should==%w{act nsw nt  qld sa tas vic wa}.sort
  
      la.as_factor.contains?("tas").should be_true
      la.as_factor.contains?("nn").should be_false
      @r.void_eval("rm(state, statef)")
    end
    it "should process factors with NA" do
      @r.void_eval "other<-c('a','a','b','b',NA)"
      la=@r.eval("factor(other)")
      la.as_strings.should==['a','a','b','b',nil]
      la.as_factor.levels.sort.should==['a','b']
    end
  end
  it "should process list" do
    require 'pp'
    la=@r.eval("list(name='Fred',age=30,10,20,kids=c(1,2,3))")
    la.should be_list
    la.should be_recursive
    la.as_list.names.should==['name','age','','','kids']

  end

end
