module Intacct
  module Actions
    class UpdateAll < Base

      def request(options)
        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: '1') {
            xml.update {
              #TODO: Finish this
            }
          }
        end
      end

      def response_body

      end

      def list_type

      end

      def response_errors

      end

      module Helper
        include ActiveSupport::Concern

        module ClassMethods
          def update_all(client, ids, attributes)
            params = {
                ids:        ids,
                attributes: attributes
            }
            response = Intacct::Actions::UpdateAll.new(client, self, 'update_all', params).perform

            @errors = response.errors

            response.success?
          end
        end
      end

    end
  end
end
