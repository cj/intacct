module Intacct
  module Actions
    class Inspect < Base

      def request(options)
        detail = options[:detail] ? '1' : '0'

        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: '1') {
            xml << "<inspect detail=#{detail}><object>#{klass.api_name.upcase}</object></inspect>"
          }
        end
      end

      def response_body
        raw =  @response.at('//result/data/Type/Fields')
        return unless raw

        Hash.from_xml(raw.to_xml)['Fields']['Field']
      end

      def list_type
        raw =  @response.at('//result/data/Type')
        return unless raw

        Hash.from_xml(raw.to_xml)['Type']['Name'].try(:downcase)
      end

      module Helper
        extend ActiveSupport::Concern

        module ClassMethods
          def inspect_object(client, options = {})
            response = Intacct::Actions::Inspect.new(client, self, 'inspect', options).perform

            response.body
          end
        end
      end
    end
  end
end

module Nokogiri
  module XML
    class Builder
      def inspect(*args); end
    end
  end
end