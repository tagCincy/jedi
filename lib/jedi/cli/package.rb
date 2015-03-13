require 'fileutils'
require 'zip'
require 'nokogiri'

module Jedi
  class CLI::Package
    attr_reader :options

    def initialize(opts)
      @options = opts
      Dir.exist?(output_path) ? FileUtils.rm_r(Dir.glob("#{output_path}/*")) : FileUtils.mkdir_p(output_path)
    end

    def run
      create_archive
      create_meta_xml
    end

    private

    def create_archive
      entries = get_sub_dirs(components_path)
      io = Zip::File.open(resources_archive, Zip::File::CREATE)
      write_entries(entries, io)
      io.close
    end

    def create_meta_xml
      meta_xml = Nokogiri::XML(File.read(File.join(meta_path, "staticresource.xml")))
      meta_xml.at_css("fullName").content = @options[:name]
      local_build_file = File.join(output_path, "#{@options[:name]}.resource-meta.xml")
      File.open(local_build_file, "w") { |f| f.write(meta_xml)}
    end

    def write_entries(entries, io, path="")
      entries.each { |entry|
        zip_path = path.empty? ? entry : File.join(path, entry)
        disk_path = File.join(components_path, zip_path)

        if File.directory?(disk_path)
          io.mkdir(zip_path)
          sub_dir = get_sub_dirs disk_path
          write_entries(sub_dir, io, zip_path)
        else
          io.get_output_stream(zip_path) { |f| f.print(File.read(disk_path))}
        end
      }
    end

    def get_sub_dirs path
      @dirs = Dir.entries(path); @dirs.delete("."); @dirs.delete("..")
      @dirs
    end

    def components_path
      "#{Dir.pwd}/build/components"
    end

    def output_path
      "#{Dir.pwd}/app/src/staticresources"
    end

    def resources_archive
      "#{output_path}/#{@options[:name]}.resource"
    end

    def gem_path
      File.expand_path("..", File.dirname(__FILE__))
    end

    def meta_path
      "#{gem_path}/meta"
    end
  end
end