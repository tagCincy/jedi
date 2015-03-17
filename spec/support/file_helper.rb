module FileHelper

  def root
    @root ||= Pathname.new(File.expand_path("../..", __FILE__))
  end

  def fixtures
    root.join("fixtures")
  end

  def tmp
    root.join("tmp")
  end

  def sample
    root.join(tmp, "sample")
  end

  def app
    root.join(sample, "app")
  end

  def src
    root.join(app, "src")
  end

  def staticresources
    root.join(src, "staticresources")
  end
end