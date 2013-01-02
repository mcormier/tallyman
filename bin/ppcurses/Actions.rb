require "curses"

class BaseAction

end

class PromptAction < BaseAction

  def initialize(prompt)
    @prompt = prompt
  end

  def setWindow(win)
    @win = win
  end

  def setParentAction(action)
    @parent = action
  end

  def printPrompt()
    @win.setpos(@win.cury(), @parent.winPadding())
    @win.addstr(@prompt)
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

class GetBooleanAction < PromptAction

  def initialize(prompt) 
    super(prompt)
    @state = false;
  end

  def printPrompt()
    super()
    @win.addstr("No [")
    if (@state == false) then @win.addstr("X") else @win.addstr(" ") end
    @win.addstr("] Yes [")
    if (@state == true) then @win.addstr("X") else @win.addstr(" ") end
    @win.addstr("]")
  end
 

  def execute()
    printPrompt()
    # Enables reading arrow keys in getch 
    @win.keypad(true)
    while(1)
      noecho
      c = @win.getch

      if c == KEY_LEFT then @state = false end
      if c == KEY_RIGHT then @state = true end
      if c == 10 then break end

      echo
      printPrompt()
    end
    echo
    # Go to next line so that further actions to overwrite
    # the choice
    @win.setpos(@win.cury() + 1, @parent.winPadding())
  end

  def data
    if @state == false then return "0" end
    "1"
  end 

end

class GetStringAction < PromptAction

  def execute()
    printPrompt()
    @data = @win.getstr()
  end

end

class GetIntegerAction < PromptAction

  def execute()
   x = @parent.winPadding()
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
    unless @actions.nil?
      @actions.each  do |action|
         action.setParentAction(self)
      end
    end
 
  end

  def beforeActions()
    # Stub for classes that extend
  end

  def afterActions()
    # Stub for classes that extend
  end

  def winPadding()
    return 2
  end

  def winWidth()
    Curses.cols - winPadding()
  end

  def winHeight()
    Curses.lines - winPadding()
  end

  def createWindow()
    @win = Window.new( winHeight(), winWidth(), 
                       winPadding()/2, winPadding()/2)

    # Assign window to actions
    unless @actions.nil?
      @actions.each  do |action|
         action.setWindow(@win)
      end
    end
    @win.clear
    @win.box("|", "-")
  end

  def execute()
    createWindow()
    echo

    y = @win.cury + 1
    @win.setpos(y,winPadding())

    self.beforeActions()
    
    @actions.each  do |action|
      action.execute
      #y = @win.cury + 1
      #@win.setpos(y,winPadding())
    end

    self.afterActions()

    noecho
    @win.clear 
    @win.refresh
    @win.close
  end

  def printLine(string)
    @win.setpos(@win.cury(), winPadding())
    @win.addstr(string)
    @win.setpos(@win.cury() + 1, winPadding())
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

  def winHeight()
     return 7 + @actions.length
  end

  def afterActions()
    preparedSql = @sql
    @actions.each do |action|
      preparedSql = preparedSql.sub("%s", action.data)
    end

    self.promptToChangeData(preparedSql)
  end

end
