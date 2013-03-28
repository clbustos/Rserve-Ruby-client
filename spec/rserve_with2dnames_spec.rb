require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::With2DNames do

  before do

    # when a 2d object is returned by R as an array
    # the elements are listed column by column
    @array = [1,5,9,2,6,10,3,7,11,4,8,12]
    # corresponds to a matrix like
    # 1  2  3  4
    # 5  6  7  8
    # 9  10 11 12
    @array.extend Rserve::With2DSizes
    @array.sizes = [3,4]
    @array.extend Rserve::With2DNames
    @matrix = Matrix[[1,2,3,4],[5,6,7,8],[9,10,11,12]]
    @matrix.extend Rserve::With2DNames
  end

  describe "names=" do

    context "when passed the correct values" do

      it "should set the names for rows and columns for an array" do
        @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
        @array.row_names.should == %w(r1 r2 r3)
        @array.column_names.should == %w(c1 c2 c3 c4)
      end

      it "should set the names for rows and columns for an array" do
        @matrix.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
        @matrix.row_names.should == %w(r1 r2 r3)
        @matrix.column_names.should == %w(c1 c2 c3 c4)
      end

    end

    context "when passing only names for one dimension" do

      before do
        @array.names = [%w(r1 r2 r3), nil]
        @matrix.names = [nil, %w(c1 c2 c3 c4)]
      end

      it "should not assign the missing names" do
        @array.column_names.should be_nil
        @matrix.row_names.should be_nil
      end

    end

    context "when passed the wrong values" do

      it "should throw if the object passed does not have two elements" do
        expect{@array.names = [%w(r1 r2 r3)]}.to raise_error ArgumentError
        expect{@matrix.names = [%w(r1 r2 r3)]}.to raise_error ArgumentError
      end

      it "should throw if the sizes passed do not match the array size" do
        expect{@array.names = [%w(r1 r2 r3 r4),%w(c1 c2 c3 c4)]}.to raise_error ArgumentError
        expect{@matrix.names = [%w(r1 r2 r3 r4),%w(c1 c2 c3 c4)]}.to raise_error ArgumentError
      end

    end

  end

  describe "row_by_name" do

    before do
      @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
      @matrix.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
    end

    context "when the name is present" do

      it "should return the correct row for arrays" do
        @array.row_by_name("r2").should == [5, 6, 7, 8]
      end

      it "should return the correct row as an array for matrices" do
        @matrix.row_by_name("r2").should == [5, 6, 7, 8]
      end

      it "should return a named object" do
        @array.row_by_name("r1").named?.should == true
        @matrix.row_by_name("r1").named?.should == true
      end

    end

    context "when no row names have been assigned" do

      it "should return nil" do
        @array.names = [nil,%w(c1 c2 c3 c4)]
        @matrix.names = [nil,%w(c1 c2 c3 c4)]
        @array.row_by_name("r1").should be_nil
        @matrix.row_by_name("r2").should be_nil
      end

    end

    context "when no column names have been assigned" do

      it "should return a plain (unnamed) array" do
        @array.names = [%w(r1 r2 r3), nil]
        @matrix.names = [%w(r1 r2 r3),nil]
        @array.row_by_name("r1").should_not be_a Rserve::WithNames
        @matrix.row_by_name("r2").should_not be_a Rserve::WithNames
      end

    end

    context "when the index is out of range" do

      it "should return nil" do
        @array.row_by_name("not_there").should be_nil
        @matrix.row_by_name("not_there").should be_nil
      end

    end

  end

  describe "column_by_name" do

    before do
      @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
      @matrix.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
    end

    context "when the name is present" do

      it "should return the correct column for arrays" do
        @array.column_by_name("c1").should == [1, 5, 9]
      end

      it "should return the correct column as an array for matrix" do
        @matrix.column_by_name("c1").should == [1, 5, 9]
      end

      it "should return a named object" do
        @array.column_by_name("c1").named?.should == true
        @matrix.column_by_name("c1").named?.should == true
      end

    end

    context "when no column names have been assigned" do

      it "should return nil" do
        @array.names = [%w(r1 r2 r3), nil]
        @matrix.names = [%w(r1 r2 r3),nil]
        @array.column_by_name("c1").should be_nil
        @matrix.column_by_name("c2").should be_nil
      end

    end

    context "when no row names have been assigned" do

      it "should return a plain (unnamed) array" do
        @array.names = [nil,%w(c1 c2 c3 c4)]
        @matrix.names = [nil,%w(c1 c2 c3 c4)]
        @array.column_by_name("c1").should_not be_a Rserve::WithNames
        @matrix.column_by_name("c2").should_not be_a Rserve::WithNames
      end

    end

    context "when the name is not present" do

      it "should return nil" do
        @array.column_by_name("not_there").should be_nil
        @matrix.column_by_name("not_there").should be_nil
      end

    end

  end

  describe "named_2d?" do

    it "should return false if no names are set" do
      @array.named_2d?.should == false
      @matrix.named_2d?.should == false
    end

    it "should return true if names have been set" do
      @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
      @matrix.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
      @array.named_2d?.should == true
      @matrix.named_2d?.should == true
    end


    it "should return false if only one dimension names are set" do
      @array.names = [%w(r1 r2 r3), nil]
      @matrix.names = [nil, %w(c1 c2 c3 c4)]
      @array.named_2d?.should == false
      @array.named_2d?.should == false
    end

  end

  describe "by_name" do

    before do
      @array.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
      @matrix.names = [%w(r1 r2 r3),%w(c1 c2 c3 c4)]
    end

    it "should return the correct value" do
      @array.by_name("r1","c2").should == 2
      @matrix.by_name("r3","c4").should == 12
    end

    it "should return nil if either of the parameters is not found" do
      @array.by_name("not_there","c1").should be_nil
      @matrix.by_name("r1","not_there").should be_nil

    end

    it "should return nil when either column or row names are set" do
      @array.names = [nil,%w(c1 c2 c3 c4)]
      @matrix.names = [%w(r1 r2 r3),nil]
      @array.by_name("r1","c1").should be_nil
      @matrix.by_name("r1","c1").should be_nil
    end

  end

end