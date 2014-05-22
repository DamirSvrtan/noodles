require 'thor'
require 'pry'
require 'find'

class NoodlesCLI < Thor
  desc "new app_name", "creates a boilerplate Noodles folder structure"
  def new(app_name)
    # FileUtils.mkdir(app_name, verbose: true)
    template_path = Pathname.new File.expand_path('../template', __FILE__)
    # wildcard_path = Pathname.new File.join(template_path, "**", "**")


    # puts all_files
    # binding.pry
    all_paths = Find.find(template_path).map {|path| Pathname.new(path)}

    all_paths = all_paths[1..-1]
    # first_path = all_paths.first

    command_line_path = FileUtils.pwd

    # binding.pry

    # puts __FILE__
    # temp_path = Pathname.new(template_path)

    FileUtils.mkdir(app_name, verbose: true)

    all_paths.each do |path|
      # puts path.directory?
      rel_path = path.relative_path_from(template_path).to_s
      rel_path = File.join app_name, rel_path
      # FileUtils.cd(app_name) do
      if path.directory?
        FileUtils.mkdir(rel_path, verbose: true)
      else
        File.open(rel_path, 'w') {|file| file.write(File.read(path))}
      end
      # end

      # puts rel_path
      # rel_path
    end
    # binding.pry
    # FileUtils.cd(app_name) do
    #   folders(app_name).each do |folder|
    #     FileUtils.mkdir(folder,verbose: true)
    #   end
    # end
  end

  desc "start", "start the server"
  option :port, aliases: :p
  def start
    basic_command =  "thin -R config.ru start"
    basic_command << " -p #{options[:port]}" if options[:port]
    `#{basic_command}`
  end

  private

    def folders(app_name)
      [
        File.join("app"),
        File.join("config"),
        File.join("public"),
        File.join("app", "controllers"),
        File.join("app", "handlers"),
        File.join("app", "views"),
        File.join("app", "templates"),
        File.join("public", "css"),
        File.join("public", "images"),
        File.join("public", "js"),
      ]
    end
end