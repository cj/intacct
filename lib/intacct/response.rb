module Intacct
  class Response

    include Hooks
    include Hooks::InstanceHooks

    define_hook :after_create, :after_update, :after_delete,
                :after_get, :after_send_xml, :on_error

    after_create :set_intacct_system_id
    after_delete :delete_intacct_system_id
    after_delete :delete_intacct_key
    after_send_xml :set_date_time

    attr_accessor :client, :response, :model, :action, :model_class

    def initialize(client, response, model_class, action)
      @client      = client
      @response    = response
      @model_class = model_class
      @action      = action
    end

    def handle_response
      if successful?
        if action
          run_hook :after_send_xml, action
          run_hook :"after_#{action}"
        end

        wrap_response!
      else
        run_hook :on_error

        StandardError.new('Intacct Error')
      end
    end

    private

    def wrap_response!
      @model = model_class.new(client, parse_successful_response)
    end

    def parse_successful_response
      Hash.from_xml(response.at("//result/data/#{model_class.api_name}").to_xml)[model_class.api_name]
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
