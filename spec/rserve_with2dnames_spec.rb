require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
require '../lib/rserve/rexp/string'
require '../lib/rserve/rexp/integer'
require '../lib/rserve/rexp/list'


describe Rserve::With2DNames do

  before do

    # when a 2d object is returned by R as an array
    # the elements are listed column by column
    @array = [1,5,9,2,6,10,3,7,11,4,8,12]
    # corresponds to a matrix like
    # 1  2  3  4
    # 5  6  7  8
    # 9  10 11 12
    @array.extend Rserve::With2DNames
  end

  describe "sizes" do

    context "when passed the correct values" do

      it "should set the size values for rows and columns" do
        @array.sizes = [3,4]
        @array.row_size.should == 3
        @array.column_size.should == 4
      end

    end

    context "when passed the wrong values" do

      it "should throw if the object passed does not have two elements" do
        expect{@array.sizes = [5]}.to raise_error ArgumentError
      end

      it "should throw if the sizes passed do not match the array size" do
        expect{@array.sizes = [1,5]}.to raise_error ArgumentError
      end

    end

  end

  describe "names" do

    context "when passed the correct values" do

      before do
        @array.sizes = [3,4]
      end

      it "should set the names for rows and columns" do
        @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
        @array.row_names.should == %w(r1 r2 r3)
        @array.column_names.should == %w(c1 c2 c3 c4)
      end

    end

    context "when passed the wrong values" do

      it "should throw if the object passed does not have two elements" do
        expect{@array.names = [%w(r1 r2 r3)]}.to raise_error ArgumentError
      end

      it "should throw if the sizes passed do not match the array size" do
        expect{@array.names = [%w(r1 r2 r3 r4),%w(c1 c2 c3 c4)]}.to raise_error ArgumentError
      end

    end

  end

  describe "two_d_at" do

    before do
      @array.sizes = [3,4]
      @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
    end


    it "should return the correct values using integer indices" do
      @array.two_d_at(0,0).should == 1
      @array.two_d_at(2,0).should == 9
      @array.two_d_at(0,3).should == 4
      @array.two_d_at(2,3).should == 12
    end

    it "should return the correct values using names" do
      @array.two_d_at("r1","c2").should == 2
      @array.two_d_at("r2","c1").should == 5
    end


 end



end