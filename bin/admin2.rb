#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.2'
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
  action = @actions[@sel_index]
  @app.content_view = @table_view
  action.clear
end

# ----------------------------------------------------------------------
def form_submitted  
  form = @app.content_view
   # Get values from form and input into domain
   # to create insert statement
   # send insert to database.
  domain = @enabled_domains[@sel_index]
  action = @actions[@sel_index]
  
  sql = domain.insert_statement  
  prep_statement = @db.prepare(sql)
  
  data = action.data_array
  prep_statement.bind_params(data)
  prep_statement.execute
  prep_statement.close
  
  
  @app.content_view = @table_view
  action.clear
end





# ----------------------------------------------------------------------
def bind_actions( actions )
  actions.each do |action|
    action.btn_submit.action = method(:form_submitted)
    action.btn_cancel.action = method(:form_cancelled)
  end
end





# ----------------------------------------------------------------------
#  Moving from
#  TableView --> Input form
#
def item_chosen ( notification )

  @sel_index = notification.object.selected_row 
  @app.content_view = @actions[@sel_index].form
 
end




# ----------------------------------------------------------------------

def usage
  warn "usage: #{__FILE__} (option)"
  warn "   -h, --help  : print this help message"
  warn "   -t, --test  : run in test mode "
  exit 1
end



# ----------------------------------------------------------------------
# ----------------  Process arguments 
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


if @test_mode then
  @db = DatabaseProxy.open( script_location + '/../test.db' )
else
  @db = DatabaseProxy.open( @dbName )
end



begin
  @enabled_domains, @actions = @domain_manager.enabled_domains_actions(@config, @db)
  bind_actions( @actions )
  
  domain_labels = []
  @enabled_domains.each do |domain|
    domain_labels.push( domain.main_menu_label)
  end
  
  data_source = PPCurses::SingleColumnDataSource.new( domain_labels )
  @table_view = PPCurses::TableView.new
  @table_view.data_source=data_source

  @app.content_view = @table_view

  notary = PPCurses::NotificationCentre.default_centre
  notary.add_observer(self, method(:item_chosen),  PPTableViewEnterPressedNotification, @table_view )

  
  
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
