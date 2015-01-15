
# Required by delta_generator, data_generator ... ?

begin
  require 'builder'
rescue LoadError
  puts 'Missing builder gem'
  puts 'Try: gem install builder'
  exit
end

# Required by DeltaNotifier
require 'nokogiri'

# Required by domainManager, ConfigLoader
require 'psych'

# Required by DatabaseProxy, data_generator
begin
  require 'sqlite3'
rescue LoadError => e
  abort 'Missing dependency! Run: gem install sqlite3'
end
# Required by DatabaseProxy, Config
require 'set'

# Required by ConfigLoader
require 'fileutils'

# Required by MuiscAction, LiftAction, ExerciseDistanceAction, CountAction, BookAction
require 'ppcurses'

#---------------------------------------------------------------------------------

require_relative 'action/book_action'
require_relative 'action/music_action'
require_relative 'action/lift_action'
require_relative 'action/count_action'
require_relative 'action/value_action'
require_relative 'action/exercise_distance_action'
require_relative 'db/database_proxy'
require_relative 'db/delta_generator'
require_relative 'db/data_generator'
require_relative 'db/yearly_delta_generator'
require_relative 'subscriber/delta_notifier'

require_relative 'domain/domain_manager'
require_relative 'domain/domain'
require_relative 'domain/reading_domain'
require_relative 'domain/lifting_domain'
require_relative 'domain/music_domain'
require_relative 'domain/misc_domain'
require_relative 'domain/value_domain'
require_relative 'domain/distance_domain'
require_relative 'domain/gas_domain'

module Tallyman
  require_relative 'config/config_loader'
  require_relative 'config/config'
end