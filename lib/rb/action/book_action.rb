require 'ppcurses'

class BookAction < PPCurses::InsertSQLDataAction

  def initialize(db)
    @db = db

    super( [PPCurses::GetStringAction.new('Book title: '),
            PPCurses::GetStringAction.new('Author: '),
            PPCurses::GetIntegerAction.new('Number of pages: '),
            PPCurses::GetBooleanAction.new('Digital? '), ],
          'INSERT into books(title, author, pages, digital) values (?, ?, ?, ?)', db )
  end

  def after_actions
    new_data_added = super

    if new_data_added then
      @db.data_added_to('books')
    end

  end

end