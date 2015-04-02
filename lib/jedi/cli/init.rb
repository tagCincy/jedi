class Jedi::CLI::Init < Thor::Group
  include Thor::Actions

  # argument :name, type: :string, desc: "name of the Force.com project"
  # desc "creates a new Force.com project"

  def self.source_root
    File.dirname(__FILE__)
  end

  def init
    directory template_path, base_path
  end

  private

  def gem_path
    File.expand_path("..", File.dirname(__FILE__))
  end

  def ant_path
    "#{gem_path}/ant"
  end

  def template_path
    "#{gem_path}/template"
  end

  def base_path
    Dir.pwd
  end

  def config_path
    "#{base_path}/app/config"
  end

end
