module Intacct
  module Actions
    class ReadMore < Base

      def request(options)
        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: 'f4') {
            xml.readMore {

              if options[:result_id]
                xml.resultId options[:result_id]
              else
                xml.object klass.api_name
              end

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
          def read_more(client, options)
            response = Intacct::Actions::ReadMore.new(client, self, 'read_more', options).perform

            if response.success?
              response
            end
          end
        end
      end
    end
  end
end