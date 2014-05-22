require 'thor'
require 'pry'
class NoodlesCLI < Thor
  desc "new app_name", "creates a boilerplate Noodles folder structure"
  def new(app_name)
    # FileUtils.mkdir(app_name, verbose: true)
    template_path = File.expand_path('../template', __FILE__)
    wildcard_path = File.join(template_path, "**", "**")
    # puts all_files
    # binding.pry
    all_paths = Dir[wildcard_path]

    # first_path = all_paths.first

    command_line_path = FileUtils.pwd

    # binding.pry

    # puts __FILE__
    temp_path = Pathname.new(template_path)

    all_paths.each do |string_path|
      puts File.directory?(string_path)
      path = Pathname.new string_path
      puts path.relative_path_from(temp_path).to_s
    end
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