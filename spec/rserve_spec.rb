require File.dirname(__FILE__)+"/spec_helper.rb"

describe Rserve do
  before do
     @r=Rserve::Connection.new()
  end
  it "should calcule a basic LR without hazzle" do
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
@r.eval('severity.lm').should be_true
@r.eval('summary(severity.lm)').should be_true


  end

end
