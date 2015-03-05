require 'jedi'
require 'jedi/vendored_thor'
require 'fileutils'
require 'json'
require 'coffee-script'
require 'uglifier'
require 'sass'

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
      remove_last_build
      build_js
      build_css
    end

    private

    def base_dir
      Dir.pwd
    end

    def build_dir
      File.join(base_dir, 'build')
    end

    def assets_dir
      File.join(base_dir, 'app', 'assets')
    end

    def manifest
      json = JSON.parse(File.read(File.join(assets_dir, 'assets.json')))
      Struct.new(:js, :css).new(json['js'], json['css'])
    end

    def gather_assets(type, matchers, list)
      list.map { |l| Dir.glob(File.join(assets_dir, type, "#{l}.{#{matchers}}")) }.flatten
    end

    def build_js
      assets = gather_assets('javascript', JS_MATCHERS, manifest.js)

      combined = assets.map { |asset|
        src = File.read(asset)
        CoffeeScript.compile(src) if File.split(asset).last.include? '.coffee'
      }.join("\n")

      compiled = Uglifier.compile(combined)

      File.new(File.join(build_dir, 'javascript', "application.js"), 'w').write(compiled)
    end

    def build_css
      assets = gather_assets('stylesheets', CSS_MATCHERS, manifest.css)

      compiled = assets.map { |asset|
        Sass.compile(File.read(asset), style: :compressed)
      }.join("\n")

      File.new(File.join(build_dir, 'stylesheets', 'application.css'), 'w').write(compiled)
    end

    def remove_last_build
      FileUtils.rm_r(Dir.glob(File.join(build_dir, '*')))
      FileUtils.mkdir([File.join(build_dir, 'javascript'), File.join(build_dir, 'stylesheets')])
    end

  end
end