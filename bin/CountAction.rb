require "ppcurses"

class CountAction < PPCurses::GetDataAction 

  def initialize(db)

    @db = db

    begin
      statement = @db.prepare"SELECT DISTINCT event FROM countTable ORDER BY event ASC"
      rs = statement.execute    

      menuItems = []
      rs.each do |row|
        menuItems.push(row[0])
      end

      @countMenu = PPCurses::Menu.new( menuItems, nil )
      @countMenu.setGlobalAction(self)
    ensure
      statement.close
    end
    
    super( [ ] )

    @sql = "INSERT into COUNTTABLE(event) values ('%s')"                 

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
     return 9
  end
 
  def countName()
    @countMenu.getSelectedMenuName()
  end
  

  def beforeActions()
  end

  def afterActions()
    preparedSql = @sql.sub("%s", countName() )

    self.promptToChangeData(preparedSql)
  end

end

