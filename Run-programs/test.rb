require File.dirname(__FILE__) + '/realworld-excel-run-programs-classes.rb'

                        text_report_input_file_name=
#'R:/RW32' + '/' +
'C:/Mark-develop/static/RealWorld-Excel/Sales-volume' + '/' +
'file.txt'
                                                     text_report_output_grandparent_directory=
#'U:/RW-Excel'
'C:/Mark-develop/output/RealWorld-Excel'
                                   command_line_arguments=
                       [text_report_input_file_name, text_report_output_grandparent_directory]
RealWorldExcelRun::RunPrograms.new(command_line_arguments).run
