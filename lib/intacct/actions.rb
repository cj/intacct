require 'intacct/actions/base'
require 'intacct/actions/get'
require 'intacct/actions/read'
require 'intacct/actions/read_by_query'
require 'intacct/actions/read_more'
require 'intacct/actions/create'
require 'intacct/actions/update'
require 'intacct/actions/update_all'
require 'intacct/actions/bulk_create'
require 'intacct/actions/inspect'

module Intacct
  module Actions
    extend ActiveSupport::Concern

    include Intacct::Actions::Get::Helper
    include Intacct::Actions::Read::Helper
    include Intacct::Actions::ReadByQuery::Helper
    include Intacct::Actions::ReadMore::Helper
    include Intacct::Actions::Create::Helper
    include Intacct::Actions::Update::Helper
    include Intacct::Actions::UpdateAll::Helper
    include Intacct::Actions::BulkCreate::Helper
    include Intacct::Actions::Inspect::Helper

      # def actions(*args)
      #   args.each do |action|
      #     action(action)
      #   end
      # end
      #
      # def action(name)
      #   case name
      #     when :get
      #       self.send(:include, Intacct::Actions::Get::Helper)
      #     when :read
      #       self.send(:include, Intacct::Actions::Read::Helper)
      #     when :read_by_query
      #       self.send(:include, Intacct::Actions::ReadByQuery::Helper)
      #     when :read_more
      #       self.send(:include, Intacct::Actions::ReadMore::Helper)
      #     when :create
      #       self.send(:include, Intacct::Actions::Create::Helper)
      #     when :update
      #       self.send(:include, Intacct::Actions::Update::Helper)
      #     when :bulk_create
      #       self.send(:include, Intacct::Actions::BulkCreate::Helper)
      #     when :inspect_object
      #       self.send(:include, Intacct::Actions::Inspect::Helper)
      #     else
      #       raise "Unknown action: #{name}"
      #
      #
      #   end
      # end
    # end
  end
end
