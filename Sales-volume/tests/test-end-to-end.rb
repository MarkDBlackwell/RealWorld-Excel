require 'test/unit'
require 'realworld-excel-test-shared.rb'

module RealWorldExcelTest

class ConvertSalesVolumeTest < Test::Unit::TestCase
  include Shared

  def test_end_to_end
                         extracter=
                         Extracter.new('sales-volume',output_file_name_fragments=['Columns','Headings'])
    require     'realworld-excel-'+
                      "#{extracter.name}-classes.rb"
                         extracter.
                         extracter_class=
                 RealWorldExcel::ConvertSalesVolume
    compare_output_files(extracter, TextInput.new('file.txt', realworld_report_number='3247'))
  end

end #class.

end #module RealWorldExcelTest.
