require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve::Talk do
  before do
    @iomock=mock('IO Mock')
    @talk=Rserve::Talk.new(@iomock)
  end
  it "should raise an error on incorrect argument" do
    ty=Rserve::Protocol::CMD_shutdown
    lambda {
      @talk.request(:cmd=>ty, :cont=>"no")
    }.should raise_exception()
      
  end
  it "method request should accept only a cmd" do
    ty=Rserve::Protocol::CMD_shutdown
    buf=[0]*16
    @talk.set_int(ty, buf, 0)
    @talk.set_int(0, buf, 4)
    rep=Rserve::Protocol::RESP_OK
    cont="Test content"
    cl=cont.length
    server_response_1=[rep,cl,0,0].pack("IIII")
    server_response_2=cont
    
    @iomock.should_receive(:write).once.with(buf.pack("C*"))
    @iomock.should_receive(:recv).once.with(16).and_return(server_response_1)
    @iomock.should_receive(:recv).once.with(cl).and_return(server_response_2)

    ret=@talk.request(:cmd=>ty)
    ret.should be_instance_of(Rserve::Packet)
    ret.cmd.should==rep
    ret.cont_len.should==cl
    ret.cont.should==cont.unpack("C*")
  end
  it "method request should accept cmd and content" do
    

    ty=Rserve::Protocol::CMD_eval
    buf=[0]*16
    
    es="x<-1020"
    es_len=es.size
    @talk.set_int(ty, buf, 0)
    @talk.set_int(es_len, buf, 4)
    rep=Rserve::Protocol::RESP_OK
    cont=es+"(Response)"
    cl=cont.length
    server_response_1=[rep,cl,0,0].pack("IIII")
    server_response_2=cont
    @iomock.should_receive(:write).once.with(buf.pack("C*"))
    @iomock.should_receive(:write).once.with(es)
    
    @iomock.should_receive(:recv).once.with(16).and_return(server_response_1)
    @iomock.should_receive(:recv).once.with(cl).and_return(server_response_2)
    ret=@talk.request(:cmd=>ty,:cont=>es.unpack("C*"))
    ret.should be_instance_of(Rserve::Packet)
    ret.cmd.should==rep
    ret.cont_len.should==cl
    ret.cont.should==cont.unpack("C*")
    
    
    
  end

end
