s=File.expand_path(File.dirname(__FILE__) + '/../pkg')
$LOAD_PATH << s unless $LOAD_PATH.include?(s)
require 'realworld-excel-shared.rb'

module RealWorldExcel

class ConvertProductsCustomers < ConvertReportTemplate

  AnyCustomer=Struct.new(:consecutive_lines_locations)

  AnyProduct =Struct.new(:consecutive_lines_locations, :info_size)

  Product=Struct.new(:end_line, :start_line, :customer_start_lines)

  private

  def determine_which_kind_of_RealWorld_report_we_have
    check_indicator=Indicator.new(@report,field_location(1,6),'</PRE>')
    position=(0...@report.size).detect {|i| extract_location(i,check_indicator.location).upcase==check_indicator.text}
    @strategy=(check_indicator.at?(position) ? HtmlUppercaseStrategy : HtmlLowercaseStrategy).new(@report)
  end

  def set_up_the_fields
#Use hard-coded, 1-indexed column numbers as seen in simple text editors like Notepad.
    @any_customer=AnyCustomer.new
                                                           #Beginning   1,    45,61, 83,105.
    @any_customer.consecutive_lines_locations=[create_field_locations([35,    60,82,104,126]),
                                           #Beginning   1,28, 45,64, 86,108.
                                               create_field_locations([27,35, 63,85,107,129]),
                                               create_field_locations(Array[ 43])] #Beginning 1.
    @any_customer.consecutive_lines_locations[0..1].each {|a|
                           set_field_beginning(            a,                     anIndex= -4, aColumn=45)}
#Avoid RealWorld's spurious, extra customer's total-lines underscores.
    @any_product= AnyProduct.new
    @any_product. consecutive_lines_locations=[create_field_locations([16,43,70]), #Beginning 1,17,44.
                           set_field_beginning(create_field_locations(Array[132]),anIndex=  0, aColumn= 8)] #Beginning 8.
  end

  def locate_the_end_of_each_product
    a=Indicator.new(@report,field_location(8,21),'Customers for ').find_all
    @products=(0...a.length).collect {Product.new}
    @products.each_with_index {|e,i| e.end_line = a.at(i)}
  end

  def locate_the_start_of_each_product
               @quantity_indicator=Indicator.new(@report,r=field_location(36,44), 'Qty sold:')
               underline_indicator=Indicator.new(@report,  field_location(44,47), '____'     )
                   sales_indicator=Indicator.new(@report,r                      , 'Sales   :')
    end_lines=@products.collect {|e| e.end_line}
    end_lines.pop
    @any_product.info_size=3
    start_lines=end_lines.collect               do |aLine|
      position=@quantity_indicator.detect(from_line=aLine)
      position=    sales_indicator.detect(position.succ)
      position=underline_indicator.detect(position.succ)
      skip_page_header(                   position.succ)
    end
    start_lines.unshift(find_a_page_s_detail_area(from_line=0)) #Locate the start of the first product.
#Verify the number of them.
      fail_with_message('Unexpected miscount between product names and product totals.') unless @products.length==
                                                                                              start_lines.length
    @products.each_with_index {|e,i| e.start_line = start_lines.at(i)}
  end

  def verify_that_product_info_and_totals_match_one_to_one
    @products.each {|e|
      fail_with_message('Unexpected disorder between product names and product totals.') unless e.start_line <
                                                                                                e.  end_line}
  end

  def find_the_first_customer_start_line_of_each_product
    @products.each{|e| e.customer_start_lines=Array[e.start_line + @any_product.info_size]}
  end

  def find_the_rest_of_the_customer_start_lines_for_each_product
    @products.each do |e|                       position=
      e.customer_start_lines.first
                 start_lines=Array.new
      while e.end_line >                        position
                 start_lines.push(              position)
#Handle spurious extra total lines. RealWorld counts this as a customer.
        if @quantity_indicator.at?(check=       position + spurious_extra_total_lines_size=3)
           position =              check
        else
           position += customer_size=5
        end
           position = find_a_page_s_detail_area(position) +        @any_product.info_size if
             at_html_report_section_end?(       position)
      end
      e.customer_start_lines=
                 start_lines
    end
  end

  def verify_right_number_of_products_found
                       item_count_position = @grand_total_position + 1
      fail_with_message(
      "Unexpected miscount of products.\n" +
      @report.lines.at(item_count_position )) unless @products.length==
      remove_commas_from_a_number_string(extract_location(
                       item_count_position,
      field_location(1, 9))).to_i
  end

  def verify_right_number_of_customers_found_for_each_product
    @products.each do |e|
      fail_with_message(
      "Unexpected mismatch between RealWorld report's and counted customers for product\n" +
      @report.lines.at(e.start_line)) unless e.customer_start_lines.length==
       remove_commas_from_a_number_string(extract_location(e.end_line,
       field_location(1, 7))).to_i
    end
  end

  def verify_right_number_of_detail_points_found
                        detail_count = 0
    @products.each {|e| detail_count += e.customer_start_lines.length}
                       customer_count_position = @grand_total_position + 2
      fail_with_message(
      "Unexpected miscount of grand total detail points (customers).\n" +
      @report.lines.at(customer_count_position)) unless
                        detail_count==
      remove_commas_from_a_number_string(extract_location(
                       customer_count_position,
      field_location(1,11))).to_i
  end

  def run_stuff_a
    @report=HtmlReport.new
  end

  def run_stuff_c
    fix_html_problems
    set_up_the_fields
    (@spreadsheet=Spreadsheet.new).get_the_result_table_locations(
      @any_product.                  consecutive_lines_locations +
      @any_customer.                 consecutive_lines_locations)
    find_the_grand_total_line
    locate_the_end_of_each_product
    locate_the_start_of_each_product
    verify_that_product_info_and_totals_match_one_to_one
    find_the_first_customer_start_line_of_each_product
    find_the_rest_of_the_customer_start_lines_for_each_product
    verify_right_number_of_products_found
    verify_right_number_of_customers_found_for_each_product
    verify_right_number_of_detail_points_found
    @spreadsheet.get_the_result_table_lines(@products)
  end

class Spreadsheet < SpreadsheetSimple

  def get_the_result_table_lines(products)
      b=Array.new
                                 products.each do |e|
                         i =                       e.start_line
        product_lines = (i...i + number_of_lines=2).to_a
                                 number_of_lines=3
               array_of_arrays =                   e.customer_start_lines.collect {|c|
        product_lines + (c...c + number_of_lines  ).to_a}
      b.concat(array_of_arrays)
    end
    @row_lines = b
  end

end #class Spreadsheet.

end #class ConvertProductsCustomers.

end #module RealWorldExcel.
