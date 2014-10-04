Dir[File.expand_path('../lib', __FILE__) << '/*.rb'].each do |file|
  require file
end

Main.new
