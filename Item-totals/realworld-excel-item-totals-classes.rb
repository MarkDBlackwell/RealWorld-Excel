s=File.expand_path(File.dirname(__FILE__) + '/../pkg')
$LOAD_PATH << s unless $LOAD_PATH.include?(s)
require 'realworld-excel-shared.rb'

module RealWorldExcel

class ConvertItemTotals < ConvertReportTemplate
  private

  def set_up_the_fields
#Use hard-coded, 1-indexed column numbers as seen in simple text editors like Notepad.
    [set_field_beginning(create_field_locations(     [23,75]),anIndex=0,aColumn= 7), #Beginning 7,24.
     set_field_beginning(create_field_locations(Array[53   ]),anIndex=0,aColumn=39)] #Beginning 39.
  end

  def find_the_name_of_each_item
    find_all_include('Item:')
  end

  def find_the_total_for_each_item
    find_all_include('Grand totals')
  end

  def find_a_single_name_line_for_each_total_line(total_lines,                      name_lines)
                                                  total_lines.collect {|aTotalLine| name_lines.
    reverse.detect {|aLine| aLine <=                                    aTotalLine}}
  end

  def run_stuff_a
    @report=HtmlReport.new
  end

  def run_stuff_c
    (@spreadsheet=Spreadsheet.new).get_the_result_table_locations(set_up_the_fields)
    name_lines=find_the_name_of_each_item
    total_lines=find_the_total_for_each_item
    single_name_lines=find_a_single_name_line_for_each_total_line(total_lines,name_lines)
    @spreadsheet.get_the_result_table_lines(single_name_lines,total_lines)
  end

class Spreadsheet < SpreadsheetSimple

  def get_the_result_table_lines(single_name_lines,       total_lines)
    @row_lines=(0...             single_name_lines.length).collect     {|i|
                                [single_name_lines.at(i), total_lines.at(i)]}
  end

end #class Spreadsheet.

end #class ConvertItemTotals.

end #module RealWorldExcel.
