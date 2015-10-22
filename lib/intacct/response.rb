module Intacct
  class Response

    include Intacct::Callbacks

    attr_accessor :client, :response, :model, :action, :model_class

    def initialize(client, response, model_class, action, model = nil)
      @client      = client
      @response    = response
      @model_class = model_class
      @action      = action
      @model       = model
    end

    def handle_response
      if successful?

        if persistence_action?
          model
        elsif fetch_action?
          wrap_response!

          model
        else
          nil
        end
      else
        raise Intacct::Error.new(response)
      end
    end

    private

    def wrap_response!
      unless model
        @model = model_class.new(client, parse_successful_response)
      end
    end

    def parse_successful_response
      if persistence_action?
        { key: response.at('//result/key').content }
      else
        data = Hash.from_xml(response.at("//result/data/#{model_class.api_name}").to_xml)[model_class.api_name]
        downcase_keys(data)
      end
    end

    def downcase_keys(hash)
      hash.each_with_object({}) { |(k, v), hash| hash[k.downcase] = v }
    end

    def successful?
      (status = response.at('//result//status')) && status.content == 'success'
    end

    def fetch_action?
      response.at('//result/data').present?
    end

    def persistence_action?
      action.in? %w(create update)
    end

    def set_intacct_system_id
      model.object.intacct_system_id = model.object.intacct_object_id
    end

    def delete_intacct_system_id
      model.object.intacct_system_id = nil
    end

    def set_intacct_key(key)
      model.object.intacct_key = key if model.object.respond_to? :intacct_key
    end


    def set_date_time(type)
      if %w(create update delete).include? type
        if model.object.respond_to? :"intacct_#{type}d_at"
          model.object.send("intacct_#{type}d_at=", DateTime.now)
        end
      end
    end
  end
end
