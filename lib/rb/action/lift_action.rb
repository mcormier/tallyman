class LiftAction_10

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize( enabled_lifts )
    @form = PPCurses::Form.new
    
    @lift = PPCurses::ComboBox.new('   Lift', enabled_lifts)
    @reps = PPCurses::RadioButtonGroup.new('  Reps', %w(1RM 3RM 5RM) )
    @weight = PPCurses::InputElement.new_integer_only(' Weight', 5)
    @day = PPCurses::DatePicker.new( '    Day')

    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2

    @form.add(@lift)
    @form.add(@reps)
    @form.add(@weight)
    @form.add(@day)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end
  
  def clear
    @form.clear    
  end

  def data_array
    data = []
  
    data.push(@lift.object_value_of_selected_item)
    
    data.push(@weight.value)
    
    case @reps.current_option
      when 0
        data.push(1)
      when 1 
        data.push(3)
      when 2
        data.push(5)
    end
        
    
    date = @day.date
    data.push(date.strftime('%Y-%m-%d') )
    
    data
  end


end

# TODO -- Remove SQL action from PPCurses at the same time ...
#  UI library should not know about SQL.
#
# @deprecated.  Remove in Tallyman 1.4.
class LiftAction < PPCurses::InsertSQLDataAction

  def initialize(name_menu, rep_menu, db)
    @name_menu = name_menu
    @rep_menu = rep_menu
    @db = db

    @prompt  = PPCurses::GetIntegerAction.new('Weight (pounds) : ')
    super( [ @prompt ], 'INSERT into LIFTS(name, weight, reps) values (?, ?, ?)', @db )

  end

  def winHeight
    9
  end
 
  def lift_name
    @name_menu.selected_menu_name
  end
  
  def reps_name
    @rep_menu.selected_menu_name
  end
  
  def reps_integer
    Integer(reps_name.chars.first).to_s
  end

  def before_actions
    self.print_line('Input data for ' + reps_name + ' ' + lift_name )
  end

  def after_actions
    prepared_sql = @sql.sub('%s', lift_name )
    prepared_sql = prepared_sql.sub('%s', @prompt.data )
    prepared_sql = prepared_sql.sub('%s', reps_integer )

    new_data_added = self.prompt_to_change_data(prepared_sql, [lift_name, @prompt.data, reps_integer ])

    # @db could be a proxy or just a regular old Database
    if new_data_added and @db.respond_to?(:data_added_to) then
      @db.data_added_to('lifts')
    end

  end

end

