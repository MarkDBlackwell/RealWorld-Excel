ruby='s:/ruby/bin/ruby'
base='c:/Mark-develop/checkout/trunk/RealWorld-Excel/Run-programs/'
program='test-run-programs2.rb'
arguments='aa bbbb'
command="#{ruby} #{base}#{program} #{arguments}"
p command
result=`#{command}`
print result
