require File.dirname(__FILE__)+"/spec_helper.rb"

describe "Rserve::REXP#to_ruby" do
  describe "method to_ruby" do
    before do
      @r=Rserve::Connection.new
    end
    it "should return a Fixnum with vector with one integer element" do
      @r.eval("1").to_ruby.should==1
    end
    it "should return an array of Fixnum and nils with vector with two or more elements" do
      @r.eval("c(1,2,3,NA)").to_ruby.should==[1,2,3,nil]
    end
    it "should return a rational with vector with one element" do
      @r.eval("c(0.5)").to_ruby.should==1.quo(2)
    end
    it "should return an array of rationals with vector with more than one elements" do
      @r.eval("c(0.5,0.5,NA)").to_ruby.should==[1.quo(2), 1.quo(2),nil]
    end
    it "should return a Ruby Matrix with R matrix" do
      @r.eval("matrix(c(1,2,3,4),2,2)").to_ruby.should==Matrix[[1,3],[2,4]]
    end
    it "should return a nested array of Ruby Matrixes with vector with more than tree dimensions" 
    it "should return a boolean with a logical with one element" do
      @r.eval("TRUE").to_ruby.should be_true
    end
    
    it "should return an array of booleans with a logical with two or more elements" do
      @r.eval("c(TRUE,FALSE,NA)").to_ruby.should==[true,false,nil]
    end
    
    it "should return a string with a vector with one string" do
      @r.eval("'a'").to_ruby.should=='a'
    end
    it "should return an array of strings with a vector with two or more strings" do
      @r.eval("c('a','b',NA)").to_ruby.should==['a','b',nil]
    end
    it "should return an array extended with Rserve::WithNames for a list" do
      expected=[1,2,3].extend Rserve::WithNames
      expected.names=%w{a b c}
      @r.eval('list(a=1,b=2,c=3)').to_ruby.should==expected
    end
  end
end
