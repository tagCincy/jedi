require 'spec_helper'

describe Jedi::Config do

  around :example do |ex|
    FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
  end

  let(:paths) {["#{Dir.pwd}/components", "#{Dir.pwd}/components/vendor"]}
  let(:roots) {["#{Dir.pwd}/components/javascripts/application.js", "#{Dir.pwd}/components/stylesheets/application.css"]}
  let(:configs) {Jedi::Config.new}

  it 'should respond to #asset_paths' do
    expect(configs.asset_paths).to match_array paths
  end

  it 'should respond to #assets_roots' do
    expect(configs.asset_roots).to match_array roots
  end
end