require 'Products-customers-two-periods/realworld-excel-products-customers-two-periods.rb'

require 'Tester/tester.rb'
tests    ='C:/Mark-develop/checkout/trunk' + '/RealWorld-Excel/Products-customers-two-periods/tests'
fixtures ='C:/Mark-develop/static'         + '/RealWorld-Excel/Products-customers-two-periods/fixtures'
Tester.new(tests,fixtures).run
