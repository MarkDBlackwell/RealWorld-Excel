require 'pass-file-name.rb'
require 'mock-pass-file-name.rb'
require 'test/unit'
class TestGetInputFileNameFromCommandLine < Test::Unit::TestCase

  def test_get_file_name
    aFileName=CommandLineFileName.new(MockCommandLine.new(['abc']))
    assert_equal('abc',aFileName.value)
  end

  def test_input_opening
    anInputFile=MockInputFile.new('test-pass-file-name.txt')
    assert_equal(                 'test-pass-file-name.txt',anInputFile.file_accessor)
    f=anInputFile.open
    assert_equal(['text inside argument file'],f.readlines)
  end

  def test_input_opening2
    anInputFileNameSource=MockInputFileNameSource.new(MockCommandLine.new([
    './test-pass-file-name.txt']))
    anInputFile=InputFile.new(anInputFileNameSource)
    assert_equal(
    './test-pass-file-name.txt',anInputFile.value)
  end

end  # class

#  def test_missing_file_name
#    begin
#      aCommandLine=MockCommandLine.new(Array.new)
#      assert_nil(aCommandLine.arguments[0])
#      aFileName=CommandLineFileName.new(aCommandLine)
#      assert_nil(aFileName.value)
#      p aFileName.value.nil?
#    rescue RuntimeError
#    end
#  end
#file_in = File.new(ARGV[0],'r')
#s2 = file_in.gets
#puts s2

#stdin=$stdin
#puts 'Please type something and hit Enter.'
#s1 = stdin.gets
#puts s1
