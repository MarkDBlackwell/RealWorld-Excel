require 'rake/testtask'

task :default =>  [:all]

programs = %w[
  customer-item-summary
  item-totals
  products-customers
  sales-volume
  work-order-history
]
ProgramSet=Struct.new(:task, :which_programs)

def single_program(       programs,       i)
          [ProgramSet.new(programs.at(    i)    , i..i),
           ProgramSet.new(brief='test-' + i.to_s, i..i)]
end

def program_pairs(programs)
  pairs=Array.new
  programs.length.times {|i| i.times {|k| pairs << [k,i]}}
  pairs.collect {|a| ProgramSet.new('test-' + a.join, a)}
end

slow_programs=Array[programs.index(
 'products-customers')]

end_to_end_tests=(r=0...programs.length).collect {|i| single_program(programs,i)} <<
program_pairs(programs) <<
ProgramSet.new('fast',r.to_a - slow_programs) <<
ProgramSet.new('all' ,r)

parent = File.expand_path(File.dirname(__FILE__) + '/..')

end_to_end_tests.flatten.each do |e| Rake::TestTask.new(e.task) {|t|
    t.libs = Array[parent + '/pkg'] + directories = e.which_programs.to_a.collect {|i| parent + '/' + programs.at(i).capitalize}
    t.test_files = FileList.new(      directories.collect {|s| s + '/tests/*.rb'})
    t.warning = true
  }
end
