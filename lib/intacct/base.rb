require 'net/http'

module Intacct
  class Base < Struct.new(:object, :current_user)
    attr_accessor :response, :data

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
        true
      else
        false
      end
    end
  end
end
