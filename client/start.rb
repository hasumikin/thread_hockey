require 'yaml'
Dir[File.expand_path('../lib', __FILE__) << '/*.rb'].each do |file|
  require file
end

config = YAML.load_file(File.dirname(__FILE__) + '/config.yml')

Main.new(config['host'])
