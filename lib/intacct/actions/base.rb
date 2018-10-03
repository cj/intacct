module Intacct
  module Actions
    class Base
      attr_accessor :client, :action, :klass

      def initialize(client, klass, action, options = {})
        @client  = client
        @klass   = klass
        @action  = action
        @options = options
      end

      def perform
        @response = request(@options)
        build_response
      end

      def build_response
        Intacct::Response.new(client, success: success?, body: response_body, errors: response_errors)
      end

      def request(options)
        raise NotImplementedError, 'Implement this method in the subclass'
      end

      def success?
        # This can be overridden in the subclass if necessary

        (status = @response.at('//result//status')) && status.content == 'success'
      end

      def response_body
        raise NotImplementedError, 'Implement this method in the subclass'
      end

      def response_errors
        raw = @response.at('//result/errormessage') || @response.at('//errormessage')
        return unless raw

        [Hash.from_xml(raw.to_xml)['errormessage']['error']].flatten
      end

      def list_type
        raise NotImplementedError, 'Implement this method in the subclass'
      end

    end
  end
end