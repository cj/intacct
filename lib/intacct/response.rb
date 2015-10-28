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
        response = parse_successful_response
        return unless response

        if response.is_a?(Array)
          response.map { |r| model_class.new(client, r) }
        else
          model_class.new(client, response)
        end
      end
    end

    def parse_successful_response
      if persistence_action?
        { key: response.at('//result/key').content }
      else
        data = Hash.from_xml(response.at('//result/data').to_xml)['data']
        list_type = data['listtype']
        results = data[list_type]

        return unless data

        transform_response!(results)
      end
    end

    def transform_response!(data)
      if data.is_a?(Array)
        data.map! { |d|
          transform_response!(d)
        }
      else
        data       = downcase_keys(data)
        data[:key] = data['recordno']
        data
      end
    end

    def downcase_keys(value)
      case value
        when Array
          value.map { |v| downcase_keys(v) }
        when Hash
          Hash[value.map { |k, v| [k.downcase, downcase_keys(v)] }]
        else
          value
      end
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

    def object_identifier
      "#{model_class.to_s.downcase}id"
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
