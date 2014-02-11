require 'test/unit'
require 'realworld-excel-test-shared.rb'

module RealWorldExcelTest

class ConvertWorkOrderHistoryTest < Test::Unit::TestCase
  include Shared

  def test_end_to_end
                         extracter=
                         Extracter.new('work-order-history',output_file_name_fragments=Array['Columns'])
    require     'realworld-excel-'+
                      "#{extracter.name}-classes.rb"
                         extracter.
                         extracter_class=
                 RealWorldExcel::ConvertWorkOrderHistory
#    s='fake-test-2005.htm'
    s='workorder07.htm'
    compare_output_files(extracter, Input.new(s))
  end

end #class.

end #module RealWorldExcelTest.
