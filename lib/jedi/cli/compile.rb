require 'sprockets'
require 'sprockets-sass'
require 'uglifier'
require 'sass'
require 'haml'

class Jedi::CLI::Compile

  attr_reader :options, :asset_paths, :asset_roots
  attr_accessor :environment

  def initialize(opts)
    @options = opts
    @asset_paths = Jedi.config.asset_paths
    @asset_roots = Jedi.config.asset_roots
    @environment = set_sprockets
  end

  def run
    @options[:only].nil? ? compile_all : @options[:only].each { |type| send("compile_#{type}") }
  end

  private

  def destination_path
    "#{Dir.pwd}/build"
  end

  def templates_path
    "#{Dir.pwd}/resources/templates"
  end

  def compile_all
    compile_js
    compile_css
    compile_html
  end

  def compile_js
    root_files = @asset_roots.select { |root| root.end_with? '.js' }
    root_files.each { |f| @environment.append_path(Pathname.new(f).dirname) }
    root_files.each { |file| sprocketize(file) }
  end

  def compile_css
    root_files = @asset_roots.select { |root| root.end_with? '.css' }
    root_files.each { |f| @environment.append_path(Pathname.new(f).dirname) }
    root_files.each { |file| sprocketize(file) }
  end

  def compile_html
    matcher = "/**/*.{haml,html}"
    destination = "#{destination_path}/templates"

    Dir.glob(File.join(templates_path, matcher)).each do |temp|
      path, name = File.split temp
      sub_path = temp.sub templates_path, ""
      contents = File.read temp

      if name.end_with? '.haml'
        part = sub_path.partition(".haml").first
        sub_path = part.end_with?(".html") ? part : "#{part}.html"
        contents = Haml::Engine.new(contents).render
      end

      destination_path = Pathname.new(File.join(destination, sub_path))
      FileUtils.mkdir_p(destination_path.parent) unless destination_path.parent.exist?
      destination_path.open('w') { |f| f.write contents }
    end
  end

  def sprocketize(path)
    path = Pathname.new(path)
    output_filename = @asset_paths.find_all { |p| path.to_s.start_with?(p) }
                          .collect { |p| Pathname.new(p) }
                          .collect { |p| path.relative_path_from(p) }
                          .min_by { |p| p.to_s.size }
                          .to_s

    output_path = Pathname.new File.join(destination_path, output_filename)
    FileUtils.mkdir_p(output_path.parent) unless output_path.parent.exist?
    output_path.open('w') { |f| f.write @environment[output_filename] }
  rescue ExecJS::ProgramError => ex
    puts ex.message
    false
  end

  def set_sprockets
    env = Sprockets::Environment.new
    @asset_paths.each { |p| env.append_path(p) }
    env.css_compressor = :sass
    env.js_compressor = :uglifier
    env
  end
end
