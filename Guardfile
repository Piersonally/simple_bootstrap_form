# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', all_on_start: false, all_after_pass: false , failed_mode: :keep do
  watch(%r{^spec/.+_spec\.rb$})
  #watch(%r{^lib/(.+)\.rb$})     { |m| "spec#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/simple_bootstrap_form_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :markdown, convert_on_start: true do
  watch(/(README)\.md/) { |match| "#{match[1]}.md|tmp/#{match[1]}.html" }
end
