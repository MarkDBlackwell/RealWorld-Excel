require 'realworld-excel-shared-classes.rb'
require 'realworld-excel-shared-utilities.rb'

module RealWorldExcel

module Shared

  private

  def fix_html_problems
    peculiar_html_lines=find_all_include(         '&')
    peculiar_html_lines.each   {|i|
          @report.lines[         i]=
          @report.lines.at(      i).gsub('&amp;', '&')}
#Verify there are no HTML peculiarities left.
    aLine=
    peculiar_html_lines.detect {|i|
      s = @report.lines.at(      i)
                                  s.scan('&amp;').     length==
                                  s.scan(         '&').length}
    fail_with_message('Unexpected peculiar HTML about line ' +
    aLine.to_s) unless aLine.nil?
  end

  def find_the_grand_total_line
    @grand_total_position=Indicator.new(@report,field_location(1,13),'Grand totals:').rdetect
  end

end #module Shared.

end #module RealWorldExcel.
