require 'pass-file-name.rb'
class MockCommandLine < CommandLine
  def initialize(anArray)
    @arguments=anArray
  end
end  # class

class MockInputFile < InputFile
  attr_reader :file_accessor
  def initialize(aFileAccessor)
    @file_accessor=aFileAccessor
  end
end  # class

class MockInputFileNameSource < InputFileNameSource
  def initialize(aCommandLine)
    @value=CommandLineFileName.new(aCommandLine).value
  end

end  # class
