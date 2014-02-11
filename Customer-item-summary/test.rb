require File.dirname(__FILE__) + '/realworld-excel-customer-item-summary-classes.rb'
require File.dirname(__FILE__) + '/../Tester/tester.rb'

tests    ='C:/Mark-develop/checkout/trunk' + '/RealWorld-Excel/Customer-item-summary/tests'
fixtures ='C:/Mark-develop/static'         + '/RealWorld-Excel/Customer-item-summary/fixtures'
Tester.new(tests,fixtures).run
