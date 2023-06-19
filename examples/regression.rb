# As another example of Ruby Rserve client, extracted from RinRuby documentation, consider the usage of Ruby Rserve client for simple linear regression below. The simulation parameters are deﬁned in Ruby, computations are performed in R, and Ruby reports the results. In a more eloborate application, the simulation parameter might come from input from a graphical user interface, the statistical analysis might be more involved, and the results might be an HTML page or PDF report.

require 'rserve'
r=Rserve::Connection.new
n = 10
beta_0 = 1
beta_1 = 0.25
alpha = 0.05
seed = 23423

# You could assign a ruby object to a R variable automaticly. You could see 
# the rules of translation on Rserve::REXP::Wrapper module 
r.assign "x", (1..n).entries

# Rserve::Connection.void_eval allows you to send complex R commands
# without wasting time retrieving the final result

r.void_eval <<EOF
 set.seed(#{seed})
 y <- #{beta_0} + #{beta_1}*x + rnorm(#{n})
 fit <- lm( y ~ x )
 est <- round(coef(fit),3)
 pvalue <- summary(fit)$coefficients[2,4]
EOF

# Rserve::Connecttion.eval retrieve a Rserve::REXP object, which could
# be translated to an appropiate Ruby object using Rserve::REXP.to_ruby method
#
est=r.eval("est").to_ruby

# fit$coef is a named doubles vector, so the respective Ruby object is an
# array of rational extended with module WithNames. That allows us
# to retrieve every element of the vector by its name

puts "E(y|x) ~= #{est['(Intercept)'].to_f} + #{est['x'].to_f} * x"

# fit$pvalue is a vector of size 1. So, the method #to_ruby
# retrieves a rational or a Integer, according to original representation

if r.eval("pvalue").to_ruby < alpha
 puts "Reject the null hypothesis and conclude that x and y are related."
else
 puts "There is insufficient evidence to conclude that x and y are related."
end
