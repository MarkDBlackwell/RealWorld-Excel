s=File.expand_path(File.dirname(__FILE__) + '/../pkg')
$LOAD_PATH << s unless $LOAD_PATH.include?(s)
require 'realworld-excel-shared.rb'

module RealWorldExcel

class ConvertWorkOrderHistory < ConvertReportTemplate
  private

  def determine_which_kind_of_RealWorld_report_we_have
    @strategy=HtmlUppercaseStrategy.new(@report)
  end

  def set_up_the_fields
#Use hard-coded, 1-indexed column numbers as seen in simple text editors like Notepad.
                                                  last_column=becomes_negative_one=0
                   #Beginning 1, 7, 8,40,48,59,78,99.
    [create_field_locations([ 6, 7,39,47,58,77,98,last_column]),
                   #Beginning 1,34,45,            59.
     create_field_locations([33,44,58,            last_column]),
     create_field_locations([                     last_column])] #Beginning 1.
  end

  def find_the_work_orders_printed_line
              @work_orders_printed_position=Indicator.new(@report,field_location(8,26),
              'work orders printed').rdetect
  end

  def find_the_first_work_order
    position=find_a_page_s_detail_area(from_line=0)
    position=find_a_page_s_detail_area(position) if
      @report.lines.at(                position).include? 'Report selections'
    Array[                             position]
  end

  def find_the_rest_of_the_work_orders(work_order_lines)
        usual_work_order_size=3
                                                    item_subdescription=2
                                         position=
              work_order_lines.first
    loop do
      position += @report.lines.at(      position + item_subdescription).strip.length==0 ?
        usual_work_order_size :
        usual_work_order_size.succ
      break if                           position >=
             @work_orders_printed_position
      position=find_a_page_s_detail_area(position) if
        at_html_report_section_end?(     position)
              work_order_lines.push(     position)
    end
    work_order_lines
  end

  def verify_right_number_of_work_orders_found(work_order_lines)
    fail_with_message(
     "Unexpected miscount of work orders.\n" + @report.lines.at(
                            @work_orders_printed_position)) unless
                            work_order_lines.length==
      remove_commas_from_a_number_string(extract_location(
                            @work_orders_printed_position, field_location(1, 7))).to_i
  end

  def run_stuff_a
    @report=HtmlReport.new
  end

  def run_stuff_c
    (@spreadsheet=SpreadsheetSimple.new).get_the_result_table_locations(set_up_the_fields)
    find_the_work_orders_printed_line
    work_order_lines=find_the_first_work_order
    work_order_lines=find_the_rest_of_the_work_orders(work_order_lines)
    verify_right_number_of_work_orders_found(work_order_lines)
    @spreadsheet.get_the_result_table_lines(work_order_lines)
  end

end #class ConvertWorkOrderHistory.

end #module RealWorldExcel.
