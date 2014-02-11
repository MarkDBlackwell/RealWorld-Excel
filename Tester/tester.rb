class Tester

  def initialize(directory,  fixtures_parent)
                @directory, @fixtures_parent=
                 directory,  fixtures_parent
    @branch =   @directory.split( '/')[-2]
    @test_file_names=
    Dir.entries(@directory).delete_if {|s| FileTest.directory?(  #Ignore directories.
                @directory +      '/' + s)}
  end

  private

  def build_test_class_contexts
  end

  def run
    result='ok'  #In case no tests found.
    @test_file_names.each do |aTest|
      t=LoadableNamespace.new(aTest,@branch,@fixtures_parent)

      eval t.generated_test_class
      context=eval(t.class_name + '.new').bind

      read_only='r'
      File.open(@directory + '/' + aTest, read_only) do |aFile|
        result=eval(aFile.read,context, aTest)  #Run the test, obtaining its last value.
      end
      unless 'ok'==result  #This test failed.
        puts @branch + '/' + aTest + ":\n" + result
        break
      end
    end
    puts result if 'ok'==result  #All tests passed.
  end

  public :run

end #class Tester.

class LoadableNamespace
#The loadable classes are used as namespaces, without any method to run them.
  attr_reader :class_name,
              :generated_test_class

  def initialize(file_name,branch,fixtures_parent)
      @class_name=(branch + '_' + file_name).capitalize.chomp('.rb').split('-').join('_')
      s=fixtures_parent   + '/' + file_name.            chomp('.rb')
      @generated_test_class=<<-END_HERE
        class #{@class_name}
          FIXTURES_DIRECTORY="#{s}"
          def bind;binding;end
        end
      END_HERE
  end

end #class LoadableNamespace.
