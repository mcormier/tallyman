#!/usr/bin/env ruby

#noinspection RubyResolve
require 'sqlite3'
require 'ppcurses'
require 'rubygems'

require_relative '../lib/rb/tallyman'

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

@domain_root = script_location + '/../data/modules/'
@domain_manager = DomainManager.new(@domain_root)

@config_loader = Tallyman::ConfigLoader.new
@config = @config_loader.load



def get_data(db)

  main_menu_labels = []
  actions = []

  @domain_manager.domains.each do |domain|

    if @config.domain_enabled?(domain.module_name)

      # TODO - reverse logic and create the table if it is missing.
      if db.table_exists?(domain.table_name)
        main_menu_labels.push( domain.main_menu_label )
        actions.push( domain.create_action(db) )
      end

    end

  end

  main_menu = PPCurses::Menu.new( main_menu_labels, actions )

  main_menu.show
  main_menu.menu_selection

  main_menu.close
end

# adminInterface return values:
# ----------------------------
# 0 - interface ran but nothing inserted
# 1 - an error occurred running the interface
# 2 - 1 or more insert statements to the database occurred
#
def determine_exit_code(db)
  if db.insert_count > 0 then 2 else 0 end
end


db = DatabaseProxy.open( @dbName )

begin

  screen = PPCurses::Screen.new
  screen.run { get_data(db) }
rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  db.close if db
end

generator = DeltaGenerator.new(db.modified_table_set)
generator.generate(script_location + '/../data/delta.xml')

exit determine_exit_code(db)