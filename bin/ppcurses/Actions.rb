require "curses"

class BaseAction

  def printLine(string)
    @win.addstr(string)
    @win.setpos(@win.cury() + 1, 0)
  end

end

class PromptAction < BaseAction

  def initialize(prompt)
    @prompt = prompt
  end

  def setWindow(win)
    @win = win
  end
 
  def data
    @data
  end 
end

class NulAction < BaseAction
  def initialize( )
  end


  def execute()
  end

end

class GetStringAction < PromptAction

  def execute()
    @win.addstr(@prompt)
    @data = @win.getstr()
  end

end

class GetIntegerAction < PromptAction

  def execute()
   x = @win.curx()
   y = @win.cury()
   begin 
     @win.setpos(y,x)
     @win.clrtoeol()
     @win.addstr(@prompt)
     @data = @win.getstr()
   end while not @data =~ /^\d+$/ 
  end

end



class GetDataAction < BaseAction

  def initialize( actions )
    @actions = actions
    @win = Window.new(0,0,0,0)

    unless actions.nil?
      @actions.each  do |action|
         action.setWindow(@win)
      end
    end

  end

  def beforeActions()
    # Stub for classes that extend
  end

  def afterActions()
    # Stub for classes that extend
  end

  def execute()
    echo
    @win.clear

    self.beforeActions()

    @actions.each  do |action|
       action.execute
    end

    self.afterActions()

    noecho
    @win.clear 
    @win.refresh
  end



  def printSuccessLine(string)
    init_pair(1, COLOR_GREEN, COLOR_BLACK)
    @win.attron(color_pair(1))
    self.printLine(string)
    @win.attroff(color_pair(1))
  end

  def printErrorLine(string)
    init_pair(1, COLOR_RED, COLOR_BLACK)
    @win.attron(color_pair(1))
    self.printLine(string)
    @win.attroff(color_pair(1))
  end

  def promptToChangeData(preparedSQL)
    self.printLine(preparedSQL)

    @win.addstr("Proceed? ")
    echo
    c = @win.getch()
    noecho

    if c == "y" or c == "Y" then
      self.printLine("")
      begin
        @db.execute preparedSQL
        self.printSuccessLine("Execution successful")
      rescue SQLite3::Exception => e
        self.printErrorLine("Exception occurred")
        self.printErrorLine(e.message)
      ensure
        self.printLine("")
        self.printLine("< Press any key to continue > ")
        @win.getch()
      end
      
    end


  end

end


class LiftAction < GetDataAction 

  def initialize(nameMenu, repMenu, db)
    @nameMenu = nameMenu
    @repMenu = repMenu
    @db = db
    
    @prompt  = GetIntegerAction.new("Weight (pounds) : ") 
    super( [ @prompt ] )

    @sql = "INSERT into LIFTS(name, weight, reps) values ('%s', %s, %s)"                 

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



class ShowMenuAction < BaseAction

  def initialize( menu )
    @menu = menu

  end

  def execute()
    @menu.show()
    @menu.getMenuSelection() 
  end

end


class InsertSQLDataAction < GetDataAction

  def initialize( actions , sql, db )
    super(actions)
    @sql = sql
    @db = db
  end

  def afterActions()

    preparedSql = @sql
    @actions.each do |action|
      preparedSql = preparedSql.sub("%s", action.data)
    end

    self.promptToChangeData(preparedSql)

    @win.clear 
    @win.refresh

  end

end
