require 'test/unit'
require 'realworld-excel-test-shared.rb'

module RealWorldExcelTest

class ConvertCustomerItemSummaryTest < Test::Unit::TestCase
  include Shared

  def test_end_to_end
                         extracter=
                         Extracter.new('customer-item-summary',output_file_name_fragments=Array['Columns'])
    require     'realworld-excel-'+
                      "#{extracter.name}-classes.rb"
                         extracter.
                         extracter_class=
                 RealWorldExcel::ConvertCustomerItemSummary
    compare_output_files(extracter, Input.new('2005.htm'))
  end

end #class.

end #module RealWorldExcelTest.
