class Jedi::CLI::Meta

  attr_reader :buildfile, :config, :command

  def initialize(opts)
    @buildfile = opts[:build] || "#{config_path}/build.xml"
    @command = opts[:command]
    @config = Build.new(opts[:env])
  end

  def run
    IO.popen "ant #{@command} -lib #{ant_lib} -f #{@buildfile} #{@config.props_string}" do |io|
      io.each { |line| puts line }
    end
  end

  private

  def app_base
    "#{Dir.pwd}/app"
  end

  def config_path
    "#{app_base}/config"
  end

  def ant_lib
    "#{File.expand_path("..", File.dirname(__FILE__))}/ant/ant-salesforce.jar"
  end
end
