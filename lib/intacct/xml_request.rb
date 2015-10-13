module Intacct
  class XmlRequest

    include Hooks
    include Hooks::InstanceHooks

    define_hook :before_create


    attr_accessor :client, :object, :action, :intacct_action, :model_class

    URL = "https://www.intacct.com/ia/xml/xmlgw.phtml".freeze

    def initialize(client, action, object, model_class)
      @client      = client
      @action      = action
      @object      = object
      @model_class = model_class
    end

    def build_xml(&block)
      send_xml(action) do |xml|
        block.call(xml)
      end
    end


    private

    def send_xml(action = nil)
      @intacct_action = action.to_s
      run_hook :"before_#{action}" if action == "create"

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.control {
            xml.senderid client.xml_sender_id
            xml.password client.xml_password
            xml.controlid "INVOICE XML"
            xml.uniqueid "false"
            xml.dtdversion "2.1"
          }
          xml.operation(transaction: "false") {
            xml.authentication {
              xml.login {
                xml.userid client.user_id
                xml.companyid client.company_id
                xml.password client.password
              }
            }
            xml.content {
              yield xml
            }
          }
        }
      end

      xml = builder.doc.root.to_xml
      @sent_xml = xml

      uri = URI(URL)

      res = Net::HTTP.post_form(uri, 'xmlrequest' => xml)
      response = Nokogiri::XML(res.body)

      Intacct::Response.new(client, response, model_class, intacct_action).handle_response

    end


  end
end