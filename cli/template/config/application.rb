require 'noodles'

%w(controllers handlers channels).each do |app_folder|
  app_folder_path = File.join(File.dirname(__FILE__), "..", "app", app_folder)
  $LOAD_PATH << app_folder_path
  Dir[File.join(app_folder_path, "*.rb")].each {|file| require file }
end