require 'fileutils'
require 'nokogiri'

class Jedi::CLI::Init
  attr_reader :options

  def initialize(opts)
    @options = opts
  end

  def run
    FileUtils.cp_r template_path, base_path

    build_xml = Nokogiri::XML(File.read(File.join(ant_path, "build.xml")))
    build_xml.css("project").attr("name").value = @options[:name]
    local_build_file = File.join(config_path, "build.xml")
    File.open(local_build_file, "w") { |f| f.write(build_xml) }
  end

  private

  def gem_path
    File.expand_path("..", File.dirname(__FILE__))
  end

  def ant_path
    "#{gem_path}/ant"
  end

  def template_path
    "#{gem_path}/template/."
  end

  def base_path
    "#{Dir.pwd}/#{@options[:name]}"
  end

  def config_path
    "#{base_path}/app/config"
  end

end
