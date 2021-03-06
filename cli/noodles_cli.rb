require 'thor'
require 'pry'
require 'find'
require 'irb'
require 'colorize'

class NoodlesCLI < Thor
  include Thor::Actions

  desc "new app_name", "creates a boilerplate Noodles folder structure"
  def new(app_name)
    template_path = Pathname.new File.expand_path('../template', __FILE__)

    all_paths = Find.find(template_path).map {|path| Pathname.new(path)}
    all_paths = all_paths[1..-1] # remove '.'

    create_dir(app_name)

    all_paths.each do |abs_path|
      rel_path = abs_path.relative_path_from(template_path).to_s
      rel_path = File.join app_name, rel_path
      create_file_or_dir(abs_path, rel_path)
    end

    bundle_install(app_name)
    git_init(app_name)
  end

  desc "start", "start the server"
  option :port, aliases: :p
  def start
    if File.exist?('config.ru')
      basic_command =  "thin -R config.ru start"
      basic_command << " -p #{options[:port]}" if options[:port]
      run basic_command, verbose: false
    else
      puts "No config.ru file present."
    end
  end

  desc "console", "starts the interactive console"
  def console
    init_path = File.expand_path "config/init.rb"
    if File.exist?(init_path)
      require init_path
      Pry.start
    else
      puts "No config/init.rb file present."
    end
  end

  private

    def create_file_or_dir(abs_path, rel_path)
      if abs_path.directory?
        create_dir(rel_path)
      else
        create_file(abs_path, rel_path)
      end
    end

    def create_dir(rel_path)
      FileUtils.mkdir(rel_path)
      echo(:mkdir, rel_path)
    end

    def create_file(abs_path, rel_path)
      File.open(rel_path, 'w') {|file| file.write(File.read(abs_path))}
      echo(:create, rel_path)
    end

    def echo(action, subject)
      line = "#{adjust(action).colorize(:green).bold} #{subject}"
      puts line
    end

    def adjust(action)
      action.to_s.rjust(8, " ")
    end

    def bundle_install(app_name)
      echo(:run, 'bundle install')
      run "cd #{app_name} && bundle install", verbose: false
    end

    def git_init(app_name)
      unless `which git`.empty?
        echo(:run, 'git init')
        run "cd #{app_name} && git init", verbose: false
      end
    end
end