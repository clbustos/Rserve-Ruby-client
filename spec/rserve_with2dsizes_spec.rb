require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::With2DSizes do

  before do

    # when a 2d object is returned by R as an array
    # the elements are listed column by column
    @array = [1,5,9,2,6,10,3,7,11,4,8,12]
    # corresponds to a matrix like
    # 1  2  3  4
    # 5  6  7  8
    # 9  10 11 12
    @array.extend Rserve::With2DSizes
  end

  describe "sizes=" do

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

  describe "row" do

    before do
      @array.sizes = [3,4]
    end

    context "when the index is in the valid range" do

      it "should return the correct row" do
        @array.row(0).should == [1, 2, 3, 4]
        @array.row(-1).should == [9, 10, 11, 12]
      end

    end

    context "when the index is out of range" do

      it "should return nil" do
        @array.row(3).should be_nil
        @array.row(-4).should be_nil
      end

    end

  end

  describe "column" do

    before do
      @array.sizes = [3,4]
    end

    context "when the index is in the valid range" do

      it "should return the correct column" do
        @array.column(0).should == [1, 5, 9]
        @array.column(-1).should == [4, 8, 12]
      end

    end

    context "when the index is out of range" do

      it "should return nil" do
        @array.column(4).should be_nil
        @array.column(-5).should be_nil
      end

    end

  end

  describe "at_2d" do

    before do
      @array.sizes = [3,4]
    end


    it "should return the correct values" do
      @array.at_2d(0,0).should == 1
      @array.at_2d(2,0).should == 9
      @array.at_2d(0,3).should == 4
      @array.at_2d(2,3).should == 12
    end

  end

end