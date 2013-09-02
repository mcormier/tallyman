require "ppcurses"

class LiftAction < PPCurses::InsertSQLDataAction

  def initialize(nameMenu, repMenu, db)
    @nameMenu = nameMenu
    @repMenu = repMenu
    @db = db
    
    @prompt  = PPCurses::GetIntegerAction.new("Weight (pounds) : ")
    super( [ @prompt ], 'INSERT into LIFTS(name, weight, reps) values (?, ?, ?)', @db )

  end

  def winHeight()
    9
  end
 
  def liftName()
    @nameMenu.getSelectedMenuName()
  end
  
  def repsName()
    @repMenu.getSelectedMenuName()
  end
  
  def repsInteger()
    Integer(repsName().chars.first).to_s
  end

  def beforeActions()
    self.printLine('Input data for ' + repsName() + ' ' + liftName() )
  end

  def afterActions()
    preparedSql = @sql.sub('%s', liftName() )
    preparedSql = preparedSql.sub('%s', @prompt.data() )
    preparedSql = preparedSql.sub('%s', repsInteger() )

    self.promptToChangeData(preparedSql, [liftName(), @prompt.data(), repsInteger ])
  end

end

