s=File.expand_path(File.dirname(__FILE__) + '/../pkg')
$LOAD_PATH << s unless $LOAD_PATH.include?(s)
require 'realworld-excel-shared.rb'

module RealWorldExcel

class ConvertCustomerItemSummary < ConvertReportTemplate
  private

  def determine_which_kind_of_RealWorld_report_we_have
    @strategy=HtmlUppercaseStrategy.new(@report)
  end

  def set_up_the_fields
#Use hard-coded, 1-indexed column numbers as seen in simple text editors like Notepad.
                                   #Beginning 1,15.
    line_locations=[create_field_locations([14, becomes_negative_one_the_last_column=0]),
                    create_field_locations([19,59]), #Beginning 1,43.
                    create_field_locations([15,62])] #Beginning 1,43.
    line_locations[1..2].each {|a| set_field_beginning(a, index= -1, column=43)}
    line_locations
  end

  def find_the_first_customer
    position=find_a_page_s_detail_area(from_line=0)
    position=find_a_page_s_detail_area(position) if
      @report.lines.at(                position).include? 'Report selections'
    Array[                             position]
  end

  def find_the_rest_of_the_customers(               customer_lines)
                                         position = customer_lines.first + (customer_size=5)
    while                                position < @grand_total_position
      position=find_a_page_s_detail_area(position) if
        at_html_report_section_end?(     position)
      customer_lines.push(               position)
                                         position +=                        customer_size
    end
    customer_lines
  end

  def run_stuff_a
    @report=HtmlReport.new
  end

  def run_stuff_c
    (@spreadsheet=SpreadsheetSimple.new).get_the_result_table_locations(set_up_the_fields)
    find_the_grand_total_line
    customer_lines=find_the_first_customer
    customer_lines=find_the_rest_of_the_customers(customer_lines)
    @spreadsheet.get_the_result_table_lines(customer_lines)
  end

end #class ConvertCustomerItemSummary.

end #module RealWorldExcel.
