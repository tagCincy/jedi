require 'jedi'
require 'fileutils'
require 'thor'
require 'sprockets'
require 'sprockets-sass'
require 'uglifier'
require 'sass'

module Jedi

  class CLI < Thor
    include Thor::Actions

    def self.start(*)
      super
    rescue Exception => e
      raise e
    end

    desc 'init', "initialize jedi"
    method_option :dir, alias: "-d", desc: "where to install resource components (defaults to current directory)"

    def init
      target_dir = options[:dir] || base_dir
      FileUtils.cp_r template_dir, target_dir
    end

    desc 'compile', 'compiles and concats assets'

    def compile
      @asset_paths = Array([components_path, vendor_path])
      @destination = "#{build_path}/components"
      @root_file = Array(["#{components_path}/javascripts/application.js", "#{components_path}/javascripts/vendor.js",
                          "#{components_path}/stylesheets/application.css"])

      @sprockets = ::Sprockets::Environment.new
      @asset_paths.each { |p| @sprockets.append_path(p) }
      @root_file.each { |f| @sprockets.append_path(Pathname.new(f).dirname) }
      @sprockets.js_compressor = :uglifier
      @sprockets.css_compressor = :scss

      paths = @root_file unless @root_file.empty?

      paths.each do |file|
        sprocketize(file)
      end
    end

    private

    def gem_dir
      File.expand_path(File.dirname(__FILE__))
    end

    def base_dir
      Dir.pwd
    end

    def template_dir
      "#{gem_dir}/template/."
    end

    def components_path
      "#{base_dir}/components"
    end

    def vendor_path
      "#{base_dir}/components/vendor"
    end

    def build_path
      "#{base_dir}/build"
    end

    def sprocketize(path)
      path = Pathname.new(path)

      output_filename = without_preprocessor_extension @asset_paths.find_all { |p| path.to_s.start_with?(p) }
                                             .collect { |p| Pathname.new(p) }
                                             .collect { |p| path.relative_path_from(p) }
                                             .min_by { |p| p.to_s.size }
                                             .to_s

      output_path = Pathname.new File.join(@destination, output_filename)

      FileUtils.mkdir_p(output_path.parent) unless output_path.parent.exist?

      output_path.open('w') { |f| f.write @sprockets[output_filename] }

      puts "Sprockets compiled #{output_filename}"
    rescue ExecJS::ProgramError => ex
      puts "Sprockets failed compiling #{output_filename}!", priority: 2, image: :failed
      false
    end

    def without_preprocessor_extension(filename)
      filename.gsub /^(.*\.(?:js|css))\.[^.]+(\.erb)?$/, '\1'
    end
  end
end