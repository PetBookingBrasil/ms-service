desc "Print out routes"
task :routes => :environment do
  Microservices::API.routes.each do |route|
    info = route.instance_variable_get :@options
    description = "%-40s..." % info[:description][0..39]
    method = "%-7s" % info[:method]
    puts "#{description}  #{method}#{info[:path]}"
  end
end
