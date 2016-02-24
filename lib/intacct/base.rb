module Intacct
  class Base < Struct.new(:client, :attributes)
    include Intacct::Actions

    attr_accessor  :client, :sent_xml, :intacct_action, :api_name, :errors

    delegate :formatted_error_message, to: :class

    def self.build(client, options = {})
      self.new(client, options)
    end

    def initialize(client, *args)
      @client = client
      args[0] = OpenStruct.new(args[0]) if args[0].is_a? Hash
      super(client, *args)
    end

    def create_xml(xml)
      raise NotImplementedError, 'This model does not support create.'
    end

    def update_xml(xml)
      raise NotImplementedError, 'This model does not support update.'
    end

    def id_attribute
      self.class.id_attribute
    end

    def method_missing(method_name, *args, &block)
      stripped_method_name = method_name.to_s.gsub(/=$/, '')

      if stripped_method_name.to_sym.in? self.attributes.to_h.keys
        self.attributes.send(method_name, *args)
      else
        super method_name, *args
      end
    end

    def respond_to_missing?(method_name, *args)
      if method_name.in? self.attributes.to_h.keys
        true
      else
        super method_name, *args
      end
    end

    def api_name
      self.class.api_name
    end

    def persisted?
      !!attributes['recordno']
    end

    private

    def read_only_fields
      self.class.read_only_fields
    end

    def attributes_to_xml(xml, key, value)
      if value.is_a?(Hash)
        xml.send(key) {
          value.each do |k,v|
            attributes_to_xml(xml, k, v)
          end
        }
      elsif value.is_a?(Array)
        value.each do |val|
          val.each do |k,v|
            attributes_to_xml(xml, k, v)
          end
        end
      else
        xml.send(key, value)
      end
    end

    def sliced_attributes
      attributes.to_h.except(*read_only_fields, :whenmodified)
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
      intacct_attributes_id
    end

    def intacct_attributes_id
      attributes.id ? "#{intacct_customer_prefix}#{attributes.id}" : random_attributes_id
    end

    def random_attributes_id
      SecureRandom.random_number.to_s
    end


    #
    # Class Methods
    #

    def self.api_name(name = nil)
      @api_name ||= (name || self.name.to_s.demodulize.downcase)
    end

    def self.id_attribute(attr = nil)
      @id_attribute = (attr || "#{self.name.to_s_demodulize.downcase}id") if attr
      @id_attribute
    end

    def self.read_only_fields(*args)
      if args.empty?
        @read_only_fields ||= Set.new
      else
        args.each do |arg|
          read_only_field arg
        end
      end
    end

    def self.read_only_field(name)
      name_sym = name.to_sym
      read_only_fields << name_sym
    end

    def self.formatted_error_message(errors)
      [errors].flatten.map { |error| error['description'].presence || error['description2'] || 'Undefined error' }.join(' ')
    end
  end
end
