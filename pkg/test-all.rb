=begin
Runs all RealWorld-Excel tests, independently of the setting of the current directory.
=end

require File.dirname(__FILE__) + '/../Tester/tester.rb'

['pkg',
'Tester'].
each do |s|
  tests   ='C:/Mark-develop/checkout/trunk' + "/RealWorld-Excel/#{s}/tests"
  fixtures='C:/Mark-develop/static'         + "/RealWorld-Excel/#{s}/fixtures"
  Tester.new(tests,fixtures).run
end

['customer-item-summary',
'item-totals',
'products-customers',
'run-programs',
'sales-volume'].
each do |s|
  cap=s.capitalize
  require File.dirname(__FILE__) +  "/../#{cap}/realworld-excel-#{s}-classes.rb"
  tests   ='C:/Mark-develop/checkout/trunk' + "/RealWorld-Excel/#{cap}/tests"
  fixtures='C:/Mark-develop/static'         + "/RealWorld-Excel/#{cap}/fixtures"
  Tester.new(tests,fixtures).run
end
