#!/usr/bin/env ruby

#noinspection RubyResolve
begin
  require 'sqlite3'
rescue LoadError
  puts 'Missing sqlite3 gem'
  puts 'Try: gem install sqlite3'
  exit
end

gem 'ppcurses', '=0.1.0'
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

      # Create the table if it is missing.  Must be the first time the
      # domain was used.
      unless db.table_exists?(domain.table_name)
        prep_statement = db.prepare(domain.create_table_statement)
        prep_statement.execute
        prep_statement.close
      end

      main_menu_labels.push( domain.main_menu_label )
      actions.push( domain.create_action(db, @config) )

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


#db = DatabaseProxy.open( @dbName )

#begin
#
#  screen = PPCurses::Screen.new
#  screen.run { get_data(db) }
#rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
#ensure
#  db.close if db
#end

#generator = DeltaGenerator.new(db.modified_table_set)
#generator.generate(script_location + '/../data/delta.xml')

#exit determine_exit_code(db)

@app = PPCurses::Application.new
@form = PPCurses::Form.new

@app.content_view = @form

#@app.launch

puts "Status of domains:"
@domain_manager.print_domains(@config)
