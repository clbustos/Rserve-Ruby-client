require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Rserve do
  before do
    @r=Rserve::Connection.new()
  end
  after do
	  @r.close if @r.connected?
  end
  it "should calcule a basic gml(logit) without problem" do
    script=<<-EOF
a<-c(1,3,2,5,3,2,6,7,8,5,9,3,10,5,2,6,8,4,3,7)
b<-c(7,5,3,7,2,7,4,3,7,5,7,8,4,3,3,6,7,4,3,10)
y<-c(0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1)
logit<-glm(y~a+b, family=binomial(link="logit"), na.action=na.pass)
    EOF
    @r.void_eval(script)
    @r.eval('logit').should be_instance_of(Rserve::REXP::GenericVector)   
    @r.eval('logit$family$variance').should be_truthy
    @r.eval('logit').should be_truthy
    @r.eval('logit').to_ruby.should be_truthy
    @r.eval('summary(logit)').should be_truthy
    @r.eval('summary(logit)').to_ruby.should be_truthy
  end
  
  it "should calcule lr without problem" do
    script=<<-EOF
## Disease severity as a function of temperature

# Response variable, disease severity
diseasesev<-c(1.9,3.1,3.3,4.8,5.3,6.1,6.4,7.6,9.8,12.4)

# Predictor variable, (Centigrade)
temperature<-c(2,1,5,5,20,20,23,10,30,25)
## For convenience, the data may be formatted into a dataframe
severity <- as.data.frame(cbind(diseasesev,temperature))

## Fit a linear model for the data and summarize the output from function lm()
severity.lm <- lm(diseasesev~temperature,data=severity)
    EOF
    @r.void_eval(script)
    temp = @r.eval('severity.lm')
    @r.eval('severity.lm').should be_instance_of(Rserve::REXP::GenericVector)
    @r.eval('severity.lm').to_ruby.should be_truthy
    @r.eval('summary(severity.lm)').should be_truthy
    @r.eval('summary(severity.lm)').to_ruby.should be_truthy
  end

end
