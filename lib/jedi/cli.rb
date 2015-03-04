require 'jedi'
require 'jedi/vendored_thor'
require 'fileutils'
require 'json'
require 'uglifier'

module Jedi

  class CLI < Thor
    include Thor::Actions

    JS_MATCHERS = "coffee, js"
    CSS_MATCHERS = "scss, sass, css"

    def self.start(*)
      super
    rescue Exception => e
      raise e
    end

    desc 'new APP_NAME', 'generate a new Force.com app'
    def new(name)
      FileUtils.mkdir name
      FileUtils.cp_r "#{base_dir}/template/.", name, preserve: true
    end

    desc 'build', 'generates application and vendor JS files'
    def build
      build_js
    end

    private

    def base_dir
      Dir.pwd
    end

    def manifest
      json = JSON.parse(File.read(File.join(base_dir, 'app', 'assets', 'assets.json')))
      Struct.new(:js, :css).new(json['js'], json['css'])
    end

    def gather_assets(type, matchers, list)
      list.map { |l| Dir.glob(File.join(base_dir, 'assets', type, "#{l}.{#{matchers}}")) }.flatten
    end

    def build_js
      assets = gather_assets('javascript', JS_MATCHERS, manifest.js)
      combined = assets.map do |asset|
        src = File.read(asset)
        CoffeeScript.compile(src) if File.split(asset).last.include? '.coffee'
      end
      compiled = Uglifier.compile(combined)
      File.new(File.join(base_dir, 'build', 'javascript', "application-#{Time.now.iso8601}.js"), 'w').write(compiled)
    end

  end
end