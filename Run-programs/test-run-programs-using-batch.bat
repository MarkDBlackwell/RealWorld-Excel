echo off
c:
cd \Mark-develop\checkout\trunk\RealWorld-Excel
rem s:\ruby\bin\ruby pkg\test-all.rb
rem s:\ruby\bin\ruby Products-customers\realworld-excel-products-customers.rb %1 %2
rem s:\ruby\bin\ruby -e "p ARGV" %1 %2


s:\ruby\bin\ruby -e "p ARGV" %1 %2

echo Close this window after reading.
pause
