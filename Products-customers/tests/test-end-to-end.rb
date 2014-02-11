require 'test/unit'
require 'realworld-excel-test-shared.rb'

module RealWorldExcelTest

class ConvertProductsCustomersTest < Test::Unit::TestCase
  include Shared

  def test_end_to_end
                         extracter=
                         Extracter.new('products-customers',output_file_name_fragments=Array['Columns'])
    require     'realworld-excel-'+
                      "#{extracter.name}-classes.rb"
                         extracter.
                         extracter_class=
                 RealWorldExcel::ConvertProductsCustomers
    input_file_names=[
      'all-fall07.htm',   #HTML uppercase.
      'all-spring07.htm', #HTML lowercase.
      #'donald-pansies-2.htm',
      #'winter07.htm',
    ]
    input_file_names.each {|s|
    compare_output_files(extracter, Input.new(s))}
  end

end #class.

end #module RealWorldExcelTest.
