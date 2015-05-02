require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
require 'tempfile'

describe Rserve::Connection do
  before(:all) do
    lambda { system "killall Rserve" }.call #clean up any extra Rserves
    password_file = File.expand_path("./data/Rserv.passwords")
    
    plain_config = IO.read('./data/Rserv-plaintext.conf.example')
    plain_config = plain_config + "\npwdfile #{password_file}\n"
    @plain_config_file = Tempfile.new('Rserv-plaintext.conf')
    @plain_config_file.write(plain_config)
    @plain_config_file.flush
    crypt_config = IO.read('./data/Rserv-cryptonly.conf.example')
    crypt_config = crypt_config + "\npwdfile #{password_file}\n"
    @crypt_config_file = Tempfile.new('Rserv-cryptonly.conf')
    @crypt_config_file.write(crypt_config)
    @crypt_config_file.flush
  end
  describe "opening and closing plaintext" do
    before(:all) do
      @r=Rserve::Connection.new(:cmd_init => "R CMD Rserve --RS-conf #{@plain_config_file.path}", :username => "test", :password => "password", :port_number => 6312)
    end
    it "should be open a connection and receive ID-String" do
      @r.get_server_version.should==103
      @r.protocol.should=="QAP1"
      @r.last_error.should=="OK"
      @r.rt.should be_instance_of(Rserve::Talk)
    end
    it "should eval something properly" do
      @r.void_eval("x<-1").should be true
    end
    it "should shut down correctly" do
      @r.should be_connected
      @r.close.should be true
      @r.should_not be_connected
    end
  end
  describe "opening and closing plaintext wrong password" do
    it "should fail to connect" do
      expect {@r=Rserve::Connection.new(:cmd_init => "R CMD Rserve --RS-conf #{@plain_config_file.path}", :username => "test", :password => "wrongpassword", :port_number => 6312)}.to raise_error(Rserve::Connection::IncorrectCredentialsError)
      lambda { system "killall Rserve" }.call #clean up any extra Rserves
    end
  end
  describe "opening and closing crypt" do
    before(:all) do
      @r=Rserve::Connection.new(:cmd_init => "R CMD Rserve --RS-conf #{@crypt_config_file.path}", :username => "test", :password => "password", :port_number => 6313)
    end
    it "should be open a connection and receive ID-String" do
      @r.get_server_version.should==103
      @r.protocol.should=="QAP1"
      @r.last_error.should=="OK"
      @r.rt.should be_instance_of(Rserve::Talk)
    end
    it "should eval something properly" do
      @r.void_eval("x<-1").should be true
    end
    it "should shut down correctly" do
      @r.should be_connected
      @r.close.should be true
      @r.should_not be_connected
    end
  end
  describe "opening and closing crypt wrong password" do
    it "should fail to connect" do
      expect {@r=Rserve::Connection.new(:cmd_init => "R CMD Rserve --RS-conf #{@crypt_config_file.path}", :username => "test", :password => "wrongpassword", :port_number => 6313)}.to raise_error(Rserve::Connection::IncorrectCredentialsError)
      lambda { system "killall Rserve" }.call #clean up any extra Rserves
    end
  end
end