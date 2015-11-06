module Intacct
  class BaseFactory
    attr_reader :client, :klass

    def initialize(client, klass)
      @client = client
      @klass = klass
    end

    def target_class
      "Intacct::Models::#{klass.to_s.classify}".constantize
    end

    def self.delegate_to_target_class(*method_names)
      method_names.each do |method_name|
        define_method method_name do |*args|
          target_class.send(method_name, @client, *args)
        end
      end
    end

    # The primary purpose of this class is to delegate methods to the corresponding
    # non-factory class and automatically prepend the client argument to the argument
    # list.
    delegate_to_target_class :get, :read, :read_by_name, :read_by_query, :bulk_create, :update_all, :inspect_object

    # This method needs special handling as it has a default argument value
    def build(attrs={})
      target_class.build(@client, attrs)
    end
  end
end
