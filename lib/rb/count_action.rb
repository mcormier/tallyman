require "ppcurses"

class CountAction < PPCurses::InsertSQLDataAction

  def initialize(db)

    @db = db

    begin
      statement = @db.prepare('SELECT DISTINCT event FROM countTable ORDER BY event ASC')
      rs = statement.execute()

      menuItems = []
      rs.each do |row|
        menuItems.push(row[0])
      end

      @countMenu = PPCurses::Menu.new( menuItems, nil )
      @countMenu.setGlobalAction(self)
    ensure
      statement.close()
    end

    @sql = 'INSERT into COUNTTABLE(event) values (?)'

    super( [ ], @sql, db )
  end


  def menu()
    @countMenu
  end

  def show()
    @countMenu.show()
  end

  def getMenuSelection()
    @countMenu.getMenuSelection()
  end

  def winHeight()
      9
  end
 
  def countName()
    @countMenu.getSelectedMenuName()
  end
  

  def beforeActions()
  end

  def afterActions()
    userDisplaySQL = @sql.sub('?', countName() )
    dataArray = []
    dataArray.push(countName())

    self.promptToChangeData(userDisplaySQL, dataArray)
  end


end

