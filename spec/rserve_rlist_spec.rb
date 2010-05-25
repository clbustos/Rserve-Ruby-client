require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve::Rlist do
  before do
    @r=Rserve::Connection.new
    @l=@r.eval("list(name='Fred',age=30,10,20,kids=c(1,2,3))").as_list
  end
  it "method names return correct names" do
    @l.names.should==['name','age',"","","kids"]
  end
  it "method == should return true for rlist with equal data and names" do
    a=Rserve::Rlist.new([1,2,3],%w{a b c})
    b=Rserve::Rlist.new([1,2,3],%w{a b c})
    (a==b).should be_true
    a=Rserve::Rlist.new([1,2,3],%w{a b c})
    b=Rserve::Rlist.new([1,2,3])
    (a==b).should be_false
    a=Rserve::Rlist.new([1,2,3],%w{a b c})
    b=Rserve::Rlist.new([4,5,6],%w{c d e})
    (a==b).should be_false
    
  end
  it "method [] return correct values for strings" do
    @l['name'].to_ruby.should=='Fred'
    @l['age'].to_ruby.should==30
    @l['kids'].to_ruby.should==[1,2,3]
  end
  it "method [] return correct values for integers (0-based)" do
    @l[2].to_ruby.should==10
    @l[3].to_ruby.should==20
  end
  it "method to_a return an array with best ruby representation of data" do
    @l.to_a.should==['Fred',30,10,20,[1,2,3]]
  end
  it "method to_ruby returns a hash when all names are set" do
    list=@r.eval("list(name='Fred', age=30)")
    list.to_ruby.should=={'name'=>'Fred','age'=>30}
  end
  it "method to_ruby returns a hash with numbers (1-based) replacing empty names" do
    list=@r.eval("list(name='Fred', age=30,'aaaa')")
    list.to_ruby.should=={'name'=>'Fred','age'=>30,3=>'aaaa'}
  end
  it "method to_ruby returns an array when no names are set" do
    list=@r.eval("list(10,20,30)")
    list.to_ruby.should==[10,20,30]
  end
  it "should allow recursive list" do
    list=@r.eval("list(l1=list(l11=1,l22=2),l2=list(3,4))").as_list
    list['l1'].to_ruby.should=={'l11'=>1,'l22'=>2}
    list['l2'].to_ruby.should==[3,4]
    
  end
end
