module RealWorldExcel

module Shared

  def fail_with_message(aString)
    put_warning(        aString)
    raise
  end

  def put_warning( aString)
    @screen.  puts aString, 'Please hit Enter after reading this message.'
    @keyboard.gets
  end

  def field_location(first_column, last_column)
#Input is column numbers starting with 1, as seen in simple text editors like Notepad.
#Convert column numbers to 0-based.
    a =             [first_column, last_column].collect {|e| e -= 1 unless e < 0; e}
    a.first..a.last
  end

  def remove_commas_from_a_number_string(s)
    s.split(',').join.strip
  end

  def extract_location(aLine, location)
    @report.lines.at(  aLine)[location]
  end

  def indicator?(    aLine, location,  match_string)
    extract_location(aLine, location)==match_string
  end

  def at_html_report_section_end?(aLine)
    @strategy.pre_indicator.at?( aLine)
  end

  def find_all_include( match_string)
    (0...@report.size).find_all {|i|
         @report.lines.at(        i).
               include?(match_string)}
  end

  def find_a_page_s_detail_area(                                aLine)
    found = @strategy.detail_page_indicator.detect(             aLine)
    fail_with_message("Find a page's detail area: nil at line #{aLine}") if found.nil?
    found += 1
  end

  def skip_page_header(            aLine)
    return aLine unless at_html_report_section_end?(aLine) ||
                        at_html_report_section_end?(aLine + @any_product.info_size)
    find_a_page_s_detail_area(                      aLine + 1)
  end

  def create_field_locations(fields_end)
    fields_start =           fields_end.collect {|e| e + start_each_field_just_after_the_previous_ends=1}
    fields_start.unshift(start_at_leftmost_column=1).pop
    (0...                    fields_end.length).collect {|i| field_location(
    fields_start.at(i),      fields_end.at(i))}
  end

  def set_field_beginning( anArray,   anIndex,  aColumn)
                           anArray[   anIndex]=(aColumn - (convert_to_0_based=1).. # Range.
                           anArray.at(anIndex).end)
                           anArray
  end

end #module Shared.

end #module RealWorldExcel.
