require 'intacct/actions/base'
require 'intacct/actions/get'
require 'intacct/actions/read'
require 'intacct/actions/read_by_query'
require 'intacct/actions/create'
require 'intacct/actions/update'

module Intacct
  module Actions
    extend ActiveSupport::Concern

    included do
      include Intacct::Actions::Get::Helper
      include Intacct::Actions::Read::Helper
      include Intacct::Actions::ReadByQuery::Helper

      include Intacct::Actions::Create::Helper
      include Intacct::Actions::Update::Helper
    end
  end
end

