module Intacct
  module Callbacks
    extend ::ActiveSupport::Concern

    included do
      include Hooks
      include Hooks::InstanceHooks

      CALLBACK_ACTIONS = %w(get create update delete) unless defined?(CALLBACK_ACTIONS)

      CALLBACK_ACTIONS.each do |action|
        self.send(:define_hook, "before_#{action}")
        self.send(:define_hook, "after_#{action}")
      end

      self.define_hook :after_send_xml
      self.define_hook :on_error
    end
  end
end
