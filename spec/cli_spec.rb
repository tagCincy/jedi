require 'spec_helper'

describe Jedi::CLI do

  subject(:cli) { Jedi::CLI.new }

  context '#new' do
    around :example do |ex|
      @project_name = 'Test'; ex.run; FileUtils.rm_r @project_name
    end

    it 'creates a new project' do
      cli.new(@project_name)
      expect(File.directory?(@project_name)).to be_truthy
    end
  end

  context '#clean' do
    around :example do |ex|
      FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
    end

    it 'cleans the build directory' do
      cli.clean
      expect(Dir.glob(File.join("build", "components", "**"))).to be_empty
    end
  end

  context '#compile' do
    around :example do |ex|
      FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
    end

    it 'should compile coffeescript into minified javascript' do
      cli.compile
      expect(File.read("build/components/javascripts/application.js")).to eql(File.read(File.join(fixtures, "application.js")))
    end

    it 'should compile sass into minified css' do
      cli.compile
      expect(File.read("build/components/stylesheets/application.css")).to eql(File.read(File.join(fixtures, "application.css")))
    end

    it 'should compile haml into html' do
      cli.compile
      expect(File.read("build/components/templates/buzz.html")).to eql(File.read(File.join(fixtures, "buzz.html")))
    end
  end

  context '#package' do
    around :example do |ex|
      FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
    end

    it 'should create resources archive' do
      cli.package('Test')
      expect(File.exist?(File.join(staticresources, 'Test.resource'))).to be_truthy
    end

    it 'should create resource-meta.xml' do
      cli.package('Test')
      expect(File.exist?(File.join(staticresources, 'Test.resource-meta.xml'))).to be_truthy
    end

  end

  context '#build' do
    around :example do |ex|
      FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
    end

    it 'should compile coffeescript into minified javascript' do
      cli.compile
      expect(File.read("build/components/javascripts/application.js")).to eql(File.read(File.join(fixtures, "application.js")))
    end

    it 'should compile sass into minified css' do
      cli.compile
      expect(File.read("build/components/stylesheets/application.css")).to eql(File.read(File.join(fixtures, "application.css")))
    end

    it 'should compile haml into html' do
      cli.compile
      expect(File.read("build/components/templates/buzz.html")).to eql(File.read(File.join(fixtures, "buzz.html")))
    end

    it 'should create resources archive' do
      cli.package('Test')
      expect(File.exist?(File.join(staticresources, 'Test.resource'))).to be_truthy
    end

    it 'should create resource-meta.xml' do
      cli.package('Test')
      expect(File.exist?(File.join(staticresources, 'Test.resource-meta.xml'))).to be_truthy
    end
  end

end