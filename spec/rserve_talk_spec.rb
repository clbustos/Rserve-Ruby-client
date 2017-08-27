require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve::Talk do
  before do
    @iomock=double('IO Mock')
    @talk=Rserve::Talk.new(@iomock)
  end
  it "method request_string should return a valid string" do
    par="x<-12".unpack("C*")
    buf=[0]*13
    @talk.set_hdr(Rserve::Protocol::DT_STRING,8,buf,0)
    par.each_index {|i| buf[i+4]=par[i]}
    @talk.request_string("x<-12").should==buf
  end
  it "should raise an error on incorrect type of cont" do
    ty=Rserve::Protocol::CMD_shutdown
    lambda {
      @talk.request(:cmd=>ty, :cont=>"no")
    }.should raise_exception()

  end
  it "should behave correctly with cmd as only argument" do
    ty=Rserve::Protocol::CMD_shutdown
    buf=[0]*16
    @talk.set_int(ty, buf, 0)
    @talk.set_int(0, buf, 4)
    rep=Rserve::Protocol::RESP_OK
    cont="Test content"
    cl=cont.length
    server_response_1=[rep,cl,0,0].pack("IIII")
    server_response_2=cont

    expect(@iomock).to receive(:write).once.with(buf.pack("C*"))

    expect(@iomock).to receive(:recv).once.with(16).and_return(server_response_1)
    expect(@iomock).to receive(:recv).once.with(cl).and_return(server_response_2)

    ret=@talk.request(:cmd=>ty)
    ret.should be_instance_of(Rserve::Packet)
    ret.cmd.should==rep
    ret.cont_len.should==cl
    ret.cont.should==cont.unpack("C*")
  end
  it "should behave correctly with cmd and cont as arguments" do


    ty=Rserve::Protocol::CMD_eval
    buf=[0]*16

    es="x<-1020"
    es_proc=@talk.request_string(es).pack("C*")
    es_len=es_proc.size
    @talk.set_int(ty, buf, 0)
    @talk.set_int(es_len, buf, 4)
    rep=Rserve::Protocol::RESP_OK
    cont=es+"(Response)"
    cl=cont.length
    server_response_1=[rep,cl,0,0].pack("IIII")
    server_response_2=cont
    expect(@iomock).to receive(:write).once.with(buf.pack("C*"))
    expect(@iomock).to receive(:write).once.with(es_proc)

    expect(@iomock).to receive(:recv).once.with(16).and_return(server_response_1)
    expect(@iomock).to receive(:recv).once.with(cl).and_return(server_response_2)

    ret=@talk.request(:cmd=>ty,:cont=>es)

    ret.should be_instance_of(Rserve::Packet)
    ret.cmd.should==rep
    ret.cont_len.should==cl
    ret.cont.should==cont.unpack("C*")
  end

end
