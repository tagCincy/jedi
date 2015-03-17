require 'spec_helper'

describe Jedi::CLI::Init do

  let(:init) { Jedi::CLI::Init.new(name: 'Test') }

  it 'should set the @options variable' do
    expect(init.instance_variable_get(:@options)[:name]).to eql('Test')
  end

  it 'should generate a new app directory named Test' do
    init.run
    expect(File.directory?('Test')).to be_truthy
  end

end