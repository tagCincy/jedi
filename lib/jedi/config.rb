module Jedi

  require 'yaml'

  class Config
    attr_reader :config

    def initialize
      @config = YAML.load(File.read(File.join(Dir.pwd, "app", "config", "config.yml")))
    end

    def asset_paths
      @config['asset_paths'].map { |p| File.expand_path p}
    end

    def asset_roots
     asset_paths.map {|p| Dir.glob(File.join(p, "**", "{#{@config['asset_roots'].join(',')}}"))}.flatten
    end
  end
end