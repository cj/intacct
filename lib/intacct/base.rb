module Intacct
  class Base < Struct.new(:client, :object)

    attr_accessor  :client, :sent_xml, :intacct_action, :api_name

    def initialize(client, *params)
      @client = client
      params[0] = OpenStruct.new(params[0]) if params[0].is_a? Hash
      super(client, *params)
    end

    def self.build(client, options = {})
      self.new(client, options)
    end

    def self.get(client, key, options = {})
      # return false unless object.intacct_system_id.present?

      response = send_xml(client, 'get') do |xml|
        xml.function(controlid: "f4") {
          xml.get(object: api_name.downcase, key: key) {

            if options[:fields]
              xml.fields {
                fields.each do |field|
                  xml.field field.to_s
                end
              }
            end
          }
        }
      end

      if status = response.at('//result//status') and status.content == "success"
        attrs = Hash.from_xml(response.at('//result/data/project').to_xml)['project']
        self.new(client, attrs)
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name.in? self.object.to_h.keys
        self.object.send(method_name, *args)
      else
        super method_name
      end
    end

    def respond_to?(method_name)
      if method_name.in? self.object.to_h.keys
        true
      else
        super method_name
      end
    end

    private

    def self.send_xml(client, action, &block)
      builder = Intacct::XmlRequestBuilder.new(client, action, OpenStruct.new)
      builder.build_xml(&block)
    end

    def send_xml(action = nil, &block)
      self.class.send_xml(client, action, &block)
    end

    def api_name
      self.class.api_name
    end


    %w(invoice bill vendor customer project).each do |type|
      define_method "intacct_#{type}_prefix" do
        Intacct.send("#{type}_prefix")
      end
    end

    def successful?
      if status = response.at('//result//status') and status.content == "success"
        true
      else
        false
      end
    end

    def intacct_system_id
      intacct_object_id
    end

    def intacct_object_id
      object.id ? "#{intacct_customer_prefix}#{object.id}" : random_object_id
    end

    def random_object_id
      SecureRandom.random_number.to_s
    end

    def self.api_name(name = nil)
      @api_name ||= (name || self.name.to_s.demodulize.upcase)
    end
  end
end
