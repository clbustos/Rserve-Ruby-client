require File.dirname(__FILE__)+"/spec_helper.rb"
describe Rserve::Connection do
   it "should be open a connection and receive ID-String" do
     @r=Rserve::Connection.new()
     @r.server_version.should=="0103"
     @r.protocol.should=="QAP1"
   end
end
