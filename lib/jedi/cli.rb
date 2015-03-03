require 'jedi'
require 'jedi/vendored_thor'
require 'fileutils'

module Jedi

  class CLI < Thor
    include Thor::Actions


    def self.start(*)
      super
    rescue Exception => e
      raise e
    end

    desc 'new APP_NAME', 'generate a new Force.com app'
    def new(name)
      base_dir = File.expand_path(File.dirname(__FILE__))
      FileUtils.mkdir name
      FileUtils.cp_r "#{base_dir}/template/.", name
      puts "Hello #{name}"
    end


  end
end