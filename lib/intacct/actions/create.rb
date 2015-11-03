module Intacct
  module Actions
    class Create < Base

      def request(options)
        Intacct::XmlRequest.build_xml(client, action) do |xml|
          xml.function(controlid: "1") {
            xml.send("create_#{klass.api_name}") {
              klass.create_xml(xml)
            }
          }
        end
      end

      def response_body
        key = @response.at("//result/key").try(:content)
        return unless key

        { key: key }
      end

      def list_type
        nil
      end

      module Helper
        def create(options = {})
          response = Intacct::Actions::Create.new(client, self, 'create', options).perform

          @errors = response.errors

          if response.success?
            self.persisted = true
            true
          else
            false
          end

        end
      end
    end
  end
end