require "intacct/version"
require "intacct/customer"

module Intacct
  extend self

  attr_accessor :xml_sender_id, :xml_password,
    :app_user_id, :app_company_id, :app_password

  def setup
    yield self
  end

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
    xml_response = Nokogiri::XML(res.body)

    xml_response
  end
end
