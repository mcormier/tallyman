require 'ppcurses'

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
    @name_menu.getSelectedMenuName()
  end
  
  def reps_name
    @rep_menu.getSelectedMenuName()
  end
  
  def reps_integer
    Integer(reps_name().chars.first).to_s
  end

  def before_actions
    self.printLine('Input data for ' + reps_name() + ' ' + lift_name() )
  end

  def after_actions
    prepared_sql = @sql.sub('%s', lift_name() )
    prepared_sql = prepared_sql.sub('%s', @prompt.data() )
    prepared_sql = prepared_sql.sub('%s', reps_integer() )

    self.prompt_to_change_data(prepared_sql, [lift_name(), @prompt.data(), reps_integer() ])
  end

end

