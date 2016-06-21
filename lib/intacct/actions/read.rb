module Intacct
  module Actions
    class Read < Base

      def request(options)
        raise 'Must specify a value for `key` in the options hash.' unless options[:key]

        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: 'f4') {
            xml.read {
              xml.object klass.api_name.upcase
              xml.keys options[:key]
              xml.fields '*'
              xml.returnFormat 'xml'
              xml.docparid options[:docparid] if options[:docparid].present?
            }
          }
        end
      end

      def response_body
        raw = @response.at("//result/data")
        return unless raw

        Intacct::Utils.instance.downcase_keys(Hash.from_xml(raw.to_xml)['data'][list_type])
      end

      def list_type
        @response.at("//result/data").attributes['listtype'].content
      end


      module Helper
        extend ActiveSupport::Concern

        module ClassMethods
          def read(client, options = {})
            response = Intacct::Actions::Read.new(client, self, 'read', options).perform

            return unless response.body

            if response.success?
              if response.body.is_a?(Array)
                response.body.map { |r| new(client, r) }
              else
                new(client, response.body)
              end
            end
          end
        end

      end
    end
  end
end
