module Consumers
  class AuthorizeConsumer
    # All requests must be made by authorized consumers
    # A consumer may only access it's authorized methods

    def initialize(request)
      @file ||= YAML.load(ERB.new(File.read('config/consumers.yml')).result(self.instance_eval { binding }))
      @application = request.headers['X-Application'].downcase
      @method = request.request_method.downcase
      @path = request.params[:slug] ?
        request.path.sub(request.path.split("/").last, "slug") :
        request.path
    end

    def call
      begin
        @file['consumers'][@application]['forbidden_endpoints'][@method].exclude?(@path)
      rescue
        false
      end
    end
  end
end
