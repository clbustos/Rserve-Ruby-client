# The code and output below demonstrates some of the Ruby Rserve client, using a example from RinRuby. Ruby code counts the number of occurences of each word in Lincoln's Gettysburg Address and filters out those occurring less than three times or shorter than four letters. R code -- through the Rserve library -- produces a bar plot of the most frequent words and computes the correlation between the length of a word and the usage frequency. Finally, the computed correlation is printed by Ruby

require "rserve"
r=Rserve::Connection.new

 tally = Hash.new(0)
 File.open(File.dirname(__FILE__)+'/../data/gettysburg.txt').each_line do |line|
    line.downcase.split(/\W+/).each { |w| tally[w] += 1 }
 end
 total = tally.values.inject { |sum,count| sum + count }
 tally.delete_if { |key,count| count < 3 || key.length < 4 }
 
 r.assign("keys",tally.keys)
 r.assign("counts", tally.values)
       
 r.void_eval <<-EOF
    names(counts) <- keys
    barplot(rev(sort(counts)),main="Frequency of Non-Trivial Words",las=2)
    mtext("Among the #{total} words in the Gettysburg Address",3,0.45)
    rho <- round(cor(nchar(keys),counts),4)
EOF
puts "Press enter when finished"
STDIN.gets
puts "The correlation between word length and frequency is #{r.eval("rho").as_float}."