#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.2'
require 'ppcurses'

require 'logger'
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

@error_msg = nil

def form_submitted  
  form = @app.content_view
   # Get values from form and input into domain
   # to create insert statement
   # send insert to database.
  domain = @enabled_domains[@sel_index]
  @logger.debug("Adding data for #{domain.table_name}" )
  action = @actions[@sel_index]
  
  sql = domain.insert_statement
  @logger.debug("Building insert statement:  #{sql}")  
  begin
    prep_statement = @db.prepare(sql)  
    data = action.data_array
    @logger.debug("Binding parameter data: #{data}")
    prep_statement.bind_params(data)
    prep_statement.execute
    prep_statement.close
  rescue SQLite3::Exception => e
    error_msg = e.message
    raise e
  end
  
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



@logger = Logger.new(@config_loader.config_dir + 'tallyman.log', 'monthly')


if @test_mode then
  @db = DatabaseProxy.open( script_location + '/../test.db' )
  @logger.debug("Opened database #{script_location}/../test.db")
else
  @db = DatabaseProxy.open( @dbName )
  @logger.debug("Opened database #{ @dbName}")
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

  notary = PPCurses::NotificationCentre.default_centre
  notary.add_observer(self, method(:item_chosen),  PPTableViewEnterPressedNotification, @table_view )

  @app = PPCurses::Application.new
  @app.content_view = @table_view 
  @app.launch
  

rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  if @error_msg != nil then
    puts @error_msg
  end
  @db.close if @db
  @logger.debug("Database closed successfully ")
  @logger.debug("    -----------------     ")
end



# TODO -- add verbose option for greater error reporting
# TODO -- add intentional error on bind_param, missing value
# TODO -- make sure error is reported correctly, etc.
