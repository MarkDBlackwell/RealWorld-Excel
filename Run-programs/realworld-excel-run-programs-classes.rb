module RealWorldExcelRun

class RunPrograms

  def initialize(a)
#    raise
    @command_line_arguments=a
    @programs=CreatePrograms.new.programs
  end

  private

  def prompt_the_user_for_the_program
    puts 'Which RealWorld report do you want to columnize for Excel?'
    @programs.each_with_index do |e,i|
      s=e.menu_text
      one_based_numbering=1
      puts "#{i + one_based_numbering}. #{s}"
    end
  end

  def get_the_menu_item
    si,s = nil
    until (1..@programs.length).include?(si) &&
                                         si.to_f == s.to_f
       s = $stdin.gets.strip
                                         si =       s.to_i
    end
    @menu_item_number =                  si
  end

  def prompt_the_user_for_the_report_input_file_name
    puts 'Which file contains the RealWorld report?'
  end

  def get_the_report_input_file_name
    s=''
    until FileTest.exist?(s) and not FileTest.directory?(s)
      puts "File '#{s}' does not exist or is a directory" unless s.empty?
      s=$stdin.gets.gsub('\\','/').strip.squeeze('/').chomp('/')
    end
    p s
    @report_input_file_name=s
  end

  def prompt_the_user_for_the_output_grandparent_directory
    puts 'Under what directory do you want the output placed?'
  end

  def get_the_output_directory
    s=''
    until FileTest.directory?(s)
      puts "'#{s}' does not exist or is not a directory" unless s.empty?
      s=$stdin.gets.gsub('\\','/').strip.squeeze('/').chomp('/')
    end
    p s
    @output_directory=s
  end

  def set_the_text_report_input_file_name
    @report_input_file_name=@command_line_arguments.first
  end

  def set_the_text_report_output_grandparent_directory
    second_parameter=1
    @output_directory=@command_line_arguments.at(second_parameter)
  end

  def build_the_command
            d = @output_directory + '/' + @programs.at(
    @menu_item_number - 1).name_fragment.capitalize
    arguments="\"#{@report_input_file_name}\" \"#{d}\""
    @command=RunCommandLine.new(arguments,@programs.at(
    @menu_item_number - 1)).command
  end

  def echo_the_command
    puts 'Running command...'
    print @command
    print "\n" #Space line.
  end

  def run_the_command
    result=`#{@command}`
    print result
  end

  def stay_visible
    puts  'Please hit Enter when you have finished looking at this window.'
    gets
  end

  def run
    prompt_the_user_for_the_program
    get_the_menu_item

    if @programs.at(@menu_item_number - 1).user_selects_file
      prompt_the_user_for_the_report_input_file_name
      get_the_report_input_file_name
      prompt_the_user_for_the_output_grandparent_directory
      get_the_output_directory
    else
      set_the_text_report_input_file_name
      set_the_text_report_output_grandparent_directory
    end
    build_the_command
    echo_the_command
    run_the_command
    stay_visible
  end

  public :run

end #class RunPrograms.

class Program

  attr_reader :file_name,
    :menu_text,
    :name_fragment,
    :subdirectory,
    :user_selects_file

  def initialize(user_selects_file, menu_text, name_fragment, subdirectory, file_name)
                @user_selects_file,@menu_text,@name_fragment,@subdirectory,@file_name=
                 user_selects_file, menu_text, name_fragment, subdirectory, file_name
  end

end #class Program.

class CreatePrograms

  attr_reader :programs

  def initialize
    @programs=Array.new
    push(true, 'Sales analysis by items for a customer', 'customer-item-summary')
    push(true, 'Fast analysis - customers for an item',  'item-totals')
    push(true, 'Sales analysis by customers for an item','products-customers')
    push(false,'Fast analysis by customer sales volume', 'sales-volume')
    push(true, 'Work order history report',              'work-order-history')
   #push(false,'Test echo',                              'run-programs')
  end

  private

  def push(user_selects_file,menu_text,name_fragment)
    base=File.dirname(__FILE__) + '/../'
    subdirectory=base + name_fragment.capitalize + '/'
    s=name_fragment
    s += '2' if 'run-programs'==s
    file_name="realworld-excel-#{s}.rb"
    @programs.push(Program.new(user_selects_file,menu_text,name_fragment,subdirectory,file_name))
  end

end #class CreatePrograms.

class RunCommandLine

  attr_reader :command

  def initialize(arguments,program)
    ruby='s:/ruby/bin/ruby'
#    ruby='ruby'
    subdirectory=program.subdirectory
    file_name=program.file_name
    @command="#{ruby} #{subdirectory}#{file_name} #{arguments}"
  end

end #class RunCommandLine.

end #module RealWorldExcelRun.
