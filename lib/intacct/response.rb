module Intacct
  class Response

    include Intacct::Callbacks

    after_create :set_intacct_system_id
    after_delete :delete_intacct_system_id
    after_delete :delete_intacct_key
    after_send_xml :set_date_time

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
        wrap_response!

        if action
          run_hook :after_send_xml, action
          run_hook :"after_#{action}"
        end

        model
      else
        run_hook :on_error
        raise Intacct::Error(response)
      end
    end

    private

    def wrap_response!
      unless model
        @model = model_class.new(client, parse_successful_response)
      end
    end

    def parse_successful_response
      if action.in? %w(create update)
        { key: response.at('//result/key').content }
      else
        Hash.from_xml(response.at("//result/data/#{model_class.api_name}").to_xml)[model_class.api_name]
      end
    end

    def successful?
      (status = response.at('//result//status')) && status.content == 'success'
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
