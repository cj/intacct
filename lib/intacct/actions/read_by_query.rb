module Intacct
  module Actions
    class ReadByQuery < Base

      def request(options)
        raise 'Must specify a value for `query` in the options hash.' unless options[:query]

        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: 'f4') {
            xml.readByQuery {
              xml.object klass.api_name.upcase
              xml.query options[:query]
              xml.fields '*'
              xml.returnFormat 'xml'
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
          def read_by_query(client, options = {})
            response = Intacct::Actions::ReadByQuery.new(client, self, 'read_by_query', options).perform

            return unless response.body

            if response.success?
              if response.body.is_a?(Array)
                response.body.map { |r| new(client, r) }
              else
                new(client, response.body)
              end
            elsif response.error?
              response.errors
            end
          end
        end
      end

    end
  end
end
