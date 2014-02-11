#Run this by:
# ruby <this-program> <test-input-file>

special=ARGF
puts special.gets

puts "Please type 'ab'."
puts "Okay, was 'ab'." if 'ab'==$stdin.gets.chomp
$stderr.puts 'Please hit Enter after reading this message.'
$stdin.gets
