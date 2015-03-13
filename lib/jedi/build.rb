module Jedi

  require 'yaml'

  class Build

    def initialize(env)
      @env = env || 'dev'
      @build = YAML.load(File.read(File.join(Dir.pwd, "app", "config", "build.yml")))[@env]
    end

    def user
      @build['username']
    end

    def password
      "#{@build['password']}"
    end

    def token
      "#{@build['token']}"
    end

    def url
      @build['url']
    end

    def poll
      @build['poll']
    end


    def props_string
      "-Dsf.username=#{user} -Dsf.password=#{password} -Dsf.token=#{token} -Dsf.serverurl=#{url} -Dsf.maxPoll=#{poll}"
    end
  end
end