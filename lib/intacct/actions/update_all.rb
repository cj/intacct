module Intacct
  module Actions
    class UpdateAll < Base

      # def request(options)
      #   Intacct::XmlRequest.build_xml(client, action) do |xml|
      #     xml.function(controlid: '1') {
      #       xml.update {
      #
      #       }
      #     }
      #   end
      #
      # end



      module Helper
        include ActiveSupport::Concern

        module ClassMethods
          def update_all(ids, attributes)
            params = {
                ids:        ids,
                attributes: attributes
            }

            response = Intacct::Actions::UpdateAll.new(client, self, 'update_all', params).perform

            response.success?
          end
        end
      end

    end
  end
end