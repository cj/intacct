module Intacct
  module Actions
    class ReadByQuery < Base

      def request(options)
        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: 'f4') {
            xml.readByQuery {
              xml.object       klass.api_name.upcase
              xml.query        options.fetch(:query, '')
              xml.pagesize     options.fetch(:page_size, 1000)
              xml.fields       options.fetch(:fields, '*')
              xml.returnFormat options.fetch(:return_format, 'xml')
            }
          }
        end
      end

      def response_body
        raw = @response.at("//result/data")
        return unless raw

        {
          list_type:     raw.attributes['listtype'].content,
          data:          Intacct::Utils.instance.downcase_keys(Hash.from_xml(raw.to_xml)['data'][list_type]),
          count:         raw.attributes['count'].content.to_i,
          total_count:   raw.attributes['totalcount'].content.to_i,
          num_remaining: raw.attributes['numremaining'].content.to_i,
          result_id:     raw.attributes['resultId'].content
        }
      end

      def list_type
        @response.at("//result/data").attributes['listtype'].content
      end

      module Helper
        extend ActiveSupport::Concern

        module ClassMethods
          def read_by_query(client, options = {})
            response = Intacct::Actions::ReadByQuery.new(client, self, 'read_by_query', options).perform

            if response.success?
              Intacct::QueryResult.new(client, response, self)
            else
              raise Intacct::Error, formatted_error_message(response.errors)
            end
          end
        end
      end

    end
  end
end
