s=File.expand_path(File.dirname(__FILE__) + '/../pkg')
$LOAD_PATH << s unless $LOAD_PATH.include?(s)
require 'realworld-excel-shared.rb'

module RealWorldExcel

class ConvertSalesVolume < ConvertReportTemplate

  AnyCustomer=Struct.new(:separator_size, :size, :consecutive_lines_locations)

  Page=Struct.new(:first_customer_position, :number_of_customers)

  Customer=Struct.new(:first_line)

  private

  def disallow_some_formats_of_the_input_report
    disallow_the_html_version_of_the_input_report
  end

  def disallow_the_html_version_of_the_input_report
#RealWorld places the HTML version into the user's choice of directory and file name.
#Verify we are not somehow reading the HTML version.
    fail_with_message('Please rerun the RealWorld report in text format.') if
      @report.lines.first.include?('<!DOCTYPE HTML')
  end

  def set_up_extra_output
    @headings =    Output.new(@output_directory,'Headings').handle
  end

  def extract_the_non_detail_report_information
    @any_page=AnyPage.new
    a  =@report.lines[0...(@any_page.first_page_extra_size=4) + @any_page.header_size=9]
    a +=@report.lines[-(@end_lines=13)..last_line= -1]
#Comment the next line to make a test of bad output.
    @headings.puts a
    @headings.close
  end

  def set_up_the_fields
    @any_customer=AnyCustomer.new
#Use hard-coded, 1-based column numbers as seen in simple text editors like Notepad.
    @repeat_field_ends=[71,78,98,118,125,132] #Beginning 52,72,79,99,119,126.
    @any_customer.consecutive_lines_locations=[create_field_locations([14,41,47] +       @repeat_field_ends), #Beginning 1,15,42.
                                               create_field_locations([36,   47] +       @repeat_field_ends), #Beginning 1,37.
                                               create_field_locations(                   @repeat_field_ends)]
    @any_customer.consecutive_lines_locations.each {|a| set_field_beginning(a, anIndex= -@repeat_field_ends.length, aColumn=52)}
  end

  def find_the_report_line_numbers_of_the_first_customer_on_each_page
                number_of_pages =       @report.size /            page_size=60
                number_of_pages += 1 if @report.size %            page_size > offset=@any_page.header_size
    @pages=(0...number_of_pages).collect {Page.new}
    @pages.each_with_index {|e,i| e.first_customer_position = i * page_size + offset}
    @pages.first.first_customer_position =  @any_page.first_page_extra_size + offset
  end

  def find_the_number_of_customers_on_each_page
                                           @standard_page_customers=13
    @pages.each {|e| e.number_of_customers=@standard_page_customers}
                                                                         number_of_lines_on_last_page = @report.size.succ - @end_lines -
    @pages.last.first_customer_position
    @pages.first.number_of_customers=      @standard_page_customers - 1
    @pages.last. number_of_customers=((@any_customer.separator_size=1) + number_of_lines_on_last_page)/
                                     ( @any_customer.separator_size    + @any_customer.size=3        )
  end

  def find_the_report_line_numbers_of_all_the_customers
              height =                 @any_customer.separator_size    + @any_customer.size
  a=@pages.collect do |e|
      first = e.first_customer_position
    (0...     e.number_of_customers    ).collect {|i|
      first + height * i}
  end
  a.flatten!
  @customers=(0...a.length).collect {Customer.new}
  @customers.each_with_index {|e,i| e.first_line = a.at(i)}

  end

  def run_stuff_a
    @report=Report.new
  end

  def run_stuff_c
    set_up_extra_output
    extract_the_non_detail_report_information
    set_up_the_fields
    (@spreadsheet=SpreadsheetSimple.new).get_the_result_table_locations(
      @any_customer.                        consecutive_lines_locations)
    find_the_report_line_numbers_of_the_first_customer_on_each_page
    find_the_number_of_customers_on_each_page
    find_the_report_line_numbers_of_all_the_customers
    @spreadsheet.get_the_result_table_lines(@customers.collect {|e| e.first_line})
  end

end #class ConvertSalesVolume.

end #module RealWorldExcel.
