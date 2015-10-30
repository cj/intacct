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
        key = @response.at("//result/key").content
        { key: key }
      end

      def list_type
        nil
      end

      module Helper
        def create(options = {})
          response = Intacct::Actions::Create.new(client, self, 'create', options).perform

          if response.success?
            self.key = response.body[:key]
            true
          else
            false
          end

        end
      end
    end
  end
end