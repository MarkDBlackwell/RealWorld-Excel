=begin
This script was written to extract, for Excel spreadsheet work, some information
from a certain report.

Author: Mark Blackwell.
Written: Jan 22, 2008.
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

s=File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << s unless $LOAD_PATH.include?(s)
require 'realworld-excel-work-order-history-classes.rb'

=begin
Should be run by a menu-driven or other program which provides the following arguments:
command_line_arguments=[input_file_name         = 'some-complete-file-name.html',
                        output_parent_directory = 'some-complete-file-directory-name']
=end

RealWorldExcel::ConvertWorkOrderHistory.new(
command_line_arguments=ARGV,
console=Array[$stdin,$stderr]
).run
