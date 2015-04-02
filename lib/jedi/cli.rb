require 'jedi'
require 'fileutils'
require 'thor'

class Jedi::CLI < Thor
  include Thor::Actions

  def self.start(*)
    super
  rescue Exception => e
    raise e
  end

  desc "new NAME", "creates a new, default Force.com project"

  def new(name)
    require 'jedi/cli/init'
    invoke Init, [name]
    # Init.new(name: name).run
  end

  desc "init", "add resource management to Force.com project"
  def init
    require 'jedi/cli/init'
    invoke Init
  end

  desc "build", "compiles all assets and creates resources archive"
  method_option :name, aliases: "-n", desc: "Force.com StaticResource package name", default: "Assets"

  def build
    invoke :compile
    invoke :package, options[:name]
  end

  desc 'compile', 'compile, concat and minify JS, CSS and HTML assets'
  method_option :only, aliases: "-o", type: :array, enum: %w(js css html), desc: "selective which asset types to compile", required: false

  def compile
    invoke :clean, [], only: options[:only]

    require 'jedi/cli/compile'
    Compile.new(only: options[:only]).run
  end

  desc 'package NAME', 'package assets into Force.com StaticResource archive'

  def package(name="Assets")
    require 'jedi/cli/package'
    Package.new(name: name).run
  end

  desc 'clean', 'clean compiled assets'
  method_option :only, aliases: "-o", type: :array, enum: %w(js css html), desc: "select which asset types to clean", required: false

  def clean
    require 'jedi/cli/clean'
    Clean.new(options).run
  end

  desc "meta COMMAND", "run a Force.com Metadata Migration Command"
  method_option "env", aliases: "-e", type: "string", default: "dev", desc: "which Salesforce environment to connect"
  method_option "build", aliases: "-b", type: "string", desc: "use a custom build file", required: false

  def meta(command="describe")
    require 'jedi/cli/meta'
    Meta.new(options.merge({command: command})).run
  end

  desc "generate TYPE NAME", "generate a new Force.com object"

  def generate(type, name)
    binding.pry
  end

  # desc "bower_install PKG", "install bower package in the /components/vendor"
  # def bower_install(pkg)
  #   bower_version = `bower --v` rescue nil
  #
  #   if bower_version.nil?
  #     if (`npm --v` rescue nil).nil?
  #       puts "Please install NPM before continuing"
  #       false
  #     end
  #
  #     IOP
  #
  #
  #   end
  # end

end
