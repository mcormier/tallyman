class LiftAction_10

  attr_accessor :form

  def initialize
    @win = PPCurses::Window.new(9,60,0,0)
    @win.keypad(true)
    @win.box('|', '-')
    @form = PPCurses::Form.new

    reps = PPCurses::RadioButtonGroup.new('  Reps', %w(1RM 3RM 5RM) )
    weight = PPCurses::InputElement.new_integer_only(' Weight', 5)

    @form.add(reps)
    @form.add(weight)

  end


end


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

