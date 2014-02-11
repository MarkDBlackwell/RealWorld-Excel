require 'test/unit'

module RealWorldExcelTest

module Shared

  def compare_output_files(   extracter,                     input)
                              extracter.delete_files(        input)
                              extracter.run(                 input)
                              extracter.output_file_name_fragments.each do |aFragment|
                          a = extracter.twin(                input,         aFragment)
      assert(             a.first==a.last,
      "output incorrect for #{extracter.name} #{aFragment} #{input.file_name}")
    end
  end

class Extracter
  attr_reader :name,
    :output_file_name_fragments

  attr_writer :extracter_class

  def initialize(name,  output_file_name_fragments)
                       @output_file_name_fragments=
                        output_file_name_fragments
    @name=       name.capitalize
       @input_directory=
    "C:/Mark-develop/static/RealWorld-Excel/#{@name}"
      @output_directory=
    "C:/Mark-develop/output/RealWorld-Excel/#{@name}"
    @fixtures_directory=
    "#{@input_directory}/fixtures/test-end-to-end"
  end

  public

  def delete_files(                 input)
          @output_file_name_fragments.each                               do |aFragment|
      s = @output_directory + '/' + input.output_subdirectory + '/Report ' + aFragment + '.txt'
      FileTest.exists?(s) ? File.delete(s) : $stderr.puts("Warning: could not delete file #{s}")
    end
  end

  def run(input)
                       command_line_arguments=Array[@input_directory + '/' +
          input.file_name,                         @output_directory]
                                              console=Array[$stdin,$stderr]
    @extracter_class.new(command_line_arguments,console).run
  end

  def twin(                 input,                              aFragment)
    [@fixtures_directory,
       @output_directory].
    collect {|aDirectory|
      File.open(
           "#{aDirectory}/#{input.output_subdirectory}/Report #{aFragment}.txt",
        read_only='r') {|f| f.read}}
  end

end #class Extracter.

class Input
  attr_reader :file_name,
    :output_subdirectory

  def initialize(file_name)
                @file_name=
                 file_name
    @output_subdirectory=
                 file_name.split('.')[0..-2].join('.')
  end

end #class Input.

class TextInput < Input

  def initialize(file_name, realworld_report_number)
    super(       file_name)
    @output_subdirectory=   realworld_report_number
  end

end #class TextInput.

end #module Shared.

end #module RealWorldExcelTest.
