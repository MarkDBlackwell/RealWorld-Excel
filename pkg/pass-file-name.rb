class CommandLine
  attr_reader :arguments
  def initialize
    @arguments=ARGV
  end
end  # class

class CommandLineFileName

  attr_reader :value

  def initialize(command_line)
    @value=command_line.arguments[0]
    if @value.nil?
      puts 'Missing input file name argument.'
      puts 'Please run the program again, and give it an input file name.'
      puts 'Please hit enter after reading this message.'; gets
      raise
    end
  end

  def has_name?
    ! @value.nil?
  end

end  # class

class InputFileNameSource
  attr_reader :value
  def initialize(aCommandLine)
    @value=CommandLineFileName.new(aCommandLine).value
  end
end  # class

class InputFile
  def initialize(anInputFileNameSource)
    @file_accessor=anInputFileNameSource.value
  end
  def open
    read_only='r'
    File.open(@file_accessor,read_only)
  end
end  # class
