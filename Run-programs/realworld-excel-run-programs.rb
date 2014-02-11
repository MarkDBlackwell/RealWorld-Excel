=begin
This script was written to extract, for Excel spreadsheet work, some information
from certain reports.

Author: Mark Blackwell.
Written: Dec 19, 2007.
Client written for: Babikow Greenhouses Company (Baltimore, MD, http://www.babikow.com/).
Language: Ruby, version 'ruby-1.8.6-i386-mswin32'.

The software which produces the input report is called
Passport Business Solutions(TM) version 11.4.3.
It is accounting software based on, and informally known as, 'RealWorld'.
It was provided by Passport Software Inc. (http://www.pass-port.com/).

License: this script is distributed under the GNU General Public License (GPL).
See included in the package the file, gpl-3.0.txt, obtained originally from
http://www.gnu.org/licenses/gpl-3.0.txt.
=end

require File.dirname(__FILE__) + '/realworld-excel-run-programs-classes.rb'

                        text_report_input_file_name=
#'R:/RW32/file.txt'
'R:/RW32/try-file.txt'
                                                     text_report_output_grandparent_directory=
'U:/RW-Excel'
                                   command_line_arguments=
                       [text_report_input_file_name, text_report_output_grandparent_directory]
RealWorldExcelRun::RunPrograms.new(command_line_arguments).run
