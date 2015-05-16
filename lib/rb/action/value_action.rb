class ValueAction_10
  
  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel
  
  def initialize(db)
  
   begin
      statement = db.prepare('SELECT DISTINCT event FROM valueTable ORDER BY event ASC')
      rs = statement.execute

      event_types = []
      rs.each do |row|
        event_types.push(row[0])
      end
      
    ensure
      statement.close
    end
  
  
    @form = PPCurses::Form.new
    
    @event = PPCurses::ComboBox.new('   Event', event_types)
    @value = PPCurses::InputElement.new_integer_only(' Value', 5)
    
    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
    
    @form.add(@event)
    @form.add(@value)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end

  def clear
    @form.clear    
  end
  
  
  def data_array
    data = []
    
    data.push(@event.object_value_of_selected_item)
    data.push(@value.value)
    
    data
  end
  
  
  
end


# TODO -- remove in Tallyman 1.4
class ValueAction  < PPCurses::InsertSQLDataAction
  def initialize(db)
    @db = db;

    begin
      statement = @db.prepare('SELECT DISTINCT event FROM valueTable ORDER BY event ASC')
      rs = statement.execute

      event_types = []
      rs.each do |row|
        event_types.push(row[0])
      end

      @value_menu = PPCurses::Menu.new( event_types, nil )
      @value_menu.set_global_action(self)
    ensure
      statement.close
    end

    @sql = 'INSERT into valueTable(event, value) values (?,?)'
    @prompt  = PPCurses::GetIntegerAction.new('Value : ')

    super( [ @prompt ], @sql, db )

  end


  def menu
    @value_menu
  end

  def show
    @value_menu.show
  end

  def value_name
    @value_menu.selected_menu_name
  end

  def before_actions
    self.print_line('Input data for ' +  @value_menu.selected_menu_name )
  end

  def after_actions
    prepared_sql = @sql.sub('%s', value_name )
    prepared_sql = prepared_sql.sub('%s', @prompt.data )


    new_data_added = self.prompt_to_change_data(prepared_sql, [value_name, @prompt.data ])

    if new_data_added then
      @db.data_added_to('valueTable')
    end

  end

end