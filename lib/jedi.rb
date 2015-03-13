require "jedi/version"
require 'pry'

module Jedi
  autoload :Config,   'jedi/config'
  autoload :Build,    'jedi/build'

  class << self
    attr_writer :config

    def config
      @config ||= Config.new
    end
  end
end
