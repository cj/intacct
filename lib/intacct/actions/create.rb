module Intacct
  module Actions
    class Create < Base

      def request(options)
        if klass.class == Intacct::Models::Expense
          Intacct::XmlRequest.build_xml(client, action) do |xml|
            xml.function(controlid: "1") {
              xml.send("create_expensereport") {
                klass.create_xml(xml)
              }
            }
          end
        else
          Intacct::XmlRequest.build_xml(client, action) do |xml|
            xml.function(controlid: "1") {
              xml.create {
                xml.send(klass.api_name) {
                  klass.create_xml(xml)
                }
              }
            }
          end
        end
      end

      def response_body
        raw = @response.at("//result/data/#{klass.api_name}")
        return unless raw

        Utils.instance.downcase_keys(Hash.from_xml(raw.to_xml)[klass.api_name])
      end

      def list_type
        nil
      end

      module Helper
        def create(options = {})
          response = Intacct::Actions::Create.new(client, self, 'create', options).perform

          @errors = response.errors

          if response.success?
            self.attributes.recordno  = response.body['recordno'] unless response.body.nil?
            true
          else
            false
          end

        end
      end
    end
  end
end
