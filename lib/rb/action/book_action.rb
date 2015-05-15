class ReadingAction

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize
    @form = PPCurses::Form.new
     
    @title =  PPCurses::InputElement.new('   Title', 30)
    @author =  PPCurses::InputElement.new('  Author', 30)
    @pages =  PPCurses::InputElement.new_integer_only('   Pages', 10)
    @format =   PPCurses::RadioButtonGroup.new(' Format', %w(Digital Analog) )
     
    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
    
    @form.add(@title)
    @form.add(@author)
    @form.add(@pages)
    @form.add(@format)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end

  def clear
    @form.clear    
  end

end


# @deprecated.  Remove in Tallyman 1.4.
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