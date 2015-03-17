require 'spec_helper'

describe Jedi::Build do

  around :example do |ex|
    FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
  end

  let(:build) { Jedi::Build.new('dev') }
  let(:instance) { @build }

  context 'respond_to methods' do

    it 'should respond to #user' do
      expect(build).to respond_to :user
    end

    it 'should respond to #password' do
      expect(build).to respond_to :password
    end

    it 'should respond to #token' do
      expect(build).to respond_to :token
    end

    it 'should respond to #url' do
      expect(build).to respond_to :url
    end

    it 'should respond to #poll' do
      expect(build).to respond_to :poll
    end

    it 'should respond to #props_string' do
      expect(build).to respond_to :props_string
    end

  end

  context 'instance matching' do

    let(:instance) { build.instance_variable_get(:@build) }

    it '#user should pass obj["username"]' do
      expect(build.user).to eql(instance['username'])
    end

    it '#password should pass obj["password"]' do
      expect(build.password).to eql(instance['password'])
    end

    it '#token should pass obj["token"]' do
      expect(build.token).to eql(instance['token'])
    end

    it '#url should pass obj["url"]' do
      expect(build.url).to eql(instance['url'])
    end

    it '#poll should pass obj[:poll]' do
      expect(build.poll).to eql(instance['poll'])
    end

    it '#props_string should pass formatted string' do
      formatted_string = "-Dsf.username=#{instance['username']} -Dsf.password=#{instance['password']} -Dsf.token=#{instance['token']} -Dsf.serverurl=#{instance['url']} -Dsf.maxPoll=#{instance['poll']}"
      expect(build.props_string).to eql(formatted_string)
    end
  end

end