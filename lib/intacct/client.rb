module Intacct
  class Client
    attr_accessor :xml_sender_id, :xml_password, :user_id, :password, :company_id

    def initialize(options = {})
      @xml_sender_id = options[:xml_sender_id]
      @xml_password = options[:xml_password]
      @user_id = options[:user_id]
      @password = options[:password]
      @company_id = options[:company_id]
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s.in? models
        Intacct::BaseFactory.new(self, method_name)
        # "Intacct::#{method_name.to_s.classify}".constantize.send(:new, args[0], nil, self)
      else
        super method_name
      end
    end

    def respond_to?(method_name)
      if method_name.to_s.in? models
        true
      else
        super method_name
      end
    end

    def models
      %w(bills customers invoices projects vendors)
    end
  end
end
