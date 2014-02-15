guard :rspec , :cmd => "rspec --color --format nested --drb" do
  notification :growl
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/acceptance/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/kicker/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end


