class CountAction < PPCurses::InsertSQLDataAction

  def initialize(db)

    @db = db

    begin
      statement = @db.prepare('SELECT DISTINCT event FROM countTable ORDER BY event ASC')
      rs = statement.execute

      menu_items = []
      rs.each do |row|
        menu_items.push(row[0])
      end

      @count_menu = PPCurses::Menu.new( menu_items, nil )
      @count_menu.set_global_action(self)
    ensure
      statement.close
    end

    @sql = 'INSERT into countTable(event) values (?)'

    super( [ ], @sql, db )
  end


  def menu
    @count_menu
  end

  def show
    @count_menu.show
  end

  def menu_selection
    @count_menu.menu_selection
  end

  def winHeight
      9
  end
 
  def count_name
    @count_menu.selected_menu_name
  end


  def after_actions
    user_display_sql = @sql.sub('?', count_name)
    data_array = []
    data_array.push(count_name)

    new_data_added = self.prompt_to_change_data(user_display_sql, data_array)

    if new_data_added
      @db.data_added_to('countTable')
    end
  end


end

