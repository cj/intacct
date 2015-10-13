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
      send_xml(client, 'get') do |xml|
        xml.function(controlid: "f4") {
          xml.get(object: api_name, key: key) {

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
    end

    def create
      send_xml('create') do |xml|
        xml.function(controlid: '1') {
          xml.send("create_#{api_name}") {

            xml.send("#{api_name}id", key)

            object.to_h.each { |key, value|

              object_attributes_to_xml(xml, key, value)

            }

          }
        }
      end
    end

    def key
      @key ||= (object.key || random_object_id)
    end

    def object_attributes_to_xml(xml, key, value)
      if value.is_a?(Hash)
        value.each { |k, v|
          object_attributes_to_xml(xml, k, v)
        }
      else
        xml.send(key, value)
      end

    end

    def method_missing(method_name, *args, &block)
      stripped_method_name = method_name.to_s.gsub(/=$/, '')

      if stripped_method_name.to_sym.in? self.object.to_h.keys
        self.object.send(method_name, *args)
      else
        super method_name, *args
      end
    end

    def respond_to_missing?(method_name, *args)
      if method_name.in? self.object.to_h.keys
        true
      else
        super method_name, *args
      end
    end

    private


    def send_xml(action = nil, &block)
      self.class.send_xml(client, action, self, &block)
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


    #
    # Class Methods
    #

    def self.api_name(name = nil)
      @api_name ||= (name || self.name.to_s.demodulize.downcase)
    end

    def self.send_xml(client, action, model = nil, &block)
      builder = Intacct::XmlRequest.new(client, action, self, model)
      builder.build_xml(&block)
    end
  end
end
