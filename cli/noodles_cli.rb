require 'thor'
require 'pry'
class NoodlesCLI < Thor
  desc "new app_name", "creates a boilerplate Noodles folder structure"
  def new(app_name)
    FileUtils.mkdir(app_name, verbose: true)
    templates_path = File.expand_path "../template", __FILE__
    puts templates_path

    FileUtils.cd(app_name) do
      FileUtils.cp_r templates_path, FileUtils.pwd, dereference_root: true
    end
    # folders(app_name).each do |folder|
    #   FileUtils.mkdir(folder,verbose: true)
    # end
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
        File.join("public", "css"),
        File.join("public", "images"),
        File.join("public", "js"),
      ]
    end
end