require 'optparse'

class Erb2Haml
  @@paths = []
  @@options = {}

  def initialize
    OptionParser.new do |opts|
      opts.banner = "Usage: erb2haml.rb [options] [path1, path2, ...]
path could be both filepath or path to directory, if no paths are present the script's directory is used'"

      opts.on("-f", "--force", "Force delete source ERB files after being converted") do |f|
        @@options[:force] = true
      end
    end.parse!

    ARGV.each do |a|
      @@paths.push a if File.exists? a
    end
    @@paths.push(File.dirname(__FILE__)) if @@paths.empty?
  end

  def run
    @@paths.each do |path|
      Dir["#{path}/**/*.erb"].each do |file|
        `html2haml -e #{file} #{file.gsub(/\.erb$/, '.haml')}`
        `rm -rf #{file}` if @@options[:force]
      end
    end
  end
end

task = Erb2Haml.new
task.run
