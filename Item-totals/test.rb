require File.dirname(__FILE__) + '/realworld-excel-item-totals-classes.rb'
require File.dirname(__FILE__) + '/../Tester/tester.rb'

tests    ='C:/Mark-develop/checkout/trunk' + '/RealWorld-Excel/Item-totals/tests'
fixtures ='C:/Mark-develop/static'         + '/RealWorld-Excel/Item-totals/fixtures'
Tester.new(tests,fixtures).run
