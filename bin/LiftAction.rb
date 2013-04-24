require "ppcurses"

class LiftAction < PPCurses::GetDataAction 

  def initialize(nameMenu, repMenu, db)
    @nameMenu = nameMenu
    @repMenu = repMenu
    @db = db
    
    @prompt  = PPCurses::GetIntegerAction.new("Weight (pounds) : ") 
    super( [ @prompt ] )

    @sql = "INSERT into LIFTS(name, weight, reps) values ('%s', %s, %s)"                 

  end

  def winHeight()
     return 9
  end
 
  def liftName()
    @nameMenu.getSelectedMenuName()
  end
  
  def repsName()
    @repMenu.getSelectedMenuName()
  end
  
  def repsInteger()
    return Integer(repsName().chars.first).to_s
  end

  def beforeActions()
    self.printLine("Input data for " + repsName() + " " + liftName() )
  end

  def afterActions()
    preparedSql = @sql.sub("%s", liftName() )
    preparedSql = preparedSql.sub("%s", @prompt.data() )
    preparedSql = preparedSql.sub("%s", repsInteger() )

    self.promptToChangeData(preparedSql)
  end

end

