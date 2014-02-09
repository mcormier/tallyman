

require_relative 'action/book_action'
require_relative 'action/music_action'
require_relative 'action/lift_action'
require_relative 'action/count_action'
require_relative 'action/value_action'
require_relative 'db/database_proxy'
require_relative 'db/delta_generator'
require_relative 'db/data_generator'
require_relative 'db/yearly_delta_generator'
require_relative 'subscriber/delta_notifier'

require_relative 'domain/domain_manager'
require_relative 'domain/domain'

module Tallyman
  require_relative 'config/config_loader'
  require_relative 'config/config'
end