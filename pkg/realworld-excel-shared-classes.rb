require 'realworld-excel-shared-utilities.rb'

module RealWorldExcel

AnyPage=Struct.new(:header_size, :first_page_extra_size)

class ConvertReportTemplate
  include Shared

  def initialize(command_line_arguments, console)
                @command_line_arguments=
                 command_line_arguments
    @keyboard =                          console.first
    @screen =                            console.last
  end

  def disallow_some_formats_of_the_input_report
  end

  def determine_which_kind_of_RealWorld_report_we_have
  end

  def ensure_that_the_output_directory_exists
                        parent=File.expand_path(@command_line_arguments.at(second_argument=1))
    [grand=File.dirname(parent),
                        parent,
      @output_directory=parent + '/' + @report.meaningful_output_folder_name
    ].each {|s| Dir.mkdir(s) unless FileTest.directory?(s)}
  end

  def set_up_the_output
    @columns=Output.new(@output_directory,'Columns').handle
  end

  def assemble_the_result_table(spreadsheet)
    spreadsheet.row_lines.collect do |anArray|
     (0...anArray.length).collect do |i|
        spreadsheet.locations.at(     i).collect {|aRange| extract_location(
          anArray.at(                 i),          aRange).strip}
      end.flatten
    end
  end

  def write_the_result_table_to_a_file_for_Excel_to_import(result_table)
#Comment the next line to make a test of bad output.
    @columns.print result_table.collect {|aRow| aRow.join("\t") + "\n"}
    @columns.close
  end

  def run
    run_stuff_a
    @report.set_up_the_input(@command_line_arguments.first)
    disallow_some_formats_of_the_input_report
    ensure_that_the_output_directory_exists
    set_up_the_output
    determine_which_kind_of_RealWorld_report_we_have
    run_stuff_c
    result_table=assemble_the_result_table(@spreadsheet)
    write_the_result_table_to_a_file_for_Excel_to_import(result_table)
  end

  public :run

end #class ConvertReportTemplate.

class SpreadsheetSimple
  attr_reader :locations,
    :row_lines

  def get_the_result_table_locations(line_locations)
                                         @locations=
                                     line_locations
  end

  def get_the_result_table_lines(lines)
                                                         number_of_lines=@locations.length
    @row_lines =                 lines.collect {|c|
                                                (c...c + number_of_lines).to_a}
  end

end #class SpreadsheetSimple.

class Output
  attr_reader :handle

  def initialize(                  output_directory,          file_name_part)
    @handle=File.open(file_name="#{output_directory}/Report #{file_name_part}.txt", write='w')
  end

end #class Output.

class Report
  include Shared

  attr_reader :lines,
    :size

  def set_up_the_input(input_file_name)
                      @input_file_name=
                       input_file_name
    s =                input_file_name.gsub('\\','/').strip.squeeze('/').chomp('/')
    unless FileTest.exist?(s) and not FileTest.directory?(s)
      fail_with_message(
      "File '#{s}' does not exist or is a directory. Did you run the RealWorld report?")
    end
    input=File.open(s,read_only='r')
    @lines=input.readlines # Read the RealWorld report into an array.
    @size=@lines.length
    input.close
  end

  public

  def meaningful_output_folder_name
    s=real_world_report_identifier=@lines.first[field_location(133,139)].strip
    if 0==s.to_i
      s='0'
      put_warning("Warning: invalid report number; placing results in folder '#{s}'.")
    end
    s
  end

  def positivePosition(negative)
    @size +            negative
  end

end #class Report.

class HtmlReport < Report

  public

  def meaningful_output_folder_name
    basename=File.basename(@input_file_name)
    s=try_remove_extension=basename.split('.')[0..-2]
    file_name_without_extension=Array[[''],[]].include?(s) ? basename : s.join('.')
  end

end #class HtmlReport.

class Indicator
  attr_reader :location,
    :text

  def initialize(report, location, text)
                @report,@location,@text=
                 report, location, text
  end

  private

  def extract(       aLine)
    @report.lines.at(aLine)[@location]
  end

  public

  def at?(   aLine)
    extract( aLine)==@text
  end

  def detect(aLine)
            (aLine...@report.size).detect {|i| at?( i)}
  end

  def rdetect
                             negative = -(1..@report.size).detect {|i| at?(-i)}
    @report.positivePosition(negative)
  end

  def find_all
    (0...@report.size).find_all {|i| at?(i)}
  end

end #class Indicator.

class HtmlCaseStrategy
  include Shared

  attr_reader :detail_page_indicator,
    :pre_indicator

end #class.

class HtmlUppercaseStrategy < HtmlCaseStrategy

  def initialize(report)
    @pre_indicator        =Indicator.new(report, field_location(1, 6), '</PRE>')
    @detail_page_indicator=Indicator.new(report, field_location(1,19), '<PRE class=Details>')
  end

end #class.

class HtmlLowercaseStrategy < HtmlCaseStrategy

  def initialize(report)
    @pre_indicator        =Indicator.new(report, field_location(1, 6), '</PRE>'.downcase)
    @detail_page_indicator=Indicator.new(report, field_location(1,21), '<pre class="Details">')
  end

end #class.

end #module RealWorldExcel.
