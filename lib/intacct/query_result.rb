module Intacct
  class QueryResult
    attr_reader   :total_count

    delegate :each, to: :results

    def initialize(client, response, klass)
      @client        = client
      @klass         = klass
      @response      = response
      @results       = response.body[:data] || []
      @count         = response.body[:count]
      @total_count   = response.body[:total_count]
      @num_remaining = response.body[:num_remaining]
      @result_id     = response.body[:result_id]
    end

    def results(options = { all: true })
      if options[:all]
        data = [ @results ]

        until num_remaining.zero?
          data << next_batch
        end

        data.flatten
      else
        @results
      end
    end

    private


    attr_reader :response, :client, :klass, :count, :num_remaining

    def next_batch
      return if total_count.zero?

      next_response  = klass.read_more(client, result_id: @result_id)
      @num_remaining = next_response.body[:num_remaining]

      next_response.body[:data]
    end
  end
end
