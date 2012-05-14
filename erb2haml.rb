require 'optparse'

class Erb2Haml

  def initialize
    check_for_dependencies

    @files = []
    @paths = []
    @options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: erb2haml.rb [options] [path1, path2, ...]' + "\n" +
                    'pathN - path to directory, if no paths are present the script\'s directory is used'

      opts.on('-f', '--force', 'Force delete source ERB files after being converted') do |option|
        @options[:force] = true
      end
      opts.on('-v', '--verbose', 'Verbose output') do |option|
        @options[:verbose] = true
      end
      opts.on('-g', '--git_delete', 'Performs a git rm instead of system rm') do |option|
        @options[:git_delete] = true
      end
      opts.on('-e', '--files', 'operates on supplied file or files, not all files in a path') do |option|
        @options[:files] = true
      end
    end.parse!

    if @options[:files]
      ARGV.each {|argument|  @files.push argument if File.exists? argument }
    else
      ARGV.each {|argument|  @paths.push argument if File.exists? argument }
    end

    @paths.push Dir.pwd if @paths.empty? #dir that script was called from 
  end


  def check_for_dependencies
    has_error = false
    if `which html2haml`.empty?
      puts "ERROR: html2haml is not installed, try first:\t gem install haml"
      has_error = true
    end
    gem_list = `gem list`
    if not gem_list.include? 'hpricot'
      puts "ERROR: hpricot is not installed, try first:\t gem install hpricot"
      has_error = true
    end
    exit false if has_error
  end


  def run
    @options[:files] ? run_on_files : run_on_paths
  end

  def run_on_files
    @files.each do |file|
      execute(file)
    end
  end

  def run_on_paths
    @paths.each do |path|
      puts path
      Dir["#{path}/**/*.erb"].each do |file|
        execute(file)
      end
    end
  end

  def execute(file)
    puts "Converting: #{file}..." if @options[:verbose]

    `html2haml -e #{file} #{file.gsub(/\.erb$/, '.haml')}`

    if @options[:force]
      puts "Deleting: #{file}" if @options[:verbose]
      `#{delete_command} #{file}`
    end
  end

  def delete_command
    @options[:git_delete] ? "git rm" : "rm -rf"
  end

end

task = Erb2Haml.new
task.run
