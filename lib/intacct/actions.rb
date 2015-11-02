require 'intacct/actions/base'
require 'intacct/actions/get'
require 'intacct/actions/read'
require 'intacct/actions/read_by_query'
require 'intacct/actions/create'
require 'intacct/actions/update'
require 'intacct/actions/update_all'
require 'intacct/actions/bulk_create'

module Intacct
  module Actions
    extend ActiveSupport::Concern

    include Intacct::Actions::Get::Helper
    include Intacct::Actions::Read::Helper
    include Intacct::Actions::ReadByQuery::Helper
    include Intacct::Actions::Create::Helper
    include Intacct::Actions::Update::Helper
    include Intacct::Actions::UpdateAll::Helper
    include Intacct::Actions::BulkCreate::Helper

  end
end

