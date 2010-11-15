require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::Packet do
  it "should be ok if cmd isn't an error" do
    packet=Rserve::Packet.new(Rserve::Protocol::RESP_OK,[1,2,3,4])
    packet.should be_ok
    packet.should_not be_error
  end
  it "should be error if cmd is an error" do
    packet=Rserve::Packet.new(Rserve::Protocol::RESP_ERR,[1,2,3,4])
    packet.should be_error
    packet.should_not be_ok
  end
  it "method to_s should return coherent to_s" do
    packet=Rserve::Packet.new(Rserve::Protocol::RESP_OK,[1,2,3,4])
    packet.to_s.should match /Packet\[cmd=\d+,\s*len=\d,\s*con='.+',\s*status=.+\]/
  end

end
