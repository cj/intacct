module Intacct
  class XmlRequest

    include Intacct::Callbacks

    attr_accessor :client, :object, :action, :intacct_action, :model_class, :model

    URL = "https://www.intacct.com/ia/xml/xmlgw.phtml".freeze

    def initialize(client, action, model_class, model)
      @client      = client
      @action      = action
      @model       = model
      @object      = @model.try(:object) || OpenStruct.new
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

      run_hook :"before_#{action}" if action.in? CALLBACK_ACTIONS

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.control {
            xml.senderid client.credentials[:xml_sender_id]
            xml.password client.credentials[:xml_password]
            xml.controlid 'Intacct Ruby Library'
            xml.uniqueid 'false'
            xml.dtdversion '3.0'
          }
          xml.operation(transaction: 'false') {
            xml.authentication {
              xml.login {
                xml.userid client.credentials[:user_id]
                xml.companyid client.credentials[:company_id]
                xml.password client.credentials[:password]
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

      Intacct::Response.new(client, response, model_class, intacct_action, model).handle_response

    end


  end
end