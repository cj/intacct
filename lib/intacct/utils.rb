require 'singleton'

module Intacct
  class Utils
    include Singleton

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
  end
end
