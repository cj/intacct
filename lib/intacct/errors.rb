require 'forwardable'

module Intacct
  class Error < StandardError
    extend Forwardable

    def_instance_delegators :@response, :message, :code
    attr_reader :response

    def initialize(response)
      @response = response
    end

  end
end
