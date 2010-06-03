# As another example of Ruby Rserve client, extracted from RinRuby documentation, consider the usage of Ruby Rserve client for simple linear regression below. The simulation parameters are deﬁned in Ruby, computations are performed in R, and Ruby reports the results. In a more eloborate application, the simulation parameter might come from input from a graphical user interface, the statistical analysis might be more involved, and the results might be an HTML page or PDF report.

require 'rserve'
r=Rserve::Connection.new
n = 10
beta_0 = 1
beta_1 = 0.25
alpha = 0.05
seed = 23423
r.assign "x", (1..n).entries
r.void_eval <<EOF
 set.seed(#{seed})
 y <- #{beta_0} + #{beta_1}*x + rnorm(#{n})
 fit <- lm( y ~ x )
 est <- round(coef(fit),3)
 pvalue <- summary(fit)$coefficients[2,4]
EOF
est=r.eval("est")
require 'pp'
pp r.eval("fit").to_ruby

puts "E(y|x) ~= #{est.as_floats[0]} + #{est.as_floats[1]} * x"
if r.eval("pvalue").to_ruby < alpha
 puts "Reject the null hypothesis and conclude that x and y are related."
else
 puts "There is insufficient evidence to conclude that x and y are related."
end
