require File.dirname(__FILE__) + '/realworld-excel-products-customers-classes.rb'
require File.dirname(__FILE__) + '/../Tester/tester.rb'

tests    ='C:/Mark-develop/checkout/trunk' + '/RealWorld-Excel/Products-customers/tests'
fixtures ='C:/Mark-develop/static'         + '/RealWorld-Excel/Products-customers/fixtures'
Tester.new(tests,fixtures).run
