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
    
    it "should return an array of Fixnum with an enumeration" do
      @r.eval("1:10").to_ruby.should==[1,2,3,4,5,6,7,8,9,10]
    end
    it "should return an array of String with a factor" do
      @r.eval("factor(c(NA,'a','b','b','c'))").to_ruby.should==[nil]+%w{a b b c}
    end
    it "should return an array of String and nils with a factor with NA" do
      @r.eval("factor(c('a','a','b','b','c'))").to_ruby.should==%w{a a b b c}
    end
    
    it "should return a rational with vector with one element" do
      @r.eval("c(0.5)").to_ruby.should==1.quo(2)
    end
    it "should return an array of rationals with vector with more than one elements" do
      @r.eval("c(0.5,0.5,NA)").to_ruby.should==[1.quo(2), 1.quo(2),nil]
    end
    it "should return an object with module WithAttributes included, when attributes are set" do
      @r.void_eval("a<-c(1,2,3);attr(a,'names')<-c('a','b','c');")
      a=@r.eval("a").to_ruby
      a.attributes.names.should==['names']
      a.attributes['names'].should==%w{a b c}
    end
    it "should return a Ruby Matrix with R matrix" do
      @r.eval("matrix(c(1,2,3,4),2,2)").to_ruby.should==Matrix[[1,3],[2,4]]
    end
    it "should return a nested array of Ruby Matrixes with vector with more than tree dimensions"  do
      @r.void_eval("a<-1:16; attr(a,'dim')<-c(2,2,2,2)")
      @r.eval("a").to_ruby.should==[[[[1.0, 3.0], [2.0, 4.0]], [[5.0, 7.0], [6.0, 8.0]]],
 [[[9.0, 11.0], [10.0, 12.0]], [[13.0, 15.0], [14.0, 16.0]]]]
      
    end
    it "should return a boolean with a logical with one element" do
      @r.eval("TRUE").to_ruby.should be_true
    end
    it "should return an array extended with Rserve::WithNames if vector is named" do
      @r.void_eval("a<-c(1,2,3);names(a)<-c('a','b','c')")
      v=@r.eval('a').to_ruby
      v.names.should==['a','b','c']
      v[0].should==1
      v['a'].should==1
      
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
    it "should return an array extended with Rserve::WithNames and Rserve::WithAttributes for a list" do
      expected=[1,2,3].extend Rserve::WithNames
      expected.names=%w{a b c}
      list=@r.eval('list(a=1,b=2,c=3)').to_ruby
      list.names.should==expected.names
      list.attributes['names'].should==%w{a b c}
    end
    it "should return a data.frame as an array with Rserve::WithNames and Rserve::WithAttributes" do
      df=@r.eval('data.frame(a=1:10)').to_ruby
      df['a'].should==[1,2,3,4,5,6,7,8,9,10]
      df.attributes['names'].should==['a']
      df.attributes['row.names'].should==[1,2,3,4,5,6,7,8,9,10]
      df.attributes['class'].should=='data.frame'
      
    end
  end
end
