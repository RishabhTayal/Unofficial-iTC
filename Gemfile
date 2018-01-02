source "https://rubygems.org"

gem "cocoapods"
# gemspec path: File.expand_path("<PATH_TO_YOUR_LOCAL_FASTLANE_CLONE>")
gem 'danger'
gem 'fastlane',  :git => 'https://github.com/fastlane/fastlane'
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
