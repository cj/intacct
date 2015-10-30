module Intacct
  class Response
    include Intacct::Callbacks

    attr_accessor :client, :body, :errors

    def initialize(client, options)
      @client  = client
      @success = options[:success]
      @body    = options[:body]
      @errors  = options[:errors] || []
    end

    def success?
      @success
    end

    def error?
      @errors.any?
    end
  end
end
