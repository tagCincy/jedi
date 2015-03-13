module Jedi

  require 'fileutils'

  class CLI::Clean

    attr_reader :options

    ASSET_DIRS = {js: 'javascripts', css: 'stylesheets', html: 'templates'}

    def initialize(opts)
      @options = opts
    end

    def run
      @options[:only].nil? ? clean('*') : @options[:only].each { |type| clean(ASSET_DIRS.fetch(type.to_sym)) }
    end

    private

    def clean(dir)
      FileUtils.rm_r Dir.glob(File.join(build_path, dir))
    end

    def build_path
      "#{Dir.pwd}/build/components"
    end
  end
end