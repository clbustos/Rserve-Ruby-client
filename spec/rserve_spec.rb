require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve do
  before do
     @r=Rserve::Connection.new()
  end
  it "should receive a valid response to valid expression" do
    #response=@r.send(Rserve::CMD_eval, @r.string("1:5"))
    #p response
    #response[:response].should==Rserve::RESP_OK
  end
  it "should receive error on invalid expression" do
    #response=@r.send(Rserve::CMD_eval, @r.string("a|sdsds<-||#@r3"))
    #p response
    #response[:response].should==Rserve::RESP_ERR
  end

end
