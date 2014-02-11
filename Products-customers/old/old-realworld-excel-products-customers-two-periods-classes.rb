require 'pkg/realworld-excel-shared.rb'

module Realworld_excel

  class Convert_products_customers_two_periods
    include Realworld_excel::Shared

    def at_section_end(lines,position)  #Check end of HTML report section.
      pre_indicator_location=1-1..6-1
      return '</PRE>'==lines[   position][
      pre_indicator_location]
    end

    def skip_page_header(lines,position)
      @product_info_size=3
      if at_section_end(lines,position) ||
         at_section_end(lines,position +
      @product_info_size)
        find_page_detail(lines,position + 1)
      else
        position
      end
    end

    def find_page_detail(lines,position)  #Find a page's detail area.
      @detail_page_indicator_location=1-1..19-1
      (position...@report_size).detect {|i| '<PRE class=Details>'==lines[i][
      @detail_page_indicator_location]} + 1
    end

    def set_up_the_input
      @input_directory='C:/Mark-develop/static/RealWorld-Excel/Products-customers-two-periods'
      @input_file_name=
      @input_directory + '/' + 'donald-pansies-2.htm'
      @read_only='r'
      input=File.open(
      @input_file_name,
      @read_only)
      @lines=input.readlines # Read the RealWorld HTML report into an array.
      input.close
      @report_size=@lines.size
      #p @report_size
    end

    def create_the_output_directory
      #@output_parent_directory='U:/RW-Excel'
      @output_parent_directory='C:/Mark-develop/checkout/trunk/RealWorld-Excel/Products-customers-two-periods'
      unless FileTest.directory?(@output_parent_directory)
        Dir.mkdir(               @output_parent_directory)
      end
      @report_number='0' #Stub.
      @output_directory=@output_parent_directory + '/' + @report_number
      unless FileTest.directory?(@output_directory)
        Dir.mkdir(               @output_directory)
      end
    end

    def set_up_the_output
      @prefix='/Report '
      @suffix='.txt'
      @write='w'
      @columns_file_name=@output_directory + @prefix + 'Columns' + @suffix
      @columns=File.open(@columns_file_name, @write)
    end

    def locate_the_end_of_each_product
      @total_indicator_location=8-1..21-1
      @product_end_lines=(0...@lines.length).find_all {|i| 'Customers for '==@lines[i][
      @total_indicator_location]}
      @number_of_products=@product_end_lines.length
      #p @product_end_lines
    end

    def locate_the_start_of_each_product
      #The first product.
      @position=0
      @product_start_lines=Array.new
      @product_start_lines.push(find_page_detail(@lines,@position))
      #The rest of the products.
                               @quantity_indicator_location=36-1..44-1
                              @underline_indicator_location=44-1..47-1
                                  @sales_indicator_location=
                               @quantity_indicator_location
      (@number_of_products - 1).times do |i|
        @position=(@product_end_lines[i]...@report_size).detect {|k|
        'Qty sold:'==@lines[k][ @quantity_indicator_location]}

        @position=(@position + 1...        @report_size).detect {|k|
        'Sales   :'==@lines[k][    @sales_indicator_location]}

        @position=(@position + 1...        @report_size).detect {|k|
        '____'     ==@lines[k][@underline_indicator_location]}

        @product_start_lines.push(skip_page_header(@lines,@position + 1))
      end
      #p @product_start_lines.length
      #p @product_end_lines.  length
      #p @product_start_lines
      #p @product_end_lines
    end

    def verify_that_product_info_and_totals_match_one_to_one
      #The number of them.
      unless @product_start_lines.length==@number_of_products
        puts 'Unexpected miscount between product names and product totals.'
        puts 'Please hit Enter after reading this message.'
        gets
        raise
      end
      #The right order.
      @number_of_products.times do |i|
        unless  @product_start_lines[i] <
                @product_end_lines[  i]
          puts 'Unexpected disorder between product names and product totals.'
          puts 'Please hit Enter after reading this message.'
          gets
          raise
        end
      end
    end

    def build_the_product_fields
      @product_info_first_line_fields_start =[1, 17,44]
      @product_info_first_line_fields_end   =[16,43,70]
      @product_info_second_line_fields_start=[8  ]
      @product_info_second_line_fields_end  =[132]

      @product_info_first_line_locations= create_field_locations(
      @product_info_first_line_fields_start,
      @product_info_first_line_fields_end)
      @product_info_second_line_locations=create_field_locations(
      @product_info_second_line_fields_start,
      @product_info_second_line_fields_end)
      @product_fields=Array.new
      @product_start_lines.each do |aLine|
        @detail=Array.new
        @product_info_first_line_locations. each {|r| @detail.push(@lines[aLine    ][r].strip)}
        @product_info_second_line_locations.each {|r| @detail.push(@lines[aLine + 1][r].strip)}
        @product_fields.push(@detail)
      end
    end

    def find_the_first_customer_start_line_of_each_product
      @first_customer_start_lines=
             @product_start_lines.collect {|aLine| aLine + @product_info_size}
    end

    def find_the_rest_of_the_customer_start_lines_for_each_product
      @customer_size=5
                  @customer_start_lines=Array.new
      @number_of_products.times do |i|
          @product_customer_start_lines=Array.new
        @position=@first_customer_start_lines[i]
        while @position < @product_end_lines[i]
          @product_customer_start_lines.push(@position)
          @position += @customer_size
          if at_section_end(          @lines,@position)
            @position=find_page_detail(@lines,@position) + @product_info_size
          end
        end
                @customer_start_lines.push(
        @product_customer_start_lines)
      end
    end

    def verify_right_number_of_products_found
      @grand_item_count_location=1-1..9-1
      unless @number_of_products==remove_commas(@lines[@report_size - 12][
      @grand_item_count_location]).to_i
        puts 'Unexpected miscount of products.'
        puts @lines[@report_size - 12]
        puts 'Please hit Enter after reading this message.'
        gets
        raise
      end
    end

    def verify_right_number_of_customers_found_for_each_product
        @customer_count_location=1-1..7-1
      @number_of_products.times do |i|
        unless @customer_start_lines[i].length==remove_commas(@lines[@product_end_lines[i]][
        @customer_count_location]).to_i
          puts "Unexpected mismatch between RealWorld report's and counted customers for product"
          puts @lines[@product_start_lines[i]]
          puts 'Please hit Enter after reading this message.'
          gets
          raise
        end
      end
    end

    def verify_right_number_of_detail_points_found
      @grand_customer_count_location=1-1..11-1
      @detail_count=0
      @number_of_products.times {|i| @detail_count += @customer_start_lines[i].length}
      unless @detail_count==remove_commas(@lines[@report_size - 11][
      @grand_customer_count_location]).to_i
        puts 'Unexpected miscount of grand total detail points (customers).'
        puts @lines[@report_size - 11]
        puts 'Please hit Enter after reading this message.'
        gets
        raise
      end
    end

    def build_the_customer_fields
      @customer_first_line_fields_start =[1, 45,61,83,105]
      @customer_first_line_fields_end   =[35, 60,82,104,126]
      @customer_second_line_fields_start =[1,28, 45,64,86,108]
      @customer_second_line_fields_end   =[27,35, 63,85,107,129]
      @customer_third_line_fields_start =[1]
      @customer_third_line_fields_end   =[0] #Becomes -1 (the last).

      @customer_first_line_locations=create_field_locations(
      @customer_first_line_fields_start,
      @customer_first_line_fields_end)
      @customer_second_line_locations=create_field_locations(
      @customer_second_line_fields_start,
      @customer_second_line_fields_end)
      @customer_third_line_locations=create_field_locations(
      @customer_third_line_fields_start,
      @customer_third_line_fields_end)
      @customer_fields=Array.new
      @number_of_products.times do |i|
        a=Array.new
        @customer_start_lines[i].each do |aLine|
          @detail=Array.new
          @customer_first_line_locations. each {|r| @detail.push(@lines[aLine    ][r].strip)}
          @customer_second_line_locations.each {|r| @detail.push(@lines[aLine + 1][r].strip)}
          @customer_third_line_locations. each {|r| @detail.push(@lines[aLine + 2][r].strip)}
          a.push(@detail)
        end
        @customer_fields.push(a)
      end
    end

    def write_the_fields_to_a_file_for_Excel_to_import
      @number_of_products.times do |i|
        s=@product_fields[i].join("\t") + "\t"
        @customer_fields[i].each {|a| @columns.print(s + a.join("\t") + "\n")}
      end
      @columns.close
    end

    def show_development_output
      @number_of_products.times do |i|
      #  @columns.puts @lines[@product_start_lines[i]]
      #  @customer_start_lines[i].each {|aLine| @columns.puts @lines[aLine]}
      #  @customer_start_lines[i].each {|aLine| @columns.puts @lines[aLine + 1]}
      #  @customer_start_lines[i].each {|aLine| @columns.puts @lines[aLine + 2]}
      #  @columns.puts @lines[@product_end_lines[  i]]
      end
    end

    def run
      set_up_the_input
      create_the_output_directory
      set_up_the_output
      locate_the_end_of_each_product
      locate_the_start_of_each_product
      verify_that_product_info_and_totals_match_one_to_one
      build_the_product_fields
      find_the_first_customer_start_line_of_each_product
      find_the_rest_of_the_customer_start_lines_for_each_product
      verify_right_number_of_products_found
      verify_right_number_of_customers_found_for_each_product
      verify_right_number_of_detail_points_found
      build_the_customer_fields
      write_the_fields_to_a_file_for_Excel_to_import
      show_development_output
    end

  end  #class Convert_products_customers_two_periods.
end  #module Realworld_excel.
