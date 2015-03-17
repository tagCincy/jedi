$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib/', __FILE__)
Dir.glob(File.join(Dir.pwd, "lib", "**", "*#{File::Separator}")).each { |f| $:.unshift f }

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'fileutils'

Dir.glob(File.join(Dir.pwd, "lib", "**", "*.rb")).sort.each do |f|
  require f
end

Dir["#{File.expand_path('../support', __FILE__)}/*.rb"].each do |f|
  require f
end

RSpec.configure do |config|

  config.include FileHelper

  config.before :suite do
    FileUtils.chdir "spec"
  end

  config.before :all do
    FileUtils.mkdir_p "tmp"
    FileUtils.cp_r( "fixtures/sample/", "tmp")
    FileUtils.chdir "tmp"
  end

  config.after :all do
    FileUtils.chdir ".."
    FileUtils.rm_rf "tmp"
  end

end
