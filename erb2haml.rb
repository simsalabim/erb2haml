require 'optparse'

class Erb2Haml

  def initialize
    check_for_required_gems

    @paths = []
    @options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: erb2haml.rb [options] [path1, path2, ...]' + "\n" +
                    'pathN - path to directory, if no paths are present the script\'s directory is used'

      opts.on('-f', '--force', 'Force delete source ERB files after being converted') do |option|
        @options[:force] = true
      end
      opts.on('-v', '--verbose', 'Describe actions script will do') do |option|
        @options[:verbose] = true
      end
    end.parse!

    ARGV.each do |argument|
      @paths.push argument if File.exists? argument
    end
    @paths.push File.dirname(__FILE__) if @paths.empty?
  end


  def check_for_required_gems
    if `which html2haml`.empty?
      puts 'ERROR: html2haml is not installed' + "\n" + 'Try first: gem install haml'
      exit false
    end
    gem_list = `gem list`
    if not gem_list.include? 'hpricot'
      puts 'ERROR: hpricot is not installed' + "\n" + 'Try first: gem install hpricot'
      exit false
    end
  end


  def run
    @paths.each do |path|
      Dir["#{path}/**/*.erb"].each do |file|
        puts "Converting: #{file}..." if @options[:verbose]
        `html2haml -e #{file} #{file.gsub(/\.erb$/, '.haml')}`
        if @options[:force]
          `rm -rf #{file}`
          puts "Deleted: #{file}" if @options[:verbose]
        end
      end
    end
  end

end

task = Erb2Haml.new
task.run
