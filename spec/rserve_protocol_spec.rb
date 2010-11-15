require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::Protocol do
  before do
    @t=Object.new
    @t.extend Rserve::Protocol
  end
  it "set_int method should set an integer correctly on an array of bytes" do
    bytes=[0,0,0,0,0,0,0]
    v=1000
    @t.set_int(v, bytes, 2)
    bytes.should==[0,0,232,3,0,0,0]
  end
  it "set_hdr method should set correctly the header for len<0xFFFFFF" do
    bytes=[0]*8
    cmd=Rserve::Protocol::CMD_login
    len=0x123456
    offset=0
    expected=[cmd,0x56,0x34,0x12,0,0,0,0]

    @t.set_hdr(cmd,len,bytes,offset)

    bytes.should==expected
  end
  it "set_hdr method should set correctly the header for len>0xFFFFFF" do
    bytes=[0]*8
    cmd=Rserve::Protocol::CMD_login
    len=0x12345678
    offset=0
    expected=[cmd|Rserve::Protocol::DT_LARGE,0x78,0x56,0x34,0x12,0,0,0]
    @t.set_hdr(cmd,len,bytes,offset)
    bytes.should==expected
  end
  it "new_hdr method should return a correct header for different lengths" do
    cmd=Rserve::Protocol::CMD_login
    len=0x123456
    expected=[cmd,0x56,0x34,0x12]
    @t.new_hdr(cmd,len).should==expected
    len=0x12345678
    expected=[cmd|Rserve::Protocol::DT_LARGE,0x78,0x56,0x34,0x12,0,0,0]
    @t.new_hdr(cmd,len).should==expected
  end
  it "get_int method should return a correct integer for a given buffer" do
    buffer=[0xFF,0x78,0x56,0x34,0x12]
    expected=0x12345678
    @t.get_int(buffer,1).should==expected
    @t.get_int(buffer,1).should==@t.get_int_original(buffer,1)

    # Version with errors

    buffer=[0xFF,0xFF78,0xFF56,0xFF34,0xFF12]
    expected=0x12345678
    @t.get_int(buffer,1).should==expected
  end
  
  
  
  it "get_len method should return correct length from a header" do
    cmd=Rserve::Protocol::CMD_login
    len=0x12345678
    header=@t.new_hdr(cmd,len)
    @t.get_len(header,0).should==len
  end
  it "get_long method should return correct long(32 bits) for a given buffer" do
    buffer=[0xFF,0x78,0x56,0x34,0x12,0x78,0x56,0x34,0x12]
    expected=0x1234567812345678
    @t.get_long(buffer,1).should==expected
    @t.get_long(buffer,1).should==@t.get_long_original(buffer,1)

  end
  it "set_long method should set correct long(32 bits) for a given buffer" do
    buffer=[0]*9
    long=0x123456789ABCDF45

    @t.set_long(long,buffer,1)
    expected=[0x45,0xDF,0xBC,0x9A,0x78,0x56,0x34,0x12]
    buffer.slice(1,8).should==expected
  end

end
