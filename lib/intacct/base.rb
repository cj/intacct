module Intacct
  class Base < Struct.new(:object, :current_user)
    include Hooks

    attr_accessor :response, :data

    def initialize *params
      params[0] = OpenStruct.new(params[0]) if params[0].is_a? Hash
      super(*params)
    end

    private

    def send_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.control {
            xml.senderid Intacct.xml_sender_id
            xml.password Intacct.xml_password
            xml.controlid "INVOICE XML"
            xml.uniqueid "false"
            xml.dtdversion "2.1"
          }
          xml.operation(transaction: "false") {
            xml.authentication {
              xml.login {
                xml.userid Intacct.app_user_id
                xml.companyid Intacct.app_company_id
                xml.password Intacct.app_password
              }
            }
            xml.content {
              yield xml
            }
          }
        }
      end

      xml = builder.doc.root.to_xml

      url = "https://www.intacct.com/ia/xml/xmlgw.phtml"
      uri = URI(url)

      res = Net::HTTP.post_form(uri, 'xmlrequest' => xml)
      @response = Nokogiri::XML(res.body)
    end

    def successful?
      if status = response.at('//result//status') and status.content == "success"
        set_intacct_system_id
        if key = response.at('//result//key')
          set_intacct_key key.content
        end
        true
      else
        false
      end
    end

    def intacct_system_id
      intacct_object_id
    end

    def set_intacct_system_id
      object.intacct_system_id = intacct_object_id
    end

    def set_intacct_key key
      object.intacct_key = key
    end
  end
end
