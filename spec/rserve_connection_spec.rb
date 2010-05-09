require File.dirname(__FILE__)+"/spec_helper.rb"
describe Rserve::Connection do
   it "should be open a connection and receive ID-String" do
     @r=Rserve::Connection.new()
     @r.server_version.should=="0103"
     @r.protocol.should=="QAP1"
   end
end

describe Rserve::DataPackager do
  before do
    @t=Object.new
    @t.extend Rserve::DataPackager
  end
  it "should pack correctly a string" do
    @t.string("a").should==[Rserve::DT_STRING | (4 << 8), "a", 0,1,1].pack("IACCC")
    @t.string("x<-1").should==[Rserve::DT_STRING | (8 << 8) , "x<-1", 0,1,1,1].pack("IZ4CCCC")
  end
  it "should pack correctly a integer" do
    @t.integer(0x12345678).should==[Rserve::DT_INT | (4<<8) ,0x78,0x56,0x34,0x12].pack("ICCCC")
  end
  it "should pack correctly a char" do
    @t.char(0xFF).should==[Rserve::DT_CHAR | (1<<8), 0xFF].pack("IC")    
  end
  it "should pack correctly a double" do
    @t.double(10200304040.656455).should==[Rserve::DT_DOUBLE | (16<<8) ,10200304040.656455].pack("Id")    
  end
  it "should pack correctly a bytestream" do
    @t.bytestream("aa\0\0aa").should==[Rserve::DT_BYTESTREAM | (6 << 8),"aa\0\0aa"].pack("IZ*")    
  end
  it "should pack correctly a command" do
    com=@t.command(Rserve::CMD_eval, @t.string("list(str=R.version.string,foo=1:10,bar=1:5/2,logic=c(TRUE,FALSE,NA))"))
    expected="030000004c0000000000000000000000044800006c697374287374723d522e76657273696f6e2e737472696e672c666f6f3d313a31302c6261723d313a352f322c6c6f6769633d6328545255452c46414c53452c4e41292900010101"
    com.unpack("H*")[0].should==expected
  end
end
describe Rserve do
  before do
     @r=Rserve::Connection.new()
  end
  it "should receive a valid response to valid expression" do
    response=@r.send(Rserve::CMD_eval, @r.string("1:5"))
    p response
    response[:response].should==Rserve::RESP_OK
  end
  it "should receive error on invalid expression" do
    response=@r.send(Rserve::CMD_eval, @r.string("a|sdsds<-||#@r3"))
    p response
    response[:response].should==Rserve::RESP_ERR
  end

end
