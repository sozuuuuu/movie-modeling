require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "src"
  t.test_files = FileList["src/**/*_test.rb"]
end

task :default => :test
