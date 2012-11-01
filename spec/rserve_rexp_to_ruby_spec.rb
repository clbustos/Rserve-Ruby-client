require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe "Rserve::REXP#to_ruby" do
  describe "method to_ruby" do
    before do
      @r=Rserve::Connection.new
    end

    after do
      @r.close
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
      @r.eval("matrix(c(1:12),6,2)").to_ruby.should==Matrix[[1,7],[2,8],[3,9],[4,10],[5,11], [6,12]]
    end
    it "should return a Ruby Matrix with R matrix with NA values" do
      @r.eval("matrix(c(NA,2,3,4),2,2,byrow=TRUE)").to_ruby.should==Matrix[[nil,2],[3,4]]
    end
    it "should return a nested array of Ruby Matrixes with vector with more than tree dimensions"  do
      @r.void_eval("a<-1:16; attr(a,'dim')<-c(2,2,2,2)")
      @r.eval("a").to_ruby.should==[[[[1.0, 3.0], [2.0, 4.0]], [[5.0, 7.0], [6.0, 8.0]]],
 [[[9.0, 11.0], [10.0, 12.0]], [[13.0, 15.0], [14.0, 16.0]]]]
    end
    it "should return an empty Matrix with a matrix with a 0 dim" do
      @r.void_eval("a<-as.matrix(numeric(0))")
      @r.eval("a").to_ruby.should==Matrix[]
      
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

    context "when passing a 2d object" do

      let :two_d_object do
        col_names = Rserve::REXP::String.new(%w((Intercept) x1 x2 x3), nil)
        row_names = Rserve::REXP::String.new(%w(1 2 3), nil)
        names_list = Rserve::Rlist.new([row_names, col_names])
        names_vector = Rserve::REXP::GenericVector.new(names_list)
        dim_array = [3,4]
        dimensions = Rserve::REXP::Integer.new(dim_array)
        attr_payload = Rserve::Rlist.new([dimensions, names_vector], %w(dim dimnames))
        attr_list = Rserve::REXP::List.new(attr_payload)
        payload = [true, true, true, true, true, true, false, true, true, false, false, true]
        Rserve::REXP::Logical.new(payload, attr_list)
      end

      before do
        @two_d_array = two_d_object.to_ruby
      end

      it "should return a 2d object as an array with Rserve;;With2DNames" do
        @two_d_array.should be_an Array
        @two_d_array.should be_a Rserve::With2DNames
      end

      it "should set the row and column labels" do
        @two_d_array.row_names.should == %w(1 2 3)
        @two_d_array.column_names.should == %W((Intercept) x1 x2 x3)
      end

      it "should set the row and column sizes" do
        @two_d_array.row_size.should == 3
        @two_d_array.column_size.should == 4
      end

    end

  end
end
