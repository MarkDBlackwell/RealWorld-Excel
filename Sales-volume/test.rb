require File.dirname(__FILE__) + '/realworld-excel-sales-volume-classes.rb'
require File.dirname(__FILE__) + '/../Tester/tester.rb'

# load 'Tester/tester.rb'
#cannot pass the directories as arguments to the testing framework.

#print `#{ruby} #{framework} #{tests} #{fixtures}`  #Run the testing framework.
#Not using backtick command, because of peculiarities of standard input and output.
#require   'C:/Mark-develop/checkout/trunk' + '/RealWorld-Excel/Tester/tester.rb'

tests    ='C:/Mark-develop/checkout/trunk' + '/RealWorld-Excel/Sales-volume/tests'
fixtures ='C:/Mark-develop/static'         + '/RealWorld-Excel/Sales-volume/fixtures'
Tester.new(tests,fixtures).run
