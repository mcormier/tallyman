#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.1'
require 'ppcurses'

require_relative '../lib/rb/tallyman'

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

@domain_root = script_location + '/../data/modules/'
@domain_manager = DomainManager.new(@domain_root)

@config_loader = Tallyman::ConfigLoader.new
@config = @config_loader.load


# ----------------------------------------------------------------------
def get_menu_actions(db)

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
      actions.push( domain.create_action(db, @config) )

    end

  end

  actions

end

# ----------------------------------------------------------------------
#  Moving from
#  TableView --> Input form
#
def item_chosen ( notification )

  sel = notification.object.selected_row 
  @app.content_view = @actions[sel].form
  
end



@app = PPCurses::Application.new

# Domains are a set.  Create a sorted array so values
# appear in alphabetical order.
domains = @config.enabled_domains.to_a().sort
data_source = PPCurses::SingleColumnDataSource.new( domains )
@table_view = PPCurses::TableView.new
@table_view.data_source=data_source

@app.content_view = @table_view

notary = PPCurses::NotificationCentre.default_centre
notary.add_observer(self, method(:item_chosen),  PPTableViewEnterPressedNotification, @table_view )

db = DatabaseProxy.open( @dbName )

begin
  @actions = get_menu_actions(db)
  @app.launch
rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  db.close if db
end

# Displays all domains, enabled or disabled.
#puts "Status of domains:"
#@domain_manager.print_domains(@config)
