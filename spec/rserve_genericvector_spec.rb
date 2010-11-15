require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::REXP::GenericVector do
  describe "initialization" do
    it "should accept Rlist as payload and create an attrib called 'names'" do
      payload=Rserve::Rlist.new([1,2,3],%w{a b c})
      a=Rserve::REXP::GenericVector.new(payload)
      a.payload.should==payload
      a.attr.as_list['names'].to_ruby.should==%w{a b c}
    end
    it "should accept Rlist and attribs as payload" do
      payload=Rserve::Rlist.new([1,2,3],%w{a b c})
      attribs=Rserve::REXP::List.new(Rserve::Rlist.new([Rserve::REXP::String.new(%w{a b c}), Rserve::REXP::String.new('data.frame')],%w{names class}))
      a=Rserve::REXP::GenericVector.new(payload,attribs)
      a.payload.should==payload
      a.attr.should==attribs
    end
    
  end
end
