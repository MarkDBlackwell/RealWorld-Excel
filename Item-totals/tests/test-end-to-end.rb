require 'test/unit'
require 'realworld-excel-test-shared.rb'

module RealWorldExcelTest

class ConvertItemTotalsTest < Test::Unit::TestCase
  include Shared

  def test_end_to_end
                         extracter=
                         Extracter.new('item-totals',output_file_name_fragments=Array['Columns'])
    require     'realworld-excel-'+
                      "#{extracter.name}-classes.rb"
                         extracter.
                         extracter_class=
                 RealWorldExcel::ConvertItemTotals
    compare_output_files(extracter, Input.new('fall 07.html'))
  end

end #class.

end #module RealWorldExcelTest.
