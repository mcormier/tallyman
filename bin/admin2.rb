#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.1'
require 'ppcurses'

require 'getoptlong'

require_relative '../lib/rb/tallyman'

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

@domain_root = script_location + '/../data/modules/'
@domain_manager = DomainManager.new(@domain_root)

@config_loader = Tallyman::ConfigLoader.new
@config = @config_loader.load

@test_mode = false

# ----------------------------------------------------------------------
def form_cancelled
  @app.content_view = @table_view
end

# ----------------------------------------------------------------------
def form_submitted

   #TODO -- insert into the database.
  
  form = @app.content_view
   # Get values from form and input into domain
   # to create insert statement
   # send insert to database.
  
  # prep_statement = @db.prepare(@sql)
  # prep_statement.bind_params(data_array)
  # prep_statement.execute
  # prep_statement.close
  
  
  @app.content_view = @table_view
end

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
      
      notary = PPCurses::NotificationCentre.default_centre
      action = domain.create_action(db, @config)
      action.btn_submit.action = method(:form_submitted)
      action.btn_cancel.action = method(:form_cancelled)
      
      actions.push( action )
 

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

# ----------------------------------------------------------------------

def usage
  warn "usage: #{__FILE__} (option)"
  warn "   -h, --help  : print this help message"
  warn "   -t, --test  : run in test mode "
  exit 1
end

# ----------------------------------------------------------------------
 
begin
  GetoptLong.new(['-h', '--help', GetoptLong::NO_ARGUMENT],
                 ['-t', '--test', GetoptLong::NO_ARGUMENT]).
  each do |opt, arg|
    case opt
      when '-t'; @test_mode = true
      when '-h'; usage
    end
  end
    
rescue
  usage
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


if @test_mode then
  @db = DatabaseProxy.open( script_location + '/../test.db' )
else
  @db = DatabaseProxy.open( @dbName )
end



begin
  @actions = get_menu_actions(@db)
  @app.launch
rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  @db.close if @db
end

# Displays all domains, enabled or disabled.
#puts "Status of domains:"
#@domain_manager.print_domains(@config)
