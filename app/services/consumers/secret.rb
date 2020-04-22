module Consumers
  class Secret
    # Responsible for getting customer secret for current consumer

    def initialize(application)
      @file ||= YAML.load(ERB.new(File.read('config/consumers.yml')).result(self.instance_eval { binding }))
      @application = application
    end

    def call
      begin
        @file['consumers'][@application]['secret']
      rescue
        nil
      end
    end
  end
end
