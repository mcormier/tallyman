class ValueAction  < PPCurses::InsertSQLDataAction
  def initialize(db)
    @db = db;

    begin
      statement = @db.prepare('SELECT DISTINCT event FROM valueTable ORDER BY event ASC')
      rs = statement.execute

      menu_items = []
      rs.each do |row|
        menu_items.push(row[0])
      end

      @value_menu = PPCurses::Menu.new( menu_items, nil )
      @value_menu.set_global_action(self)
    ensure
      statement.close
    end

    @sql = 'INSERT into valueTable(event, value) values (?,?)'
    @prompt  = PPCurses::GetIntegerAction.new('Value : ')

    super( [ @prompt ], @sql, db )

  end


  def menu
    @value_menu
  end

  def show
    @value_menu.show
  end

  def value_name
    @value_menu.selected_menu_name
  end

  def before_actions
    self.print_line('Input data for ' +  @value_menu.selected_menu_name )
  end

  def after_actions
    prepared_sql = @sql.sub('%s', value_name )
    prepared_sql = prepared_sql.sub('%s', @prompt.data )


    new_data_added = self.prompt_to_change_data(prepared_sql, [value_name, @prompt.data ])

    if new_data_added then
      @db.data_added_to('valueTable')
    end

  end

end